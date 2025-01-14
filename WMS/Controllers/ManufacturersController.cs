﻿using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using CommonLogics;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using WMS.Models.Entities;
using WMS.Models.PageModels.ManufacturersVM;
using X.PagedList;

namespace WMS.Controllers
{
    public class ManufacturersController : Controller
    {
        #region Global Variables
        private readonly WMSDBContext _context;
        private readonly CommonFunctions _cmnFunction;
        private readonly IHostingEnvironment _he;
        #endregion

        #region Constructor
        public ManufacturersController(
          WMSDBContext context,
       CommonFunctions cmnFunction,
       IHostingEnvironment he
    )
        {
            _context = context;
            _cmnFunction = cmnFunction;
            _he = he;
        }
        #endregion

        #region GetMethods
        public async Task<IActionResult> Manufacturers(int? page)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var manufacturer = from m in _context.Manufacturer
                         select new ListManufacturerVM { Manufacturer = m };

            var result = manufacturer.ToPagedList(pageNumber, pageRowSize);

            return View(result);
        }

        [HttpGet, ActionName("CreateManufacturer")]
        public async Task<IActionResult> Create()
        {
            return PartialView("_CreateManufacturer", new CreateManufacturerVM());
        }

        [HttpGet, ActionName("EditManufacturer")]
        public async Task<IActionResult> Edit(long? id)
        {
            if (id != 0)
            {
                var exManufacturer = await _context.Manufacturer.Where(b => b.Id == id).FirstOrDefaultAsync();
                var returnModel = new EditManufacturerVM() { Manufacturer = exManufacturer };
                return PartialView("_UpdateManufacturer", returnModel);
            }
            else
            {
                return PartialView("_UpdateManufacturer", new EditManufacturerVM());
            }
        }
        #endregion

        #region PostMethods

        [HttpPost, ActionName("CreateManufacturer")]
        public async Task<JsonResult> Create(CreateManufacturerVM model)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    _context.Manufacturer.Add(model.Manufacturer);
                    await _context.SaveChangesAsync();

                    if (model.Manufacturer.Id > 0)
                    {
                        if (model.file != null)
                        {
                            string extension = Path.GetExtension(model.file.FileName);
                            string smallImage = "StaticFiles/Manufacturers/SmallImage/";
                            string bigImage = "StaticFiles/Manufacturers/BigImage/";

                            if (_cmnFunction.SaveImage(model.file, model.Manufacturer.Id.ToString(), Path.Combine(_he.WebRootPath, smallImage), extension, 60, 60))
                            {
                                model.Manufacturer.SmallImage = smallImage + model.Manufacturer.Id.ToString() + extension;
                            }

                            if (_cmnFunction.SaveImage(model.file, model.Manufacturer.Id.ToString(), Path.Combine(_he.WebRootPath, bigImage), extension))
                            {
                                model.Manufacturer.BigImage = bigImage + model.Manufacturer.Id.ToString() + extension;
                            }

                            _context.Entry(model.Manufacturer).State = EntityState.Modified;
                            await _context.SaveChangesAsync();
                        }
                    }
                    return result = Json(new { success = true, message = "Manufacturer successfully created.", redirectUrl = @"/Manufacturers/Manufacturers" });
                }
                else
                    return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Users/Create: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpPost, ActionName("EditManufacturer")]
        public async Task<JsonResult> Edit(EditManufacturerVM model)
        {
            var result = (dynamic)null;

            try
            {
                if (model.Manufacturer.Id <= 0)
                {
                    return result = Json(new { success = false, message = " Record is not found", redirectUrl = @"/Manufacturers/Manufacturers" });
                }

                var exManufacturer = await _context.Manufacturer.FindAsync(model.Manufacturer.Id);
                exManufacturer.ManufacturerName = model.Manufacturer.ManufacturerName;

                _context.Manufacturer.Update(exManufacturer);
                await _context.SaveChangesAsync();

                if (model.file != null)
                {
                    //Delete previous physical image if exist
                    if (!string.IsNullOrEmpty(exManufacturer.SmallImage))
                    {
                        _cmnFunction.DeleteStaticFile(Path.Combine(_he.WebRootPath, exManufacturer.SmallImage));
                    }
                    if (!string.IsNullOrEmpty(exManufacturer.BigImage))
                    {
                        _cmnFunction.DeleteStaticFile(Path.Combine(_he.WebRootPath, exManufacturer.BigImage));
                    }

                    string smallImage = "StaticFiles/Manufacturers/SmallImage/";
                    string bigImage = "StaticFiles/Manufacturers/BigImage/";
                    string extension = Path.GetExtension(model.file.FileName);

                    //Place updated image into server
                    if (_cmnFunction.SaveImage(model.file, model.Manufacturer.Id.ToString(), Path.Combine(_he.WebRootPath, smallImage), extension, 60, 60))
                    {
                        exManufacturer.SmallImage = smallImage + model.Manufacturer.Id.ToString() + extension;
                    }

                    if (_cmnFunction.SaveImage(model.file, model.Manufacturer.Id.ToString(), Path.Combine(_he.WebRootPath, bigImage), extension))
                    {
                        exManufacturer.BigImage = bigImage + model.Manufacturer.Id.ToString() + extension;
                    }
                }

                _context.Entry(exManufacturer).State = EntityState.Modified;
                await _context.SaveChangesAsync();

                return result = Json(new { success = true, message = "Record successfully updated", redirectUrl = @"/Manufacturers/Manufacturers" });
            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Manufacturer/EditManufacturer " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpPost, ActionName("DeleteManufacturer")]
        public async Task<JsonResult> Delete(Manufacturer model)
        {
            var result = (dynamic)null;
            try
            {
                var manufacturer = await _context.Manufacturer.Where(c => c.Id == model.Id).FirstOrDefaultAsync();

                if (manufacturer != null)
                {
                    //Delete  physical image file
                    if (!string.IsNullOrEmpty(manufacturer.BigImage))
                        _cmnFunction.DeleteStaticFile(Path.Combine(_he.WebRootPath, manufacturer.BigImage));

                    if (!string.IsNullOrEmpty(manufacturer.SmallImage))
                        _cmnFunction.DeleteStaticFile(Path.Combine(_he.WebRootPath, manufacturer.SmallImage));

                    _context.Manufacturer.Remove(manufacturer);
                    await _context.SaveChangesAsync();

                    return result = Json(new { success = true, message = " Record successfully deleted.", redirectUrl = @"/Manufacturers/Manufacturers" });
                }
                else
                    return result = Json(new { success = false, message = " Record is not found.", redirectUrl = "" });
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        #endregion

        //#region RemoteValidation
        //[AcceptVerbs("Get", "Post")]
        //[AllowAnonymous]
        //public JsonResult IsEmailExist(CreateUserVM user)
        //{
        //    var email = _context.Users.Where(u => u.Email == user.Users.Email).SingleOrDefault();
        //    if (email == null)
        //    {
        //        return Json(true);
        //    }
        //    else
        //    {
        //        return Json($"\"{user.Users.Email}\" is already used.");
        //    }
        //}
        //#endregion RemoteValidation

        #region SearchMethods
        [Produces("application/json")]
        [HttpGet, ActionName("ManufacturerSearch")]
        public async Task<IActionResult> Search()
        {
            try
            {
                string term = HttpContext.Request.Query["term"].ToString();
                var manufacturerNames = await _context.Manufacturer.Where(p => p.ManufacturerName.Contains(term)).Select(p => p.ManufacturerName).ToListAsync();
                return Ok(manufacturerNames);
            }
            catch
            {
                return BadRequest();
            }
        }

        [HttpGet, ActionName("SearchResult")]
        public async Task<IActionResult> SearchPeople(string manufacturer)
        {
            var pageNumber = 1;
            int pageRowSize = 10;

            var man = from m in _context.Manufacturer
                         where m.ManufacturerName.Contains(manufacturer)
                         select new ListManufacturerVM { Manufacturer =  m};

            var result = man.ToPagedList(pageNumber, pageRowSize);
            ViewData["SearchValue"] = manufacturer;

            return View("SearchManufacturer", result);
        }
        #endregion











        #region Old
        // GET: Manufacturers
        public async Task<IActionResult> Index()
        {
            return View(await _context.Manufacturer.ToListAsync());
        }

        // GET: Manufacturers/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var manufacturer = await _context.Manufacturer
                .FirstOrDefaultAsync(m => m.Id == id);
            if (manufacturer == null)
            {
                return NotFound();
            }

            return View(manufacturer);
        }

        // POST: Manufacturers/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,ManufacturerName,ContactInfo,SmallImage,BigImage")] Manufacturer manufacturer)
        {
            if (ModelState.IsValid)
            {
                _context.Add(manufacturer);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(manufacturer);
        }

        // GET: Manufacturers/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var manufacturer = await _context.Manufacturer.FindAsync(id);
            if (manufacturer == null)
            {
                return NotFound();
            }
            return View(manufacturer);
        }

        // POST: Manufacturers/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,ManufacturerName,ContactInfo,SmallImage,BigImage")] Manufacturer manufacturer)
        {
            if (id != manufacturer.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(manufacturer);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ManufacturerExists(manufacturer.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(manufacturer);
        }

        // GET: Manufacturers/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var manufacturer = await _context.Manufacturer
                .FirstOrDefaultAsync(m => m.Id == id);
            if (manufacturer == null)
            {
                return NotFound();
            }

            return View(manufacturer);
        }

        // POST: Manufacturers/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var manufacturer = await _context.Manufacturer.FindAsync(id);
            _context.Manufacturer.Remove(manufacturer);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ManufacturerExists(int id)
        {
            return _context.Manufacturer.Any(e => e.Id == id);
        }
        #endregion





    }
}
