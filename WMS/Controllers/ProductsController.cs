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
using WMS.Models.PageModels.ItemVM;
using WMS.Models.PageModels.ProductEntry;
using WMS.Models.PageModels.ProductVM;
using WMS.Models.PageModels.ProductVM.ProductEntry;
using WMS.Models.PageModels.ProductVM.ReckView;
using WMS.Models.SharedModels;
using X.PagedList;

namespace POSMVC.Controllers
{
    public class ProductsController : Controller
    {

        #region Global Variables
        private readonly WMSDBContext _context;
        private readonly CommonFunctions _cmnFunction;
        private readonly CommonBusinessLogics _cmnBusinessFunction;
        private readonly IHostingEnvironment _he;
        #endregion

        #region Constructor
        public ProductsController(
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

        #region EntryItems GetMethods
        public async Task<IActionResult> EntryItems(int? page, int? ddlId)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;
            int productType = ddlId ?? 0;

            var productInsert = new List<ListProductInsertionVM>();

            if (productType == 0)
            {
                var getProductI = from pe in _context.ProductInsertion
                                  orderby pe.EntryDate descending
                                  join p in _context.Products on pe.ProductId equals p.Id
                                  join pt in _context.ProductType on p.ProductTypeId equals pt.Id
                                  select new ListProductInsertionVM
                                  {
                                      ProductInsertion = pe,
                                      Products = p,
                                      ProductType = pt
                                  };
                productInsert = await getProductI.ToListAsync();
            }

            var result = productInsert.ToPagedList(pageNumber, pageRowSize);
            return View("ProductEntry/InsertedProducts", result);
        }

        [HttpGet, ActionName("InsertProductItem")]
        public async Task<IActionResult> InsertProductItem()
        {
            ViewData["Product"] = new SelectList(await _context.Products.ToListAsync(), "Id", "Name");
            ViewData["Warehouse"] = new SelectList(await _context.Warehouse.ToListAsync(), "Id", "Title");

            return PartialView("ProductEntry/_InsertProductItems", new InsertProductItemVM());
        }
        #endregion

        #region Product GetMethods
        public async Task<IActionResult> Products(int? page, int? ddlId)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;
            int productType = ddlId ?? 0;

            var products = new List<ListProductVM>();

            if (productType == 0)
            {
                var getProducts = from p in _context.Products
                                  join pt in _context.ProductType on p.ProductTypeId equals pt.Id
                                  join br in _context.Brand on p.BrandId equals br.Id
                                  join mf in _context.Manufacturer on p.ManufacturerId equals mf.Id
                                  select new ListProductVM
                                  {
                                      Products = p,
                                      ProductType = pt,
                                      Brand = br,
                                      Manufacturer = mf
                                  };
                products = await getProducts.ToListAsync();
            }
            else
            {
                var getProducts = from p in _context.Products
                                  where p.ProductTypeId == productType
                                  join pt in _context.ProductType on p.ProductTypeId equals pt.Id
                                  join br in _context.Brand on p.BrandId equals br.Id
                                  join mf in _context.Manufacturer on p.ManufacturerId equals mf.Id
                                  select new ListProductVM
                                  {
                                      Products = p,
                                      ProductType = pt,
                                      Brand = br,
                                      Manufacturer = mf
                                  };

                products = getProducts.ToList();
            }

            ViewData["addProductType"] = new SelectList(_context.ProductType, "Id", "TypeName");
            ViewData["addManufacturer"] = new SelectList(_context.Manufacturer, "Id", "ManufacturerName");
            ViewData["addBrand"] = new SelectList(_context.Brand, "Id", "Name");

            ViewData["ProductType"] = new SelectList(_context.ProductType, "Id", "TypeName", productType);
            ViewData["SelectedProductTypeName"] = productType == 0 ? "All" : _context.ProductType.Find(productType).TypeName;

            var result = products.ToPagedList(pageNumber, pageRowSize);
            return View(result);
        }

        public async Task<IActionResult> ItemsLocation(int? page, long productId = 0)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var items = new List<ItemsLocationVM>();
            if (productId == 0)
            {
                return View(items);
            }

            var getItems = (from iS in _context.ItemSpace
                           join pI in _context.ProductItems on iS.ProductItemId equals pI.Id
                           join p in _context.Products on pI.ProductId equals p.Id
                           join w in _context.Warehouse on iS.WarehouseId equals w.Id
                           join r in _context.Reck on iS.ReckId equals r.Id
                           where pI.ProductId == productId
                           select new ItemWithDetail
                           { 
                              ProductId = p.Id,
                              ProductName = p.Name,
                              ItemSerial = pI.ItemSerial,
                              WarehouseTitle = w.Title,
                              ReckTitle = r.ReckName,
                              ReckLevel = (int)iS.ReckLevel
                           }).GroupBy(g => g.WarehouseTitle).Select(s => new ItemsLocationVM { Warehouse = s.Key,  ItemDetails = s.ToList()});

            var result = getItems.ToPagedList(pageNumber, pageRowSize);
            ViewData["Product"] = _context.Products.Find(productId);

            return View(result);
        }


        [HttpGet, ActionName("CreateProductModel")]
        public async Task<IActionResult> CreateProductModel()
        {
            try
            {
                ViewData["ProductType"] = new SelectList(await _context.ProductType.Select( p=> new { p.Id, p.TypeName}).ToListAsync(), "Id", "TypeName");
                ViewData["Brand"] = new SelectList(await _context.Brand.Select(b => new { b.Id, b.Name }).ToListAsync(), "Id", "Name");
                ViewData["Manufacturer"] = new SelectList(await _context.Manufacturer.Select(m => new { m.Id, m.ManufacturerName }).ToListAsync(), "Id", "ManufacturerName");
              
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
            }
            return PartialView("_CreateProductModel", new Products());

        }

        [HttpGet, ActionName("EditProductModel")]
        public async Task<IActionResult> Edit(long? id)
        {
            if (id != 0)
            {
                var product = await _context.Products.Where(p => p.Id == id).FirstOrDefaultAsync();
                if (product != null)
                {
                    ViewData["ProductType"] = new SelectList(await _context.ProductType.ToListAsync(), "Id", "TypeName", product.ProductTypeId);
                    ViewData["Brand"] = new SelectList(await _context.Brand.ToListAsync(), "Id", "Name", product.BrandId);
                    ViewData["Manufacturer"] = new SelectList(await _context.Manufacturer.ToListAsync(), "Id", "ManufacturerName", product.ManufacturerId);

                    return PartialView("_UpdateProduct", product);
                }
                else
                    return PartialView("_UpdateProduct", new Products());
            }
            else
            {
                ViewData["UserTypeId"] = new SelectList(_context.UserType, "Id", "TypeName");
                return PartialView("_UpdateProduct", new Products());
            }
        }
        #endregion

        #region ReckView
        [HttpGet, ActionName("ReckView")]
        public IActionResult ReckView(int warehouseId, int row, int column)
        {
            var result = (dynamic)null;
            ViewData["WarehouseName"] = _context.Warehouse.Find(warehouseId).Title;

            var getRecks = _context.Reck.Where(r => r.SetupRow == row && r.SetupColumn == column && r.WarehouseId == warehouseId);
            if (getRecks == null)
            {
                return result = Json(new { success = false, message = "No reck found!", redirectUrl = "" });
            }

            var recks = new List<ReckViewVM>();
            foreach (var item in getRecks)
            {
                var getReckItems = from iS in _context.ItemSpace
                                   where iS.WarehouseId == warehouseId && iS.ReckId == item.Id
                                   join pI in _context.ProductItems on iS.ProductItemId equals pI.Id into tmpProductItem from pI in tmpProductItem.DefaultIfEmpty()
                                   join p in _context.Products on pI.ProductId  equals p.Id into tmpProduct from p in tmpProduct.DefaultIfEmpty()
                                  
                                   select new ListOfItem
                                   {
                                       ItemSpace = iS,
                                       ProductItems = pI,
                                       Products = p
                                   };

                var reck = new ReckViewVM();
                reck.Reck = item;
                reck.ListOfItems = getReckItems.ToList();
                recks.Add(reck);
            }

            return PartialView("ReckView/_ReckView", recks);
        }

        [HttpGet, ActionName("AddSingleProduct")]
        public IActionResult AddSingleProduct(long ItemSpaceId)
        {
            var result = (dynamic)null;
            var isSpaceAvailable = _context.ItemSpace.Where(i => i.Id == ItemSpaceId && i.ProductItemId == null && i.IsAllocated == false).FirstOrDefault();
            var reckSetupLocation = _context.Reck.Find(isSpaceAvailable.ReckId);

            if (isSpaceAvailable == null)
            {
                return result = Json(new { success = false, message = "Space not available!", redirectUrl = "" });
            }

            var model = new AddSingleProductItemVM() {
                ItemSpace = isSpaceAvailable,
                Warehouse = _context.Warehouse.Find(isSpaceAvailable.WarehouseId),
                Reck = reckSetupLocation
            };
            ViewData["Product"] = new SelectList(_context.Products, "Id", "Name");

            return PartialView("ReckView/_AddSingleProductItem", model);
        }

        [HttpPost, ActionName("InsertSingleProductItem")]
        public JsonResult InsertSingleProductItem(AddSingleProductItemVM model)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    //Available Space check
                    var isSpaceAvailable = _context.ItemSpace.Where(w => w.Id == model.ItemSpace.Id && w.WarehouseId == model.WarehouseId && w.IsAllocated == false).ToList();
                    if (isSpaceAvailable == null || isSpaceAvailable.Count() < model.ProductInsertion.Quantity)
                    {
                        var getWarehouseTitle = _context.Warehouse.Where(w => w.Id == model.WarehouseId);
                        return result = Json(new { success = false, message = "No space available under " + getWarehouseTitle.FirstOrDefault().Title + " for the quantity of " + model.ProductInsertion.Quantity.ToString(), redirectUrl = @"/Products/EntryItems" });
                    }

                    TransactionOptions options = new TransactionOptions();
                    options.IsolationLevel = IsolationLevel.Serializable;
                    options.Timeout = new TimeSpan(0, 10, 0);
                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                    {
                        //Entry No Generate
                        var getLastEntryNo = _context.ProductInsertion.OrderByDescending(pu => pu.EntryDate).FirstOrDefault();
                        if (getLastEntryNo != null)
                        {
                            int creatEntryNo = Convert.ToInt32(getLastEntryNo.EntryNo.Substring(10)) + 1;
                            model.ProductInsertion.EntryNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ENT-", creatEntryNo.ToString());
                        }
                        else
                        {
                            model.ProductInsertion.EntryNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ENT-", 1.ToString());
                        }

                        //Product Item Insertion
                        model.ProductInsertion.EntryDate = DateTime.UtcNow;
                        _context.ProductInsertion.Add(model.ProductInsertion);
                        _context.SaveChanges();

                        for (int i = 0; i < model.ProductInsertion.Quantity; i++)
                        {
                            //Serial No Generate
                            var getLastSerialOfModel = _context.ProductItems.Where(p => p.ProductId == model.ProductInsertion.ProductId).OrderByDescending(pi => pi.CreatedDate).FirstOrDefault();
                            int lastSerial = 0;
                            if (getLastSerialOfModel != null)
                            {
                                lastSerial = Convert.ToInt32(getLastSerialOfModel.ItemSerial.Substring(13));
                            }

                            //Product Item Insertion
                            var newProductItem = new ProductItems()
                            {
                                ProductId = model.ProductInsertion.ProductId,
                                ItemSerial = model.ProductInsertion.ProductId.ToString().PadLeft(6, '0') + " " + DateTime.Now.ToString("yy") + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00") + (lastSerial + 1).ToString().PadLeft(10, '0'),
                                Status = StaticValues.ApplicationStatus.FreshProduct.ToString(),
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
                        var isStockExist = _context.Stock.Where(s => s.ProductId == model.ProductInsertion.ProductId && s.WarehouseId == model.WarehouseId).FirstOrDefault();
                        if (isStockExist != null)
                        {
                            isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                            isStockExist.AvailableQuantity += model.ProductInsertion.Quantity;
                            isStockExist.LastUpdate = DateTime.UtcNow;

                            _context.Stock.Update(isStockExist);
                            _context.SaveChanges();

                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                            {
                                NewQuantity = Convert.ToInt32(model.ProductInsertion.Quantity),
                                ProductId = Convert.ToInt64(model.ProductInsertion.ProductId),
                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                ReferenecId = model.ProductInsertion.EntryNo,
                                TableReference = "ProductInsertion",
                                Note = "Generated From Products/InsertSingleProductItem"
                            });
                        }
                        else
                        {
                            var newStock = new Stock()
                            {
                                WarehouseId = model.WarehouseId,
                                ProductId = model.ProductInsertion.ProductId,
                                AvailableQuantity = model.ProductInsertion.Quantity,
                                LastQuantity = 0,
                                CreatedDate = DateTime.UtcNow
                            };
                            _context.Stock.Add(newStock);
                            _context.SaveChanges();

                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                            {
                                NewQuantity = Convert.ToInt32(model.ProductInsertion.Quantity),
                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                ProductId = Convert.ToInt64(model.ProductInsertion.ProductId),
                                ReferenecId = model.ProductInsertion.EntryNo,
                                TableReference = "ProductInsertion",
                                Note = "Generated From Products/InsertSingleProductItem"
                            });
                        }

                        transaction.Complete();
                        return result = Json(new { success = true, serverData = "Data saved successfully." });
                    }

                }
                else
                    return result = Json(new { success = false, message = "Form is not valid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Products/InsertProductItem: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        #endregion

        #region ProductType
        public async Task<IActionResult> ProductTypes(int? page)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var pt = await _context.ProductType.ToListAsync();
            var result = pt.ToPagedList(pageNumber, pageRowSize);

            return View("ProductTypes/ProductTypes", result);
        }

        [HttpGet, ActionName("CreateProductType")]
        public async Task<IActionResult> CreateProductTypes()
        {
            return PartialView("ProductTypes/_CreateProductType");
        }


        [HttpPost, ActionName("CreateProductType")]
        public async Task<JsonResult> CreateProductType(ProductType obj)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    _context.ProductType.Add(obj);
                    await _context.SaveChangesAsync();
                    return result = Json(new { success = true, message = "ProductType successfully created.", redirectUrl = @"/Products/ProductTypes" });
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

        [HttpGet, ActionName("EditProductType")]
        public async Task<IActionResult> EditProductTypes(int? id)
        {
            if (id != 0)
            {
                var pt = await _context.ProductType.FindAsync(id);
                return PartialView("ProductTypes/_UpdateProductType", pt);
            }
            else
            {
                return PartialView("ProductTypes/_UpdateProductType", new Warehouse());
            }
        }
        [HttpPost, ActionName("EditProductType")]
        public async Task<JsonResult> EditProductType(ProductType obj)
        {
            var result = (dynamic)null;

            try
            {
                if (obj.Id <= 0)
                {
                    return result = Json(new { success = false, message = " Record is not found", redirectUrl = @"/Products/ProductTypes" });
                }

                obj.TypeName = obj.TypeName;
                _context.Entry(obj).State = EntityState.Modified;
                await _context.SaveChangesAsync();

                return result = Json(new { success = true, message = "Record successfully updated", redirectUrl = @"/Products/ProductTypes" });
            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Products/EditProductType " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpPost, ActionName("DeleteProductType")]
        public async Task<JsonResult> DeleteProductType(ProductType model)
        {
            var result = (dynamic)null;
            try
            {
                var pt = await _context.ProductType.FindAsync(model.Id);

                if (pt != null)
                {
                    _context.ProductType.Remove(pt);
                    await _context.SaveChangesAsync();

                    return result = Json(new { success = true, message = " Record successfully deleted.", redirectUrl = @"/Products/ProductTypes" });
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


        //#region PurchaseItems PostMethods

        [HttpGet, ActionName("ProductBackToStock")]
        public async Task<IActionResult> ProductBackToStock(long virtualSpaceId)
        {
            var model = new ProductBackToStockVM(){ 
                VirtualSpaceId = virtualSpaceId
            };

            ViewData["Warehouse"] = new SelectList(await _context.Warehouse.ToListAsync(), "Id", "Title");
            return PartialView("_ProductBackToStock", model);
        }

        [HttpPost, ActionName("ProductBackToStock")]
        public JsonResult ProductBackToStock(ProductBackToStockVM model)
        {
            var result = (dynamic)null;
            try
            {
                if (model.WarehouseId > 0)
                {
                    //Available Space check
                    var isSpaceAvailable = _context.ItemSpace.Where(w => w.WarehouseId == model.WarehouseId && w.IsAllocated == false).ToList();
                    if (isSpaceAvailable == null || isSpaceAvailable.Count() <= 0)
                    {
                        var getWarehouseTitle = _context.Warehouse.Where(w => w.Id == model.WarehouseId);
                        return result = Json(new { success = false, message = "No space available under " + getWarehouseTitle.FirstOrDefault().Title, redirectUrl = "" });
                    }

                    var isVirtualProductAvailable = _context.VirtualSpace.Find(model.VirtualSpaceId);       
                    if (isVirtualProductAvailable == null)
                    {
                        return result = Json(new { success = false, message = "Virtual Store record is not found!", redirectUrl = "" });
                    }

                    var productItem = _context.ProductItems.Find(isVirtualProductAvailable.ProductItemId);
                    if (productItem == null)
                    {
                        return result = Json(new { success = false, message = "Product item is not found!", redirectUrl = "" });
                    }

                    TransactionOptions options = new TransactionOptions();
                    options.IsolationLevel = IsolationLevel.Serializable;
                    options.Timeout = new TimeSpan(0, 10, 0);
                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                    {
                        //Update Virtual Space record
                        productItem.Status = StaticValues.ApplicationStatus.ReturnProduct.ToString();
                        _context.ProductItems.Update(productItem);
                        _context.SaveChanges();
                        
                        //Update Product Item record
                        isVirtualProductAvailable.Status = StaticValues.ApplicationStatus.StockRetrived.ToString();
                        _context.VirtualSpace.Update(isVirtualProductAvailable);
                        _context.SaveChanges();

                        //Update ItemSpace
                        isSpaceAvailable[0].ProductItemId = productItem.Id;
                            isSpaceAvailable[0].IsAllocated = true;
                            isSpaceAvailable[0].LastUpdate = DateTime.UtcNow;
                            isSpaceAvailable[0].ActionedBy = 0;
                            _context.ItemSpace.Update(isSpaceAvailable[0]);
                            _context.SaveChanges();

                            //Stock Generate one by one while loop is running
                            var isStockExist = _context.Stock.Where(s => s.ProductId == productItem.ProductId && s.WarehouseId == model.WarehouseId).FirstOrDefault();
                            if (isStockExist != null)
                            {
                                isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                                isStockExist.AvailableQuantity += 1;
                                isStockExist.LastUpdate = DateTime.UtcNow;

                                _context.Stock.Update(isStockExist);
                                _context.SaveChanges();

                                _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                {
                                    NewQuantity = 1,
                                    ProductId = (long)productItem.ProductId,
                                    WarehouseId = model.WarehouseId,
                                    ReferenecId = model.VirtualSpaceId.ToString(),
                                    TableReference = "VirtualSpace",
                                    Note = "Generated From Products/ProductBackToStock"
                                });
                            }
                            else
                            {
                                var newStock = new Stock()
                                {
                                    WarehouseId = model.WarehouseId,
                                    ProductId = (long)productItem.ProductId,
                                    AvailableQuantity = 1,
                                    LastQuantity = 0,
                                    CreatedDate = DateTime.UtcNow
                                };
                                _context.Stock.Add(newStock);
                                _context.SaveChanges();

                                _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                {
                                    NewQuantity = 1,
                                    WarehouseId = model.WarehouseId,
                                    ProductId = (long)productItem.ProductId,
                                    ReferenecId = model.VirtualSpaceId.ToString(),
                                    TableReference = "VirtualSpace",
                                    Note = "Generated From Products/ProductBackToStock"
                                });
                            }

                        transaction.Complete();
                        return result = Json(new { success = true, message = "Product item successfully retrived to selected warehouse.", redirectUrl = @"/Stock/VirtualStore"});
                    }
                }

                return result = Json(new { success = false, message = "Please select warehouse where to retrive product item.", redirectUrl = "" });
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }



        [HttpPost, ActionName("MakeItDamage")]
        public JsonResult MakeItDamage(VirtualSpace model)
        {
            var result = (dynamic)null;
            try
            {
                var fetchVS = _context.VirtualSpace.Find(model.Id);
                if (fetchVS != null)
                {
                    fetchVS.Status = StaticValues.ApplicationStatus.Damage.ToString();
                    _context.VirtualSpace.Update(fetchVS);
                    _context.SaveChanges();

                    return result = Json(new { success = true, message = "Product Item is damaged.", redirectUrl = @"/Stock/VirtualStore" });
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


        [HttpPost, ActionName("InsertProductItem")]
        public async Task<JsonResult> InsertProductItem(InsertProductItemVM model)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    //Available Space check
                    var isSpaceAvailable = await _context.ItemSpace.Where(w => w.WarehouseId == model.WarehouseId && w.IsAllocated == false).ToListAsync();
                    if (isSpaceAvailable == null || isSpaceAvailable.Count() < model.ProductInsertion.Quantity)
                    {
                        var getWarehouseTitle = _context.Warehouse.Where(w => w.Id == model.WarehouseId);
                        return result = Json(new { success = false, message = "No space available under " + getWarehouseTitle.FirstOrDefault().Title + " for the quantity of " + model.ProductInsertion.Quantity.ToString(), redirectUrl = @"/Products/EntryItems" });
                    }

                    TransactionOptions options = new TransactionOptions();
                    options.IsolationLevel = IsolationLevel.Serializable;
                    options.Timeout = new TimeSpan(0, 10, 0);
                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                    {
                        //Entry No Generate
                        var getLastEntryNo = _context.ProductInsertion.OrderByDescending(pu => pu.EntryDate).FirstOrDefault();
                        if (getLastEntryNo != null)
                        {
                            int creatEntryNo = Convert.ToInt32(getLastEntryNo.EntryNo.Substring(10)) + 1;
                            model.ProductInsertion.EntryNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ENT-", creatEntryNo.ToString());
                        }
                        else
                        {
                            model.ProductInsertion.EntryNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ENT-", 1.ToString());
                        }

                        //Product Item Insertion
                        model.ProductInsertion.EntryDate = DateTime.UtcNow;
                        _context.ProductInsertion.Add(model.ProductInsertion);
                        _context.SaveChanges();

                        for (int i = 0; i < model.ProductInsertion.Quantity; i++)
                        {
                            //Serial No Generate
                            var getLastSerialOfModel = _context.ProductItems.Where(p => p.ProductId == model.ProductInsertion.ProductId).OrderByDescending(pi => pi.CreatedDate).FirstOrDefault();
                            int lastSerial = 0;
                            if (getLastSerialOfModel != null)
                            {
                                lastSerial = Convert.ToInt32(getLastSerialOfModel.ItemSerial.Substring(13));
                            }

                            //Product Item Insertion
                            var newProductItem = new ProductItems()
                            {
                                ProductId = model.ProductInsertion.ProductId,
                                ItemSerial = model.ProductInsertion.ProductId.ToString().PadLeft(6, '0') + " " + DateTime.Now.ToString("yy") + DateTime.Now.Month.ToString("00") + DateTime.Now.Day.ToString("00") + (lastSerial + 1).ToString().PadLeft(10, '0'),
                                Status = StaticValues.ApplicationStatus.FreshProduct.ToString(),
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
                        var isStockExist = _context.Stock.Where(s => s.ProductId == model.ProductInsertion.ProductId && s.WarehouseId == model.WarehouseId).FirstOrDefault();
                        if (isStockExist != null)
                        {
                            isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                            isStockExist.AvailableQuantity += model.ProductInsertion.Quantity;
                            isStockExist.LastUpdate = DateTime.UtcNow;

                            _context.Stock.Update(isStockExist);
                            _context.SaveChanges();

                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                            {
                                NewQuantity = Convert.ToInt32(model.ProductInsertion.Quantity),
                                ProductId = Convert.ToInt64(model.ProductInsertion.ProductId),
                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                ReferenecId = model.ProductInsertion.EntryNo,
                                TableReference = "ProductInsertion",
                                Note = "Generated From Products/InsertProductItem"
                            });
                        }
                        else
                        {
                            var newStock = new Stock()
                            {
                                WarehouseId = model.WarehouseId,
                                ProductId = model.ProductInsertion.ProductId,
                                AvailableQuantity = model.ProductInsertion.Quantity,
                                LastQuantity = 0,
                                CreatedDate = DateTime.UtcNow
                            };
                            _context.Stock.Add(newStock);
                            _context.SaveChanges();

                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                            {
                                NewQuantity = Convert.ToInt32(model.ProductInsertion.Quantity),
                                WarehouseId = Convert.ToInt32(model.WarehouseId),
                                ProductId = Convert.ToInt64(model.ProductInsertion.ProductId),
                                ReferenecId = model.ProductInsertion.EntryNo,
                                TableReference = "ProductInsertion",
                                Note = "Generated From Products/InsertProductItem"
                            });
                        }

                        transaction.Complete();
                        return result = Json(new { success = true, message = model.ProductInsertion.EntryNo + " successfully inserted.", redirectUrl = @"/Products/EntryItems" });
                    }
               
                
                }
                else
                    return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Products/InsertProductItem: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        //// [HttpPost, ActionName("ImportFromExcel")]
        ////public async Task<JsonResult> ImportFromExcel( IFormFile file)
        ////{
        ////    var result = (dynamic)null;
        ////    try
        ////    {
        ////        if (ModelState.IsValid)
        ////        {
        ////            await Task.Run(() => {

        ////            });
        ////        }
        ////        else
        ////            return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

        ////    }
        ////    catch (Exception ex)
        ////    {
        ////        string err = @"Exception occured at Users/Create: " + ex.ToString();
        ////        return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
        ////    }
        ////}
        //#endregion

        //#region Items PostMethods

        [HttpPost, ActionName("CreateProductModel")]
        public async Task<JsonResult> Create(Products model)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    model.CreatedDate = System.DateTime.UtcNow;
                    model.IsActive = true;
                    _context.Products.Add(model);
                    await _context.SaveChangesAsync();

                    ////Image insertion Code
                    //if (user.Users.Id > 0)
                    //{
                    //    if (user.file != null)
                    //    {
                    //        string extension = Path.GetExtension(user.file.FileName);
                    //        string smallImage = "StaticFiles/Users/SmallImage/";
                    //        string bigImage = "StaticFiles/Users/BigImage/";

                    //        if (_cmnFunction.SaveImage(user.file, user.Users.Id.ToString(), Path.Combine(_he.WebRootPath, smallImage), extension, 60, 60))
                    //        {
                    //            user.Users.SmallImage = smallImage + user.Users.Id.ToString() + extension;
                    //        }

                    //        if (_cmnFunction.SaveImage(user.file, user.Users.Id.ToString(), Path.Combine(_he.WebRootPath, bigImage), extension))
                    //        {
                    //            user.Users.BigImage = bigImage + user.Users.Id.ToString() + extension;
                    //        }

                    //        _context.Entry(user.Users).State = EntityState.Modified;
                    //        await _context.SaveChangesAsync();
                    //    }
                    //}
                    ////Image insertion Code
                    ///
                    return result = Json(new { success = true, message = model.ProductCode + " successfully created.", redirectUrl = @"/Products/Products" });
                }
                else
                    return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Items/CreateSingleItem: " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpPost, ActionName("EditProductModel")]
        public async Task<JsonResult> Edit(Products model)
        {
            var result = (dynamic)null;

            try
            {
                if (model.Id <= 0)
                {
                    return result = Json(new { success = false, message = " Record is not found", redirectUrl = @"/Products/Products" });
                }

                var product = await _context.Products.Where(pd => pd.Id == model.Id).FirstOrDefaultAsync();
                product.ProductTypeId = model.ProductTypeId;
                product.ProductCode = model.ProductCode;
                product.Name = model.Name;
                product.BrandId = model.BrandId;
                product.ManufacturerId = model.ManufacturerId;
                product.SellingPrice = model.SellingPrice;
                product.CostPrice = model.CostPrice;
                product.UpdateDate = DateTime.UtcNow;

                _context.Products.Update(product);
                await _context.SaveChangesAsync();

                return result = Json(new { success = true, message = "Record successfully updated", redirectUrl = @"/Products/Products" });
            }
            catch (Exception ex)
            {
                string err = @"Exception occured at Products/EditProductModel " + ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }


        [HttpPost, ActionName("DeleteProductModel")]
        public async Task<JsonResult> Delete(Products model)
        {
            var result = (dynamic)null;
            try
            {
                var product = await _context.Products.Where(c => c.Id == model.Id).FirstOrDefaultAsync();

                if (product != null)
                {
                    _context.Products.Remove(product);
                    await _context.SaveChangesAsync();

                    return result = Json(new { success = true, message = " Record successfully deleted.", redirectUrl = @"/Products/Products" });
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


        //[HttpPost, ActionName("ImportFromExcel")]
        ////public async Task<JsonResult> ImportFromExcel( IFormFile file)
        ////{
        ////    var result = (dynamic)null;
        ////    try
        ////    {
        ////        if (ModelState.IsValid)
        ////        {
        ////            await Task.Run(() => {

        ////            });
        ////        }
        ////        else
        ////            return result = Json(new { success = false, message = "Data is not valid.", redirectUrl = "" });

        ////    }
        ////    catch (Exception ex)
        ////    {
        ////        string err = @"Exception occured at Users/Create: " + ex.ToString();
        ////        return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
        ////    }
        ////}
        //#endregion

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

        //#region PurchaseItem Search Methods
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


        //    var purchaseItem = new List<ListPurchaseVM>();

        //    var getPurchase = from pu in _context.Purchase
        //                      where pu.PurchaseNo == purchaseNo
        //                      orderby pu.EntryDate descending
        //                      join p in _context.Products on pu.ProductId equals p.Id
        //                      join pt in _context.ProductType on p.ProductTypeId equals pt.Id
        //                      join mf in _context.Manufacturer on p.ManufacturerId equals mf.Id
        //                      join br in _context.Brand on p.BrandId equals br.Id
        //                      select new ListPurchaseVM
        //                      {
        //                          Purchase = pu,
        //                          Products = p,
        //                          ProductType = pt,
        //                          Brand = br,
        //                          Manufacturer = mf
        //                      };
        //    purchaseItem = await getPurchase.ToListAsync();

        //    ViewBag.SearchValue = purchaseNo;
        //    var result = purchaseItem.ToPagedList(pageNumber, pageRowSize);

        //    return View("PurchaseItems/SearchPurchaseItem", result);
        //}
        //#endregion

        //#region Item Search Methods
        //[Produces("application/json")]
        //[HttpGet, ActionName("ItemSearch")]
        //public async Task<IActionResult> Search()
        //{
        //    try
        //    {
        //        string term = HttpContext.Request.Query["term"].ToString();
        //        var result = await _context.Products.Where(p => p.ProductCode.Contains(term)).Select(p => p.ProductCode).ToListAsync();
        //        return Ok(result);
        //    }
        //    catch
        //    {
        //        return BadRequest();
        //    }
        //}


        //[HttpGet, ActionName("SearchResult")]
        //public async Task<IActionResult> SearchResult(string productCode)
        //{
        //    var pageNumber = 1;
        //    int pageRowSize = 10;
        //    int productType = 0;

        //    var products = new List<ListProductVM>();
        //    var getProducts = from p in _context.Products
        //                      where p.ProductCode == productCode
        //                      join pt in _context.ProductType on p.ProductTypeId equals pt.Id
        //                      join br in _context.Brand on p.BrandId equals br.Id
        //                      join mf in _context.Manufacturer on p.ManufacturerId equals mf.Id
        //                      select new ListProductVM
        //                      {
        //                          Products = p,
        //                          ProductType = pt,
        //                          Brand = br,
        //                          Manufacturer = mf
        //                      };
        //    products = await getProducts.ToListAsync();

        //    ViewData["ProductType"] = new SelectList(_context.ProductType, "Id", "TypeName", productType);
        //    ViewData["SelectedProductTypeName"] = productType == 0 ? "All" : _context.ProductType.Find(productType).TypeName;
        //    ViewBag.SearchValue = productCode;
        //    var result = products.ToPagedList(pageNumber, pageRowSize);
        //    return View("SearchItem", result);
        //}
        //#endregion

    }
}
