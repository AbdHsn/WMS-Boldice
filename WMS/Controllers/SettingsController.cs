using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mime;
using System.Threading.Tasks;
using System.Transactions;
using CommonLogics;
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

        #region Database

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
    }
}
