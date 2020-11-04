using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Security.Claims;
using System.Threading.Tasks;
using CommonLogics;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore.Internal;
using WMS.CommonBusinessFunctions;
using WMS.Models.Entities;
using WMS.Models.PageModels.SettingsVM;
using WMS.Models.SharedModels;
using X.PagedList;


namespace WMS.Controllers
{
    public class AccountsController : Controller
    {

        #region Global Variables
        private readonly WMSDBContext _context;
        private readonly CommonFunctions _cmnFunction;
        private readonly CommonBusinessLogics _cmnBusinessFunction;
        private readonly IHostingEnvironment _he;
        #endregion

        #region Constructor
        public AccountsController(
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

        #region Account Registration & Login
        [AllowAnonymous]
        [HttpPost, ActionName("Login")]
        public async Task<JsonResult> Login(Users model)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {

                    //[Hints: Check user is exist or not base on user's input]
                    var isAuthentic = (from user in _context.Users
                                      where (user.Password == model.Password) && (user.Email == model.Email || user.UserName == model.UserName)
                                      select user).FirstOrDefault();

                    if (isAuthentic == null)
                    {
                        return result = Json(new { success = false, message = "Failed! Please recheck your email and password.", redirectUrl = "" });
                    }

                    //Sending activation email using email templete: if sending fail, return.
                    //string href = _appSettings.ClientSideURL + "/operations/account-activation/" + tempField + "/" + createCustomer.Email;
                    //if (!_cmnFunction.SendEmail("QS Ecommerce", "taher279279279@gmail.com", "O181905021o", (createCustomer.Fname + " " + createCustomer.Lname), createCustomer.Email, "Account Activation", href, "smtp.gmail.com", 587, false, _hostingEnvironment.WebRootPath))
                    //{
                    //    reqMsg.Message = "Failed to send activation to your mail. Contact with IT support Team.";
                    //    reqMsg.ProcessCode = false;
                    //    return reqMsg;
                    //}

                    var getAuthorization = from a in _context.Authorizations
                                           where a.UserId == model.Id && a.IsActive == true
                                           join at in _context.AuthorizeType
                                           on a.AuthorizeTypeId equals at.Id
                                           select new { a, at };

                    //Create login creadential for user....
                    var claims = new List<Claim>();
                    foreach (var item in getAuthorization)
                    {
                        claims.Add(new Claim(ClaimTypes.Role, item.at.TypeName));
                    }
                    claims.Add(new Claim(ClaimTypes.NameIdentifier, model.Id.ToString()));

                    //  create identity 
                    ClaimsIdentity identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    //  create principal
                    ClaimsPrincipal principal = new ClaimsPrincipal(identity);
                    //  sign-in
                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

                    return result = Json(new { success = true, message = "Login succeed ", redirectUrl = @"/Home/Dashboard" });

                }
                else
                    return result = Json(new { success = false, message = "Login can't process, inputs are invalid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Settings/Login: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction("Home", "Home");
        }

        [AllowAnonymous]
        [HttpPost, ActionName("Registration")]
        public async Task<JsonResult> Registration(Users model)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    var isUserExist = _context.Users.Where(u => u.Email == model.Email).FirstOrDefault();
                    if (isUserExist != null)
                    {
                        return result = Json(new { success = false, message = "Failed registration. Email already exist.", redirectUrl = "" });
                    }

                    //Sending activation email using email templete: if sending fail, return.
                    //string href = _appSettings.ClientSideURL + "/operations/account-activation/" + tempField + "/" + createCustomer.Email;
                    //if (!_cmnFunction.SendEmail("QS Ecommerce", "taher279279279@gmail.com", "O181905021o", (createCustomer.Fname + " " + createCustomer.Lname), createCustomer.Email, "Account Activation", href, "smtp.gmail.com", 587, false, _hostingEnvironment.WebRootPath))
                    //{
                    //    reqMsg.Message = "Failed to send activation to your mail. Contact with IT support Team.";
                    //    reqMsg.ProcessCode = false;
                    //    return reqMsg;
                    //}

                    //Inserting new user.
                    model.UserTypeId = (int)StaticValues.UserTypes.Customer;
                    _context.Users.Add(model);
                    _context.SaveChanges();

                    //Inserting new authorization.
                    var createAuthorization = new Authorizations()
                    {
                        UserId = model.Id,
                        AuthorizeTypeId = (int)StaticValues.UserTypes.Customer,
                        IsActive = true,
                        AuthorizedDate = DateTime.UtcNow
                    };
                    _context.Add(createAuthorization);
                    _context.SaveChanges();

                    var getAuthorization = from a in _context.Authorizations
                                           where a.UserId == model.Id && a.IsActive == true
                                           join at in _context.AuthorizeType
                                           on a.AuthorizeTypeId equals at.Id
                                           select new { a, at };

                    //Create login creadential for user....
                    var claims = new List<Claim>();
                    foreach (var item in getAuthorization)
                    {
                        claims.Add(new Claim(ClaimTypes.Role, item.at.TypeName));
                    }
                    claims.Add(new Claim(ClaimTypes.NameIdentifier, model.Id.ToString()));

                    //  create identity 
                    ClaimsIdentity identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
                    //  create principal
                    ClaimsPrincipal principal = new ClaimsPrincipal(identity);
                    //  sign-in
                    await HttpContext.SignInAsync(CookieAuthenticationDefaults.AuthenticationScheme, principal);

                    return result = Json(new { success = true, message = "Registration Completed ", redirectUrl = @"/Home/Dashboard" });

                }
                else
                    return result = Json(new { success = false, message = "Registration Invalid!!!", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Products/InsertProductItem: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        #endregion

    }
}
