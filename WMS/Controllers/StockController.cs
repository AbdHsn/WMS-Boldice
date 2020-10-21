using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;
using CommonLogics;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using WMS.CommonBusinessFunctions;
using WMS.CommonBusinessFunctions.BusinessModels;
using WMS.Models.Entities;
using WMS.Models.PageModels.StockVM;
using WMS.Models.SharedModels;
using X.PagedList;

namespace WMS.Controllers
{
    public class StockController : Controller
    {

        #region Global Variables
        private readonly WMSDBContext _context;
        private readonly CommonFunctions _cmnFunction;
        private readonly CommonBusinessLogics _cmnBusinessFunction;
        private readonly IHostingEnvironment _he;
        #endregion

        #region Constructor
        public StockController(
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

        #region Stock GetMethods
        //public async Task<IActionResult> Stock(int? page, int? ddlId)
        //{
        //    var pageNumber = page ?? 1;
        //    int pageRowSize = 10;
        //    int productType = ddlId ?? 0;

        //    var products = new List<ListStockVM>();

        //    if (productType == 0)
        //    {
        //        var getProducts = from s in _context.Stock
        //                          join p in _context.Products on s.ProductId equals p.Id
        //                          join pt in _context.ProductType on p.ProductTypeId equals pt.Id
        //                          select new ListStockVM
        //                          {
        //                              Stock = s,
        //                              Products = p,
        //                              ProductType = pt
        //                          };
        //        products = await getProducts.ToListAsync();
        //    }

        //    var result = products.ToPagedList(pageNumber, pageRowSize);
        //    return View("Stock", result);
        //}

        public async Task<IActionResult> Stock(int? page, int? ddlId)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;
            int productType = ddlId ?? 0;

            var getWarehouses = _context.Warehouse.ToList();

            var stockOfWarehouses = new List<StockOfWarehousesVM>();
            foreach (var item in getWarehouses)
            {
                var getListStock = from s in _context.Stock
                                   where s.WarehouseId == item.Id
                                   join p in _context.Products on s.ProductId equals p.Id
                                   join pt in _context.ProductType on p.ProductTypeId equals pt.Id
                                   select new ListOfStock
                                   {
                                       Stock = s,
                                       Products = p,
                                       ProductType = pt
                                   };

                var stockOfWarehouse = new StockOfWarehousesVM();
                stockOfWarehouse.Warehouse = item;
                stockOfWarehouse.ListOfStocks = getListStock.ToList();

                stockOfWarehouses.Add(stockOfWarehouse);
            }

            var result = stockOfWarehouses.ToPagedList(pageNumber, pageRowSize);
            return View("Stock", result);
        }

        public async Task<IActionResult> VirtualStore(int? page, string status = "")
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var getVirtualProduct = new List<ListVirtualSpaceVM>();

            if (string.IsNullOrEmpty(status))
            {
                //filtering this (getOrderReturnDetail) order return detail because of itemspaceid which is used to distinguish between Warehouse return and Virtual Space 
                var getOrderReturnDetail = _context.OrderReturnDetails.Where(ord => ord.ItemSpaceId == null);
               getVirtualProduct = (from vs in _context.VirtualSpace
                                  join pi in _context.ProductItems on vs.ProductItemId equals pi.Id
                                  join ord in getOrderReturnDetail on vs.ProductItemId equals ord.ProductItemId
                                  join or in _context.OrderReturn on ord.ReturnId equals or.Id
                                  join o in _context.Orders on or.OrderId equals o.Id
                                  join p in _context.Products on pi.ProductId equals p.Id
                                  
                                  select new ListVirtualSpaceVM
                                  {
                                      VirtualSpace = vs,
                                      ProductItems = pi,
                                      Orders = o,
                                      OrderReturn = or,
                                      Products = p
                                  }).Distinct(d => d.OrderReturn.Id).ToList();

            }
            else
            {
                var getOrderReturnDetail = _context.OrderReturnDetails.Where(ord => ord.ItemSpaceId == null);
                getVirtualProduct = (from vs in _context.VirtualSpace
                                     where vs.Status == status
                                     join pi in _context.ProductItems on vs.ProductItemId equals pi.Id
                                     join ord in getOrderReturnDetail on vs.ProductItemId equals ord.ProductItemId
                                     join or in _context.OrderReturn on ord.ReturnId equals or.Id
                                     join o in _context.Orders on or.OrderId equals o.Id
                                     join p in _context.Products on pi.ProductId equals p.Id

                                     select new ListVirtualSpaceVM
                                     {
                                         VirtualSpace = vs,
                                         ProductItems = pi,
                                         Orders = o,
                                         OrderReturn = or,
                                         Products = p
                                     }).Distinct(d => d.OrderReturn.Id).ToList();
            }

            var filterValues = new int[] { 8, 9 };
            ViewData["ddlStatus"] = new SelectList(from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

            ViewData["SelectedStatus"] = string.IsNullOrEmpty(status) ? "All" : status;
            ViewData["PageNumber"] = pageNumber;

            var result = getVirtualProduct.ToPagedList(pageNumber, pageRowSize);
            return View(result);
        }


        public async Task<IActionResult> StockTrace(int? page, long productId = 0, int warehouseId = 0)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var products = new List<ListStockTraceVM>();
            if (productId == 0)
            {
                var getProducts = from st in _context.StockTrace
                                  where st.WarehouseId == warehouseId
                                  join p in _context.Products on st.ProductId equals p.Id
                                  select new ListStockTraceVM
                                  {
                                      StockTrace = st,
                                      Products = p
                                  };
                products = await getProducts.ToListAsync();
            }
            else {
                var getProducts = from st in _context.StockTrace
                                  where st.ProductId == productId && st.WarehouseId == warehouseId
                                  join p in _context.Products on st.ProductId equals p.Id
                                  select new ListStockTraceVM
                                  {
                                      StockTrace = st,
                                      Products = p
                                  };
                products = await getProducts.ToListAsync();
            }

            var result = products.ToPagedList(pageNumber, pageRowSize);
            ViewData["productId"] = productId;
            ViewData["warehouseId"] = warehouseId;

            return View("StockTrace", result);
        }


        [HttpGet, ActionName("CreateStockAdjustment")]
        public async Task<IActionResult> CreateStockAdjustment()
        {
            ViewData["Product"] = new SelectList(await _context.Products.ToListAsync(), "Id", "Name");
            ViewData["Warehouse"] = new SelectList(await _context.Warehouse.ToListAsync(), "Id", "Title");
            return PartialView("_CreateStockAdjustment");
        }
        #endregion

        #region PurchaseItems PostMethods

        [HttpPost, ActionName("CreateStockAdjustment")]
        public async Task<JsonResult> CreateStockAdjustment(StockAdjustment model)
        {
            
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {

                    bool isIncrease = false;
                    if (model.Quantity > 0)
                    {
                        isIncrease = true;
                    }

                    if (isIncrease)
                    {
                        //Stock Adjustments is increasing....
                        switch (model.TargetOnEffect)
                        {
                            case "Stock":
                                {

                                    TransactionOptions options = new TransactionOptions();
                                    options.IsolationLevel = IsolationLevel.Serializable;
                                    options.Timeout = new TimeSpan(0, 10, 0);
                                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                                    {
                                        //Adjustment No Generate
                                        var getLastAdjustmentNo = _context.StockAdjustment.OrderByDescending(pu => pu.EntryDate).FirstOrDefault();
                                        if (getLastAdjustmentNo != null)
                                        {
                                            int creatAdjustmentNo = Convert.ToInt32(getLastAdjustmentNo.AdjustmentNo.Substring(10)) + 1;
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", creatAdjustmentNo.ToString());
                                        }
                                        else
                                        {
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", 1.ToString());
                                        }


                                        model.EntryDate = DateTime.UtcNow;
                                        model.TargetOnEffect = "Stock";
                                        _context.StockAdjustment.Add(model);
                                        _context.SaveChanges();

                                        //Stock Generate only once after loop
                                        var isStockExist = _context.Stock.Where(s => s.ProductId == model.ProductId && s.WarehouseId == model.WarehouseId).FirstOrDefault();
                                        if (isStockExist != null)
                                        {
                                            isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                                            isStockExist.AvailableQuantity += model.Quantity;
                                            isStockExist.LastUpdate = DateTime.UtcNow;

                                            _context.Stock.Update(isStockExist);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }
                                        else
                                        {
                                            var newStock = new Stock()
                                            {
                                                WarehouseId = model.WarehouseId,
                                                ProductId = model.ProductId,
                                                AvailableQuantity = model.Quantity,
                                                LastQuantity = 0,
                                                CreatedDate = DateTime.UtcNow
                                            };
                                            _context.Stock.Add(newStock);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }

                                        transaction.Complete();
                                        return result = Json(new { success = true, message = model.AdjustmentNo + " Stock and Reck successfully adjusted.", redirectUrl = @"/Stock/Stock" });
                                    }

                                }
                            case "StockAndReck":
                                {
                                    //Check speace is available
                                    var isSpaceAvailable = await _context.ItemSpace.Where(w => w.WarehouseId == model.WarehouseId && w.IsAllocated == false).ToListAsync();
                                    if (isSpaceAvailable == null || isSpaceAvailable.Count() < model.Quantity)
                                    {
                                        var getWarehouseTitle = _context.Warehouse.Where(w => w.Id == model.WarehouseId);
                                        return result = Json(new { success = false, message = "No space available under " + getWarehouseTitle.FirstOrDefault().Title + " for the quantity of " + model.Quantity.ToString(), redirectUrl = @"/Stock/Stock" });
                                    }

                                    TransactionOptions options = new TransactionOptions();
                                    options.IsolationLevel = IsolationLevel.Serializable;
                                    options.Timeout = new TimeSpan(0, 10, 0);
                                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                                    {
                                        //Adjustment No Generate
                                        var getLastAdjustmentNo = _context.StockAdjustment.OrderByDescending(pu => pu.EntryDate).FirstOrDefault();
                                        if (getLastAdjustmentNo != null)
                                        {
                                            int creatAdjustmentNo = Convert.ToInt32(getLastAdjustmentNo.AdjustmentNo.Substring(10)) + 1;
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", creatAdjustmentNo.ToString());
                                        }
                                        else
                                        {
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", 1.ToString());
                                        }

                                        model.EntryDate = DateTime.UtcNow;
                                        model.TargetOnEffect = "StockAndReck";
                                        _context.StockAdjustment.Add(model);
                                        _context.SaveChanges();

                                        //Product Item Insertion
                                        var productInsert = new ProductInsertion()
                                        {
                                            ProductId = model.ProductId,
                                            EntryNo = model.AdjustmentNo,
                                            Quantity = model.Quantity,
                                            EntryDate = model.EntryDate,
                                            Note = "Auto generated from stock adjustment."
                                        }; ;
                                        _context.ProductInsertion.Add(productInsert);
                                        _context.SaveChanges();

                                        for (int i = 0; i < model.Quantity; i++)
                                        {
                                            //Serial No Generate
                                            var getLastSerialOfModel = _context.ProductItems.Where(p => p.ProductId == model.ProductId).OrderByDescending(pi => pi.CreatedDate).FirstOrDefault();
                                            int lastSerial = 0;
                                            if (getLastSerialOfModel != null)
                                            {
                                                lastSerial = Convert.ToInt32(getLastSerialOfModel.ItemSerial.Substring(13));
                                            }

                                            //Product Item Insertion
                                            var newProductItem = new ProductItems()
                                            {
                                                ProductId = model.ProductId,
                                                ItemSerial = model.ProductId.ToString().PadLeft(6, '0') + " " + DateTime.Now.ToString("yy") + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00") + (lastSerial + 1).ToString().PadLeft(10, '0'),
                                                CreatedDate = DateTime.UtcNow
                                            };
                                            _context.ProductItems.Add(newProductItem);
                                            _context.SaveChanges();

                                            //Update ItemSpace
                                            isSpaceAvailable[i].ProductItemId = newProductItem.Id;
                                            isSpaceAvailable[i].IsAllocated = true;
                                            isSpaceAvailable[i].LastUpdate = DateTime.UtcNow;
                                            isSpaceAvailable[i].ActionedBy = 0;
                                            _context.ItemSpace.Update(isSpaceAvailable[i]);
                                            _context.SaveChanges();
                                        }

                                        //Stock Generate only once after loop
                                        var isStockExist = _context.Stock.Where(s => s.ProductId == model.ProductId && s.WarehouseId == model.WarehouseId).FirstOrDefault();
                                        if (isStockExist != null)
                                        {
                                            isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                                            isStockExist.AvailableQuantity += model.Quantity;
                                            isStockExist.LastUpdate = DateTime.UtcNow;

                                            _context.Stock.Update(isStockExist);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }
                                        else
                                        {
                                            var newStock = new Stock()
                                            {
                                                WarehouseId = model.WarehouseId,
                                                ProductId = model.ProductId,
                                                AvailableQuantity = model.Quantity,
                                                LastQuantity = 0,
                                                CreatedDate = DateTime.UtcNow
                                            };
                                            _context.Stock.Add(newStock);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }

                                        transaction.Complete();
                                        return result = Json(new { success = true, message = model.AdjustmentNo + " Stock and Reck successfully adjusted.", redirectUrl = @"/Stock/Stock" });
                                    }
                                
                                }
                            default:
                                return result = Json(new { success = false, message = "No Action was taken. Please select Adjustment Effectiveness", redirectUrl = "" });

                        }
                    }
                    else {
                        //Stock Adjustments is decreasing....
                        switch (model.TargetOnEffect)
                        {
                            case "Stock":
                                {
                                    TransactionOptions options = new TransactionOptions();
                                    options.IsolationLevel = IsolationLevel.Serializable;
                                    options.Timeout = new TimeSpan(0, 10, 0);
                                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                                    {
                                        //Adjustment No Generate
                                        var getLastAdjustmentNo = _context.StockAdjustment.OrderByDescending(pu => pu.EntryDate).FirstOrDefault();
                                        if (getLastAdjustmentNo != null)
                                        {
                                            int creatAdjustmentNo = Convert.ToInt32(getLastAdjustmentNo.AdjustmentNo.Substring(10)) + 1;
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", creatAdjustmentNo.ToString());
                                        }
                                        else
                                        {
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", 1.ToString());
                                        }

                                        model.EntryDate = DateTime.UtcNow;
                                        model.TargetOnEffect = "Stock";
                                        _context.StockAdjustment.Add(model);
                                        _context.SaveChanges();

                                        //Stock Generate only once after loop
                                        var isStockExist = _context.Stock.Where(s => s.ProductId == model.ProductId && s.WarehouseId == model.WarehouseId).FirstOrDefault();
                                        if (isStockExist != null)
                                        {
                                            isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                                            isStockExist.AvailableQuantity += model.Quantity;
                                            isStockExist.LastUpdate = DateTime.UtcNow;

                                            _context.Stock.Update(isStockExist);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }
                                        else
                                        {
                                            var newStock = new Stock()
                                            {
                                                WarehouseId = model.WarehouseId,
                                                ProductId = model.ProductId,
                                                AvailableQuantity = model.Quantity,
                                                LastQuantity = 0,
                                                CreatedDate = DateTime.UtcNow
                                            };
                                            _context.Stock.Add(newStock);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }

                                        transaction.Complete();
                                        return result = Json(new { success = true, message = model.AdjustmentNo + " Stock successfully adjusted.", redirectUrl = @"/Stock/Stock" });
                                    }

                                }
                            case "StockAndReck":
                                {
                                    //Check decrease is possible
                                    var isEnoughItemExist = from iS in _context.ItemSpace
                                                            where iS.WarehouseId == model.WarehouseId && iS.IsAllocated == true
                                                            join pI in _context.ProductItems on iS.ProductItemId equals pI.Id
                                                            orderby iS.LastUpdate descending
                                                            select new { iS, pI };

                                    if (isEnoughItemExist.Count() < Math.Abs(Convert.ToDecimal(model.Quantity)))
                                    {
                                        var getWarehouseTitle = _context.Warehouse.Where(w => w.Id == model.WarehouseId);
                                        return result = Json(new { success = false, message = "Decreasing of stock is not possible while available item is below the quantity of " + model.Quantity.ToString(), redirectUrl = @"/Stock/Stock" });
                                    }

                                    TransactionOptions options = new TransactionOptions();
                                    options.IsolationLevel = IsolationLevel.Serializable;
                                    options.Timeout = new TimeSpan(0, 10, 0);
                                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                                    {
                                        var availableItems = isEnoughItemExist.ToList();

                                        //Adjustment No Generate
                                        var getLastAdjustmentNo = _context.StockAdjustment.OrderByDescending(pu => pu.EntryDate).FirstOrDefault();
                                        if (getLastAdjustmentNo != null)
                                        {
                                            int creatAdjustmentNo = Convert.ToInt32(getLastAdjustmentNo.AdjustmentNo.Substring(10)) + 1;
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", creatAdjustmentNo.ToString());
                                        }
                                        else
                                        {
                                            model.AdjustmentNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ADJ-", 1.ToString());
                                        }

                                        model.EntryDate = DateTime.UtcNow;
                                        model.TargetOnEffect = "StockAndReck";
                                        _context.StockAdjustment.Add(model);
                                        _context.SaveChanges();

                                        for (int i = 0; i < Math.Abs(Convert.ToDecimal(model.Quantity)); i++)
                                        {
                                            //Update ItemSpace
                                            availableItems[i].iS.ProductItemId = (dynamic)null;
                                            availableItems[i].iS.IsAllocated = false;
                                            availableItems[i].iS.LastUpdate = DateTime.UtcNow;
                                            availableItems[i].iS.ActionedBy = 0;
                                            _context.ItemSpace.Update(availableItems[i].iS);
                                            _context.SaveChanges();
                                        }

                                        //Stock Generate only once after loop
                                        var isStockExist = _context.Stock.Where(s => s.ProductId == model.ProductId && s.WarehouseId == model.WarehouseId).FirstOrDefault();
                                        if (isStockExist != null)
                                        {
                                            isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                                            isStockExist.AvailableQuantity += model.Quantity;
                                            isStockExist.LastUpdate = DateTime.UtcNow;

                                            _context.Stock.Update(isStockExist);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }
                                        else
                                        {
                                            var newStock = new Stock()
                                            {
                                                WarehouseId = model.WarehouseId,
                                                ProductId = model.ProductId,
                                                AvailableQuantity = model.Quantity,
                                                LastQuantity = 0,
                                                CreatedDate = DateTime.UtcNow
                                            };
                                            _context.Stock.Add(newStock);
                                            _context.SaveChanges();

                                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                            {
                                                NewQuantity = Convert.ToInt32(model.Quantity),
                                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                                ProductId = Convert.ToInt64(model.ProductId),
                                                ReferenecId = model.AdjustmentNo,
                                                TableReference = "StockAdjustment",
                                                Note = "Generated From Stock/CreateStockAdjustment"
                                            });
                                        }

                                        transaction.Complete();
                                        return result = Json(new { success = true, message = model.AdjustmentNo + " Stock and Reck successfully adjusted.", redirectUrl = @"/Stock/Stock" });
                                    }

                                }
                            default:
                                return result = Json(new { success = false, message = "No Action was taken. Please select Adjustment Effectiveness", redirectUrl = "" });
                        }
                    }
                }
                else
                    return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Stock/CreateStockAdjustment: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        // [HttpPost, ActionName("ImportFromExcel")]
        //public async Task<JsonResult> ImportFromExcel( IFormFile file)
        //{
        //    var result = (dynamic)null;
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            await Task.Run(() => {

        //            });
        //        }
        //        else
        //            return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

        //    }
        //    catch (Exception ex)
        //    {
        //        string err = @"Exception occured at Users/Create: " + ex.ToString();
        //        return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
        //    }
        //}
        #endregion

        #region PurchaseItem Search Methods
        //[Produces("application/json")]
        //[HttpGet, ActionName("ItemPurchaseSearch")]
        //public async Task<IActionResult> ItemPurchaseSearch()
        //{
        //    try
        //    {
        //        string term = HttpContext.Request.Query["term"].ToString();
            
        //        var result = await _context.Purchase.Where(p => p.PurchaseNo.Contains(term)).Select(p => p.PurchaseNo).ToListAsync();
        //        return Ok(result);
        //    }
        //    catch
        //    {
        //        return BadRequest();
        //    }
        //}


        //[HttpGet, ActionName("SearchPurchaseResult")]
        //public async Task<IActionResult> SearchPurchaseResult(string purchaseNo)
        //{
        //    var pageNumber = 1;
        //    int pageRowSize = 10;


        //    var products = new List<StockOfWarehousesVM>();


        //    var getProducts = from s in _context.Stock
        //                      join p in _context.Products on s.ProductId equals p.Id
        //                      join pt in _context.ProductType on p.ProductTypeId equals pt.Id
        //                      select new StockOfWarehousesVM
        //                      {
        //                          Stock = s,
        //                          Products = p,
        //                          ProductType = pt
        //                      };

        //    products = await getProducts.ToListAsync();

        //    ViewBag.SearchValue = purchaseNo;
        //    var result = products.ToPagedList(pageNumber, pageRowSize);

        //    return View("PurchaseItems/SearchPurchaseItem", result);
        //}
        #endregion

    }
}
