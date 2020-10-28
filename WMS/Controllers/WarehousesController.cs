using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using WMS.Models.Entities;
using WMS.Models.PageModels.WarehouseVM;
using WMS.Models.PageModels.WarehouseVM.WarehouseCapacityVM;
using X.PagedList;
using ZXing;

namespace WMS.Controllers
{
    public class WarehousesController : Controller
    {
        private readonly WMSDBContext _context;

        public WarehousesController(WMSDBContext context)
        {
            _context = context;
        }

        #region GetMethods
        public async Task<IActionResult> Warehouse(int? page)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var warehouse = await _context.Warehouse.ToListAsync();
            var result = warehouse.ToPagedList(pageNumber, pageRowSize);

            return View(result);
        }

        [HttpGet, ActionName("CreateWarehouse")]
        public async Task<IActionResult> Create()
        {
            return PartialView("_CreateWarehouse", new Warehouse());
        }
        
        [HttpGet, ActionName("CreateWarehouseCapacity")]
        public async Task<IActionResult> CreateWarehouseCapasity()
        {
            ViewData["Warehouse"] = new SelectList(await _context.Warehouse.ToListAsync(), "Id", "Title");
            return PartialView("WarehouseCapacity/_CreateWarehouseCapacity", new WarehouseCapacityDefination());
        }

        [HttpGet, ActionName("EditWarehouse")]
        public async Task<IActionResult> Edit(int? id)
        {
            if (id != 0)
            {
                    var warehouse = await _context.Warehouse.FindAsync(id);
                    return PartialView("_UpdateWarehouse", warehouse);
            }
            else
            {
                return PartialView("_UpdateWarehouse", new Warehouse());
            }
        }

        public async Task<IActionResult> WarehouseCapacity(int? page)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var warehousewithReckCapacity = _context.Warehouse.Select(w => 
            new WarehouseCapacityVM { 
                Warehouse = w,
                WarehouseCapacity = _context.WarehouseCapacityDefination.Where(wc => wc.WarehouseId == w.Id)
            });

            var result = warehousewithReckCapacity.ToPagedList(pageNumber, pageRowSize);
            return View("WarehouseCapacity/WarehouseCapacity", result);
        }

        public async Task<IActionResult> WarehouseView(int? page)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var warehouseCapasity = from wc in _context.WarehouseCapacityDefination
                                    join wh in _context.Warehouse on wc.WarehouseId equals wh.Id
                                    select new ListWarehouseCapasity
                                    {
                                        WarehouseCapacity = wc,
                                        Warehouse = wh,
                                        ListReck = _context.Reck.Where(r => r.WarehouseId == wc.WarehouseId),
                                       // IsSpaceAvailable = _context.Reck.Where(r => r.WarehouseId == wc.WarehouseId).Count() < wc.ReckQuantity ? true : false
                                    };
            
            var result = new WarehouseCapasityVM()
            {
                ListWarehouseCapacity = warehouseCapasity,
            };

            return View(result);
        }


        public async Task<IActionResult> Reck(int? page)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var lstReck = new List<ListReckVM>();
            var warehouseCapasity = from r in _context.Reck
                                    join wh in _context.Warehouse on r.WarehouseId equals wh.Id
                                    select new ListReckVM { Reck = r, Warehouse = wh };
            lstReck = await warehouseCapasity.ToListAsync();
            var result = lstReck.ToPagedList(pageNumber, pageRowSize);

            return View(result);
        }



        [HttpGet, ActionName("CreateReck")]
        public IActionResult CreateReck(int reckQuantity, int warehouseId, int row, int column)
        {
            var reck = new Reck()
            {
                WarehouseId = warehouseId,
                SetupRow = row,
                SetupColumn = column
            };

            var warehouseCapasity = new WarehouseCapacityDefination()
            {
                ReckQuantity = reckQuantity
            };


            var model = new ReckVM()
            {
                Reck = reck,
                WarehouseCapacity = warehouseCapasity
            };


            return PartialView("_CreateReck", model);
        }

        #endregion

        #region PostMethods

        [HttpPost, ActionName("CreateWarehouse")]
        public async Task<JsonResult> CreateWarehouse(Warehouse obj)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    obj.IsActive = true;
                    _context.Warehouse.Add(obj);
                    await _context.SaveChangesAsync();
                    return result = Json(new { success = true, message = "Warehouse successfully created.", redirectUrl = @"/Warehouses/Warehouse" });
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

        [HttpPost, ActionName("CreateWarehouseCapacity")]
        public async Task<JsonResult> CreateWarehouseCapacity(WarehouseCapacityDefination obj)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    obj.IsActive = true;
                    _context.WarehouseCapacityDefination.Add(obj);
                    await _context.SaveChangesAsync();
                    return result = Json(new { success = true, message = "Warehouse Capacity successfully created.", redirectUrl = @"/Warehouses/WarehouseCapacity" });
                }
                else
                    return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Warehouses/CreateWarehouseCapacity: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpPost, ActionName("EditWarehouse")]
        public async Task<JsonResult> Edit(Warehouse obj)
        {
            var result = (dynamic)null;

            try
            {
                if (obj.Id <= 0)
                {
                    return result = Json(new { success = false, message = " Record is not found", redirectUrl = @"/Warehouses/Warehouse" });
                }

                obj.Title = obj.Title;
                obj.Location = obj.Location;
                _context.Entry(obj).State = EntityState.Modified;
                await _context.SaveChangesAsync();

                return result = Json(new { success = true, message = "Record successfully updated", redirectUrl = @"/Warehouses/Warehouse" });
            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Users/EditPeople " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpPost, ActionName("Delete")]
        public async Task<JsonResult> Delete(Warehouse model)
        {
            var result = (dynamic)null;
            try
            {
                var wh = await _context.Warehouse.FindAsync(model.Id);

                if (wh != null)
                {
                    _context.Warehouse.Remove(wh);
                    await _context.SaveChangesAsync();

                    return result = Json(new { success = true, message = " Record successfully deleted.", redirectUrl = @"/Warehouses/Warehouse" });
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
        
        [HttpPost, ActionName("DeleteWarehouseCapasity")]
        public async Task<JsonResult> DeleteWarehouseCapasity(WarehouseCapacityDefination model)
        {
            var result = (dynamic)null;
            try
            {
                var wh = await _context.WarehouseCapacityDefination.FindAsync(model.Id);

                if (wh != null)
                {
                    _context.WarehouseCapacityDefination.Remove(wh);
                    await _context.SaveChangesAsync();

                    return result = Json(new { success = true, message = " Record successfully deleted.", redirectUrl = @"/Warehouses/WarehouseCapacity" });
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

        [HttpPost, ActionName("CreateReck")]
        public async Task<JsonResult> CreateReck(ReckVM obj)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {

                    var isReckExist = _context.Reck.Where(r => r.SetupRow == obj.Reck.SetupRow && r.SetupColumn == obj.Reck.SetupColumn && r.WarehouseId == obj.Reck.WarehouseId);
                    if (isReckExist.Count() >= obj.WarehouseCapacity.ReckQuantity)
                    {
                        return result = Json(new { success = false, message = "No more space available to set new reck on this position base on designed!", redirectUrl = "" });
                    }

                    obj.Reck.IsActive = true;
                    _context.Reck.Add(obj.Reck);
                    await _context.SaveChangesAsync();

                    for (int i = 1; i <= obj.Reck.ReckLevel; i++)
                    {
                        var createSpace = new ItemSpace() {
                            WarehouseId = obj.Reck.WarehouseId,
                            ReckId = obj.Reck.Id,
                            ReckLevel = i,
                            IsAllocated = false,
                            ActionedBy = 0
                        };
                        _context.ItemSpace.Add(createSpace);
                        await _context.SaveChangesAsync();
                    }


                    return result = Json(new { success = true, message = "New reck successfully assigned.", redirectUrl = @"/Warehouses/WarehouseView" });
                }
                else
                    return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Warehouses/CreateReck: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }
        #endregion

    }
}
