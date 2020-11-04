using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Transactions;
using CommonLogics;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;
using Newtonsoft.Json;
using WMS.CommonBusinessFunctions;
using WMS.CommonBusinessFunctions.BusinessModels;
using WMS.Models.Entities;
using WMS.Models.PageModels.ReportsVM.GetOrderByDateRange;
using WMS.Models.PageModels.ReportsVM.GetOrderDispatchByDateRange;
using WMS.Models.PageModels.ReportsVM.GetOrderReturnByDateRange;
using WMS.Models.PageModels.SettingsVM;
using WMS.Models.SharedModels;
using X.PagedList;


namespace WMS.Controllers
{
    public class SettingsController : Controller
    {

        #region Global Variables
        private readonly WMSDBContext _context;
        private readonly CommonFunctions _cmnFunction;
        private readonly CommonBusinessLogics _cmnBusinessFunction;
        private readonly IHostingEnvironment _he;
        #endregion

        #region Constructor
        public SettingsController(
               WMSDBContext context,
               CommonFunctions cmnFunction,
               CommonBusinessLogics cmnBusinessFunction,
               IHostingEnvironment he
        )
        {
            _context = context;
            _cmnFunction = cmnFunction;
            _cmnBusinessFunction = cmnBusinessFunction;
            _he = he;
        }
        #endregion

        #region Database Backup

        [HttpGet, ActionName("CreateDatabaseBackup")]
        public async Task<IActionResult> CreateDatabaseBackup()
        {
            try
            {
                Directory.CreateDirectory(Path.Combine(_he.WebRootPath, "StaticFiles/Database/"));
                string savePath = _he.WebRootPath + "\\StaticFiles\\Database\\WMSDB.bak";
                string backupCommand = @"BACKUP DATABASE WMSDB TO DISK = '" + savePath + "'";

                _cmnFunction.DeleteStaticFile(Path.Combine(_he.WebRootPath, "StaticFiles/Database/WMSDB.bak"));

                var data = _cmnFunction.ExecuteRawSQL(backupCommand);
            }
            catch (Exception)
            {

            }
            return View();
        }

        [HttpGet, ActionName("DownloadDatabaseBackup")]
        public FileResult DownloadDatabaseBackup()
        {
            string path = Path.Combine(_he.WebRootPath, "StaticFiles/Database/WMSDB.bak");
            if ((System.IO.File.Exists(path)))
            {
                byte[] fileBytes = System.IO.File.ReadAllBytes(path);
                return File(fileBytes, MediaTypeNames.Application.Octet, "WMSDB.bak");
            }
            byte[] nullFile = System.IO.File.ReadAllBytes(Path.Combine(_he.WebRootPath, "StaticFiles/badfile"));
            return File(nullFile, MediaTypeNames.Application.Octet, "BadFile");
        }

        #endregion

        #region Assign User Role
        public async Task<IActionResult> AssignUserRole(int? page)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var users = from u in _context.Users
                        where u.UserTypeId != 4
                        join p in _context.PersonalDetail on u.Id equals p.UserId
                        join ut in _context.UserType on u.UserTypeId equals ut.Id
                        select new AssignUserRoleVM()
                        {
                            Users = u,
                            PersonalDetail = p,
                            UserType = ut,
                            ListAuthorization = from a in _context.Authorizations
                                                where a.UserId == u.Id
                                                join at in _context.AuthorizeType on a.AuthorizeTypeId equals at.Id
                                                select new ListAuthorizations
                                                {
                                                    Authorizations = a,
                                                    AuthorizeType = at
                                                }
                        };

            var result = users.ToPagedList(pageNumber, pageRowSize);
            return View(result);
        }

        [HttpGet, ActionName("EditUserRole")]
        public ActionResult EditUserRole(long? id)
        {
            if (id != 0)
            {
                var user = (from u in _context.Users
                           where u.UserTypeId != 4 && u.Id == id
                           join p in _context.PersonalDetail on u.Id equals p.UserId
                           join ut in _context.UserType on u.UserTypeId equals ut.Id
                           select new EditUserRoleVM { 
                             Users = u,
                             PersonalDetail = p,
                             UserType = ut,
                             ListAuthorization = from a in _context.Authorizations
                                                 where a.UserId == u.Id
                                                 join at in _context.AuthorizeType on a.AuthorizeTypeId equals at.Id
                                                 select new EditListAuthorizations
                                                 {
                                                     Authorizations = a,
                                                     AuthorizeType = at
                                                 }
                           }).FirstOrDefault();

                if (user == null)
                {
                    ViewData["msg"] = "Data is not found!";
                    return PartialView("_EditUserRole", new EditUserRoleVM());
                }

                ViewData["AuthorizationType"] = new SelectList(_context.AuthorizeType.ToList(), "Id", "TypeName");
                return PartialView("_EditUserRole", user);
            }
            else
            {
                ViewData["msg"] = "Request can't proceed!";
                return PartialView("_EditUserRole", new EditUserRoleVM());
            }
        }

        [HttpPost, ActionName("EditUserRole")]
        public async Task<JsonResult> EditUserRole(EditUserRoleVM model)
        {
            var result = (dynamic)null;

            try
            {
                if (model.Users.Id <= 0)
                {
                    return result = Json(new { success = false, message = " Record could not save.", redirectUrl = "" });
                }


                foreach (var item in model.AuthorizationTypeId)
                {
                    var auth = new Authorizations()
                    {
                        UserId = model.Users.Id,
                        AuthorizeTypeId = item,
                        IsActive = true,
                        AuthorizedDate = DateTime.UtcNow  
                    };
                    _context.Authorizations.Add(auth);
                    await _context.SaveChangesAsync();
                }

                return result = Json(new { success = true, message = "New authorizaiton successfully created", redirectUrl = @"/Settings/AssignUserRole" });
            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Settings/EditUserRole " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpPost, ActionName("DeleteAssignedUserRole")]
        public async Task<JsonResult> DeleteAssignedUserRole(Authorizations model)
        {
            var result = (dynamic)null;
            try
            {
                var authorization = await _context.Authorizations.FindAsync(model.Id);

                if (authorization != null)
                {
                    _context.Authorizations.Remove(authorization);
                    await _context.SaveChangesAsync();

                    return result = Json(new { success = true, message = " Record successfully deleted.", redirectUrl = @"/Settings/AssignUserRole" });
                }
                else
                    return result = Json(new { success = false, message = "Record is not found.", redirectUrl = "" });
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }

        }

        #endregion
    }
}
