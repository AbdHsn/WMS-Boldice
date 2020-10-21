using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Transactions;
using CommonLogics;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;
using Microsoft.EntityFrameworkCore.SqlServer.Query.ExpressionTranslators.Internal;
using Newtonsoft.Json;
using WMS.CommonBusinessFunctions;
using WMS.CommonBusinessFunctions.BusinessModels;
using WMS.Models.Entities;
using WMS.Models.PageModels.OrdersVM;
using WMS.Models.SharedModels;
using X.PagedList;

using OrderVM = WMS.Models.PageModels.OrdersVM;
using PrintVM = WMS.Models.PageModels.OrdersVM.PrintVM;

namespace WMS.Controllers
{
    public class OrdersController : Controller
    {

        #region Global Variables
        private readonly WMSDBContext _context;
        private readonly CommonFunctions _cmnFunction;
        private readonly CommonBusinessLogics _cmnBusinessFunction;
        private readonly IHostingEnvironment _he;
        #endregion

        #region Constructor
        public OrdersController(
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

        #region Order Methods
        public async Task<IActionResult> Orders(int? page, string orderStatus = null)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var fetchOrders = new List<OrdersVM>();
            if (string.IsNullOrEmpty(orderStatus) || orderStatus == "All")
            {
                var fetchOrder = from o in _context.Orders
                                 orderby o.OrderPlaceDate descending
                                 select new OrdersVM
                                 {
                                     Orders = o,
                                     OrderDetails = (from od in _context.OrderDetails
                                                     where od.OrderId == o.Id
                                                     join w in _context.Warehouse on od.WarehouseId equals w.Id
                                                     join p in _context.Products on od.ProductId equals p.Id
                                                     select new OrderDetailWithOthers
                                                     {
                                                         OrderDetails = od,
                                                         Warehouse = w,
                                                         Products = p
                                                     }).ToList()
                                 };
                fetchOrders = fetchOrder.ToList();
            }
            else
            {
                var fetchOrder = from o in _context.Orders
                                 where o.OrderStatus == orderStatus
                                 orderby o.OrderPlaceDate descending
                                 select new OrdersVM
                                 {
                                     Orders = o,
                                     OrderDetails = (from od in _context.OrderDetails
                                                     where od.OrderId == o.Id
                                                     join w in _context.Warehouse on od.WarehouseId equals w.Id
                                                     join p in _context.Products on od.ProductId equals p.Id
                                                     select new OrderDetailWithOthers
                                                     {
                                                         OrderDetails = od,
                                                         Warehouse = w,
                                                         Products = p
                                                     }).ToList()
                                 };
                fetchOrders = fetchOrder.ToList();
            }


            var filterValues = new int[] { 1, 2, 4, 5 };
            ViewData["ddlOrderStatus"] = new SelectList(
                from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

            ViewData["SelectedOrderStatus"] = string.IsNullOrEmpty(orderStatus) ? "All" : orderStatus;
            ViewData["PageNumber"] = pageNumber;

            var result = await fetchOrders.ToPagedListAsync(pageNumber, pageRowSize);

            return View(result);
        }

        [HttpGet, ActionName("CreateOrder")]
        public async Task<IActionResult> CreateOrder()
        {
            await Task.Run(async () =>
            {
                ViewData["Warehouses"] = new SelectList(await _context.Warehouse.ToListAsync(), "Id", "Title");
            });
            return View("CreateOrder");
        }

        [HttpPost, ActionName("CreateOrders")]
        public JsonResult CreateOrders(CreateOrdersVM model)
        {
            var result = (dynamic)null;
            try
            {

                if (model != null)
                {

                    using (TransactionScope transaction = new TransactionScope())
                    {
                        var newOrder = new Orders();
                        Orders lastOrder = _context.Orders.OrderByDescending(o => o.OrderPlaceDate).FirstOrDefault();

                        //Order No generating...
                        if (lastOrder != null)
                        {
                            int newOrderNo = Convert.ToInt32(lastOrder.OrderNo.Substring(10)) + 1;
                            newOrder.OrderNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ORD-", newOrderNo.ToString());
                        }
                        else
                        {
                            newOrder.OrderNo = _cmnBusinessFunction.GenerateNumberWithPrefix("ORD-", 1.ToString());
                        }

                        //Importing Order Master record...
                        //newOrder.UserId = model.Users.Id;
                        newOrder.GrandTotal = model.ListOrderDetails.Sum(s => s.Total);
                        newOrder.OrderPlaceDate = DateTime.Now;
                        newOrder.CollectionDate = DateTime.UtcNow;
                        newOrder.OrderStatus = StaticValues.ApplicationStatus.Submitted.ToString();
                        _context.Orders.Add(newOrder);
                        _context.SaveChanges();
                        //Importing Order Child record...
                        foreach (var item in model.ListOrderDetails)
                        {
                            //Checking stock is available or not, if not return back.
                            var isStockAvailable = from s in _context.Stock
                                                   where s.ProductId == item.ProductId && s.WarehouseId == item.WarehouseId
                                                   join p in _context.Products on s.ProductId equals p.Id
                                                   select new { s, p };

                            var currentStock = isStockAvailable.FirstOrDefault();
                            if (item.Quantity > currentStock.s.AvailableQuantity)
                            {
                                return result = Json(new { success = false, message = " Order can't proceed, " + currentStock.p.ProductCode + " out of stock.", redirectUrl = "" });
                            }

                            item.OrderId = newOrder.Id;
                            item.ProductStatus = StaticValues.ApplicationStatus.Submitted.ToString();
                            // item.CollectionDate = DateTime.Now;
                            _context.OrderDetails.Add(item);
                            _context.SaveChanges();

                            //Updating Stock of current item
                            currentStock.s.LastQuantity = currentStock.s.AvailableQuantity;
                            currentStock.s.AvailableQuantity -= item.Quantity;
                            currentStock.s.LastUpdate = DateTime.UtcNow;

                            _context.Stock.Update(currentStock.s);
                            _context.SaveChanges();
                            //Creating stock trace
                            _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                            {
                                NewQuantity = -Convert.ToInt32(item.Quantity),
                                ProductId = Convert.ToInt64(item.ProductId),
                                WarehouseId = Convert.ToInt32(item.WarehouseId),
                                ReferenecId = newOrder.OrderNo,
                                TableReference = "Orders",
                                Note = "Generated From Orders/CreateOrders"
                            });
                        }

                        transaction.Complete();
                        return result = Json(new { success = true, message = " Order successfully placed.", redirectUrl = @"/Orders/CreateOrderPrint?OrderId=" + newOrder.Id });
                        //return RedirectToAction("CCOrderInvoice", new { orderId =  newOrder.Id });
                    }
                }
                else
                    return result = Json(new { success = false, message = "Failed to place order.", redirectUrl = "" });
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpGet, ActionName("CreateOrderPrint")]
        public IActionResult CreateOrderPrint(long orderId)
        {
            return View("CreateOrderPrint", orderId);
        }

        [Produces("application/json")]
        [HttpGet, ActionName("GetOrderPrintData")]
        public IActionResult GetOrderPrintData(string jsonData)
        {
            try
            {
                var result = (dynamic)null;
                var orderId = JsonConvert.DeserializeObject<long>(jsonData);

                var fetchCompany = _context.Company.FirstOrDefault();
                //Converting logo into base64 string
                string logoPath = System.IO.Path.Combine(_he.WebRootPath, fetchCompany.SmallLogo);
                string extension = System.IO.Path.GetExtension(logoPath);
                string logo = "data:image/" + extension + ";base64," + Convert.ToBase64String(System.IO.File.ReadAllBytes(logoPath));

                var fetchOrder = _context.Orders.Find(orderId);
                //QRCode generating 
                string generateQr = "data:image/" + ".png" + ";base64," + Convert.ToBase64String(_cmnFunction.CreateQrCode(string.Format("Company Name: {0}, OrderNo: {1}", fetchCompany.Name, fetchOrder.OrderNo)));

                if (fetchOrder != null)
                {
                    var fetchOrderDetails = from od in _context.OrderDetails
                                            where od.OrderId == fetchOrder.Id
                                            join p in _context.Products on od.ProductId equals p.Id
                                            join w in _context.Warehouse on od.WarehouseId equals w.Id
                                            select new ArrayList {
                                                p.Name, w.Title, od.Quantity
                                             };

                    result = new PrintVM.CreateOrderPrintVM()
                    {
                        Company = fetchCompany,
                        Logo = logo,
                        QRCode = generateQr,
                        Orders = fetchOrder,
                        OrderDetails = fetchOrderDetails.ToList(),
                        TotalProduct = (int)_context.OrderDetails.Where(od => od.OrderId == fetchOrder.Id).Sum(s=> s.Quantity)
                    };
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return BadRequest();
            }
        }

        [HttpPost, ActionName("OrderCancel")]
        public JsonResult OrderCancel(Orders model)
        {
            var result = (dynamic)null;
            try
            {
                var or = _context.Orders.Find(model.Id);

                if (or != null)
                {
                    var fetchOrderDetail = _context.OrderDetails.Where(od => od.OrderId == or.Id && od.ProductStatus != StaticValues.ApplicationStatus.Cancelled.ToString()).ToList();

                    if (fetchOrderDetail.Count() > 0)
                    {
                        TransactionOptions options = new TransactionOptions();
                        options.IsolationLevel = IsolationLevel.Serializable;
                        options.Timeout = new TimeSpan(0, 10, 0);
                        using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                        {
                            foreach (var item in fetchOrderDetail)
                            {
                                //Stock Generate only once after loop
                                var isStockExist = _context.Stock.Where(s => s.ProductId == item.ProductId && s.WarehouseId == item.WarehouseId).FirstOrDefault();
                                if (isStockExist != null)
                                {
                                    isStockExist.LastQuantity = isStockExist.AvailableQuantity;
                                    isStockExist.AvailableQuantity += item.Quantity;
                                    isStockExist.LastUpdate = DateTime.UtcNow;

                                    _context.Stock.Update(isStockExist);
                                    _context.SaveChanges();

                                    _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                    {
                                        NewQuantity = Convert.ToInt32(item.Quantity),
                                        ProductId = Convert.ToInt64(item.ProductId),
                                        WarehouseId = Convert.ToInt32(item.WarehouseId),
                                        ReferenecId = or.OrderNo,
                                        TableReference = "Order Cancel",
                                        Note = "Generated From Order Cancellation Orders/OrderCancel"
                                    });
                                }
                                else
                                {
                                    var newStock = new Stock()
                                    {
                                        WarehouseId = item.WarehouseId,
                                        ProductId = item.ProductId,
                                        AvailableQuantity = item.Quantity,
                                        LastQuantity = 0,
                                        CreatedDate = DateTime.UtcNow
                                    };
                                    _context.Stock.Add(newStock);
                                    _context.SaveChanges();

                                    _cmnBusinessFunction.CreateStockTrace(new CreateStockTraceBM()
                                    {
                                        NewQuantity = Convert.ToInt32(item.Quantity),
                                        WarehouseId = Convert.ToInt32(item.WarehouseId),
                                        ProductId = Convert.ToInt64(item.ProductId),
                                        ReferenecId = or.OrderNo,
                                        TableReference = "Order Cancel",
                                        Note = "Generated From Order Cancellation Orders/OrderCancel"
                                    });
                                }

                                item.ProductStatus = StaticValues.ApplicationStatus.Cancelled.ToString();
                                item.LastUpdate = DateTime.UtcNow;
                                _context.OrderDetails.Update(item);
                                _context.SaveChanges();
                            }

                            or.OrderStatus = StaticValues.ApplicationStatus.Cancelled.ToString();
                            or.LastUpdate = DateTime.UtcNow;
                            _context.Orders.Update(or);
                            _context.SaveChanges();

                            transaction.Complete();
                        }
                        return result = Json(new { success = true, message = " Order successfully cancelled.", redirectUrl = @"/Orders/Orders" });

                    }
                    return result = Json(new { success = false, message = " Order already cancelled.", redirectUrl = "" });


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

        [Produces("application/json")]
        [HttpGet, ActionName("GetOrdersAndReturnsChart")]
        public IActionResult GetOrdersAndReturnsChart()
        {
            try
            {
                var result = (dynamic)null;
                int[] month = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
                var fetchOrderDetails = (from od in _context.OrderDetails
                                        join o in _context.Orders on od.OrderId equals o.Id
                                        where o.OrderStatus == StaticValues.ApplicationStatus.FullDispatch.ToString()
                                        orderby o.OrderPlaceDate.Value.Month
                                        select new { 
                                            od, o
                                        }).GroupBy(g => g.o.OrderPlaceDate.Value.Month).Select(s => new { Month = s.Key, SoldItems = s.Count()});
                
                var fetchReturnDetails = (from ord in _context.OrderReturnDetails
                                        join or in _context.OrderReturn on ord.ReturnId equals or.Id
                                        orderby or.ReturnDate.Value.Month
                                        select new { 
                                            ord, or
                                        }).GroupBy(g => g.or.ReturnDate.Value.Month).Select(s => new { Month = s.Key, ReturnItems = s.Count()});

                var list = new List<OrdersReturnsChartVM>();

                var model01 = new OrdersReturnsChartVM();
                model01.Label = "Orders";
                model01.BorderColor = "green";
                model01.BackgroundColor = "rgb(47, 161, 196)";
                model01.Data = (from m in month
                               join od in fetchOrderDetails on m equals od.Month into results
                               from r in results.DefaultIfEmpty()
                               select new { 
                                    value = r == null ? 0 : r.SoldItems
                               }).Select(s => s.value).ToList();

                list.Add(model01);

                var model02 = new OrdersReturnsChartVM();
                model02.Label = "Returns";
                model02.BorderColor = "red";
                model02.BackgroundColor = "rgb(244, 207, 139)";
                model02.Data = (from m in month
                                join rd in fetchReturnDetails on m equals rd.Month into results
                                from r in results.DefaultIfEmpty()
                                select new
                                {
                                    value = r == null ? 0 : r.ReturnItems
                                }).Select(s => s.value).ToList();
                list.Add(model02);

                result = list;

                return Ok(result);
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return BadRequest();
            }
        }
        #endregion

        #region OrderDispatch Methods
        public async Task<IActionResult> OrderDispatch(int? page, string orderStatus = null)
        {
            var result = (dynamic)null;
            try
            {
                var pageNumber = page ?? 1;
                int pageRowSize = 10;

                var fetchDispatchOrders = await (from od in _context.OrderDispatch
                                           join o in _context.Orders on od.OrderId equals o.Id
                                           orderby od.DispatchDate descending
                                           select new OrderDispatchVM
                                           {
                                               Orders = o,
                                               OrderDispatch = od,
                                               OrderDispatchDetails = (from odd in _context.OrderDispatchDetails
                                                                       where odd.DispatchId == od.Id
                                                                       join pi in _context.ProductItems on odd.ProductItemId equals pi.Id
                                                                       join p in _context.Products on pi.ProductId equals p.Id
                                                                       join iS in _context.ItemSpace on odd.ItemSpaceId equals iS.Id
                                                                       join w in _context.Warehouse on iS.WarehouseId equals w.Id
                                                                       join r in _context.Reck on iS.ReckId equals r.Id
                                                                       select new OrderDispatchWithDetails
                                                                       {
                                                                           OrderDispatchDetails = odd,
                                                                           ProductItems = pi,
                                                                           Products = p,
                                                                           ItemSpace = iS,
                                                                           Warehouse = w,
                                                                           Reck = r
                                                                       }).ToList()
                                           }).ToListAsync();
                var filterValues = new int[] { 4, 5 };
                ViewData["ddlOrderStatus"] = new SelectList(
                    from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                    where filterValues.Contains((int)e)
                    select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

                ViewData["SelectedOrderStatus"] = string.IsNullOrEmpty(orderStatus) ? "All" : orderStatus;
                ViewData["PageNumber"] = pageNumber;
                result = fetchDispatchOrders; //fetchDispatchOrders.ToPagedList(pageNumber, pageRowSize);
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
            }


            return View(result);
        }

        [HttpGet, ActionName("CreateDispatchOrder")]
        public async Task<IActionResult> CreateDispatchOrder(long orderId)
        {
            var model = (dynamic)null;
            try
            {
                var fetchOrder = _context.Orders.Find(orderId);

                if (fetchOrder.OrderStatus == StaticValues.ApplicationStatus.FullDispatch.ToString() || fetchOrder.OrderStatus == StaticValues.ApplicationStatus.Cancelled.ToString())
                {
                    return PartialView("_OrderDispatch", model);
                }

                if (fetchOrder != null)
                {
                    var fetchOrderDetails = from od in _context.OrderDetails
                                            where od.OrderId == fetchOrder.Id
                                            join p in _context.Products on od.ProductId equals p.Id
                                            join w in _context.Warehouse on od.WarehouseId equals w.Id
                                            select new OrderVM.OrderWithDetails
                                            {
                                                OrderDetails = od,
                                                Products = p,
                                                Warehouse = w,
                                                ProductItemDetails = (from pi in _context.ProductItems
                                                                      join iS in _context.ItemSpace on pi.Id equals iS.ProductItemId
                                                                      join r in _context.Reck on iS.ReckId equals r.Id
                                                                      where pi.ProductId == od.ProductId && iS.WarehouseId == w.Id && iS.IsAllocated == true
                                                                      orderby iS.LastUpdate
                                                                      select new OrderVM.ProductItemWithDetails
                                                                      {
                                                                          ProductItems = pi,
                                                                          ItemSpace = iS,
                                                                          Reck = r
                                                                      }).Take(Convert.ToInt32(od.Quantity)).ToList()
                                            };
                    var returnModel = new OrderVM.CreateOrderDispatchVM()
                    {
                        Orders = fetchOrder,
                        OrderDetails = await fetchOrderDetails.ToListAsync()
                    };
                    model = returnModel;
                }
            }
            catch (Exception ex)
            {
                string error = ex.ToString();
            }

            return PartialView("_OrderDispatch", model);
        }

        [HttpPost, ActionName("CreateDispatchOrder")]
        public async Task<JsonResult> CreateDispatchOrder(Orders obj)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {
                    var fetchOrder = await _context.Orders.FindAsync(obj.Id);
                    if (fetchOrder != null)
                    {
                        var fetchOrderDetails = from od in _context.OrderDetails
                                                where od.OrderId == fetchOrder.Id
                                                select new OrderVM.OrderWithDetails
                                                {
                                                    OrderDetails = od,
                                                    ProductItemDetails = (from pi in _context.ProductItems
                                                                          join iS in _context.ItemSpace on pi.Id equals iS.ProductItemId
                                                                          where pi.ProductId == od.ProductId && iS.WarehouseId == od.WarehouseId && iS.IsAllocated == true
                                                                          orderby iS.LastUpdate
                                                                          select new OrderVM.ProductItemWithDetails
                                                                          {
                                                                              ProductItems = pi,
                                                                              ItemSpace = iS,
                                                                          }).Take(Convert.ToInt32(od.Quantity)).ToList()
                                                };

                        TransactionOptions options = new TransactionOptions();
                        options.IsolationLevel = IsolationLevel.Serializable;
                        options.Timeout = new TimeSpan(0, 10, 0);
                        using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                        {
                            //Dispatch No generating...
                            OrderDispatch lastDispatch = _context.OrderDispatch.OrderByDescending(d => d.DispatchDate).FirstOrDefault();
                            string newDispatchNo = "";
                            if (lastDispatch != null)
                            {
                                int dispatchNo = Convert.ToInt32(lastDispatch.DispatchNo.Substring(10)) + 1;
                                newDispatchNo = _cmnBusinessFunction.GenerateNumberWithPrefix("DIS-", dispatchNo.ToString());
                            }
                            else
                            {
                                newDispatchNo = _cmnBusinessFunction.GenerateNumberWithPrefix("DIS-", 1.ToString());
                            }

                            var newDispatch = new OrderDispatch
                            {
                                DispatchNo = newDispatchNo,
                                OrderId = fetchOrder.Id,
                                DispatchDate = DateTime.UtcNow,
                                Status = StaticValues.ApplicationStatus.FullDispatch.ToString()
                            };
                            _context.OrderDispatch.Add(newDispatch);
                            _context.SaveChanges();

                            foreach (var item in fetchOrderDetails)
                            {
                                foreach (var insideItem in item.ProductItemDetails)
                                {
                                    var newDispatchDetail = new OrderDispatchDetails()
                                    {
                                        DispatchId = newDispatch.Id,
                                        ProductId = item.OrderDetails.ProductId,
                                        ProductItemId = insideItem.ProductItems.Id,
                                        ItemSpaceId = insideItem.ItemSpace.Id,
                                        ProductStatus = StaticValues.ApplicationStatus.FullDispatch.ToString()
                                    };
                                    _context.OrderDispatchDetails.Add(newDispatchDetail);
                                    _context.SaveChanges();

                                    //Update ItemSpace
                                    var updateItemSpace = insideItem.ItemSpace;
                                    updateItemSpace.ProductItemId = (dynamic)null;
                                    updateItemSpace.IsAllocated = false;
                                    updateItemSpace.LastUpdate = DateTime.UtcNow;
                                    _context.ItemSpace.Update(updateItemSpace);
                                    _context.SaveChanges();
                                }
                                //Update Old OrderDetail
                                var updateOrderDetail = item.OrderDetails;
                                updateOrderDetail.ProductStatus = StaticValues.ApplicationStatus.FullDispatch.ToString();
                                updateOrderDetail.LastUpdate = DateTime.UtcNow;
                                _context.OrderDetails.Update(updateOrderDetail);
                                _context.SaveChanges();
                            }

                            //Update Old Order
                            var updateOrder = fetchOrder;
                            updateOrder.OrderStatus = StaticValues.ApplicationStatus.FullDispatch.ToString();
                            updateOrder.LastUpdate = DateTime.UtcNow;
                            _context.Orders.Update(updateOrder);
                            _context.SaveChanges();

                            transaction.Complete();
                            return result = Json(new { success = true, message = "Order successfully dispatched.", redirectUrl = @"/Orders/CreateOrderDispatchPrint?dispatchId=" + newDispatch.Id});
                        }
                    }
                    return result = Json(new { success = false, message = "Failed to fetch order data.", redirectUrl = "" });

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

        [HttpGet, ActionName("CreateOrderDispatchPrint")]
        public IActionResult CreateOrderDispatchPrint(long dispatchId)
        {
            return View("CreateOrderDispatchPrint", dispatchId);
        }

        [Produces("application/json")]
        [HttpGet, ActionName("GetOrderDispatchPrintData")]
        public IActionResult GetOrderDispatchPrintData(string jsonData)
        {
            try
            {
                var result = (dynamic)null;
                var dispatchId = JsonConvert.DeserializeObject<long>(jsonData);

                var fetchCompany = _context.Company.FirstOrDefault();
                //Converting logo into base64 string
                string logoPath = System.IO.Path.Combine(_he.WebRootPath, fetchCompany.SmallLogo);
                string extension = System.IO.Path.GetExtension(logoPath);
                string logo = "data:image/" + extension + ";base64," + Convert.ToBase64String(System.IO.File.ReadAllBytes(logoPath));

                var fetchOrderDispatch = _context.OrderDispatch.Find(dispatchId);
                var fetchOrder = _context.Orders.Find(fetchOrderDispatch.OrderId);
                //QRCode generating 
                string generateQr = "data:image/" + ".png" + ";base64," + Convert.ToBase64String(_cmnFunction.CreateQrCode(string.Format("Company Name: {0}, OrderNo: {1}, DispatchNo: {2}", fetchCompany.Name, fetchOrder.OrderNo, fetchOrderDispatch.DispatchNo)));

                if (fetchOrderDispatch != null)
                {
                    var fetchOrderDispatchDetails = from odd in _context.OrderDispatchDetails
                                                    where odd.DispatchId == fetchOrderDispatch.Id

                                                    join pI in _context.ProductItems on odd.ProductItemId equals pI.Id
                                                    join p in _context.Products on pI.ProductId equals p.Id

                                                    join iS in _context.ItemSpace on odd.ItemSpaceId equals iS.Id
                                                    join r in _context.Reck on iS.ReckId equals r.Id
                                                    join w in _context.Warehouse on iS.WarehouseId equals w.Id

                                                    orderby iS.LastUpdate

                                                    select new ArrayList {
                                                       pI.ItemSerial, p.Name, w.Title+"->"+ r.ReckName+"->"+iS.ReckLevel
                                                    };

                    result = new PrintVM.CreateOrderDispatchPrintVM()
                    {
                        Company = fetchCompany,
                        Logo = logo,
                        QRCode = generateQr,
                        Orders = fetchOrder,
                        OrderDispatch = fetchOrderDispatch,
                        OrderDispatchDetails = fetchOrderDispatchDetails.ToList(),
                        TotalProduct = fetchOrderDispatchDetails.Count()
                    };
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return BadRequest();
            }
        }
        #endregion

        #region OrderReturn Methods
        public async Task<IActionResult> OrderReturn(int? page, string orderStatus = null)
        {
            var pageNumber = page ?? 1;
            int pageRowSize = 10;

            var fetchOrderReturns = new List<OrderReturnVM>();
            if (string.IsNullOrEmpty(orderStatus) || orderStatus == "All")
            {
                var fetchReturnOrder = from or in _context.OrderReturn
                                       join o in _context.Orders on or.OrderId equals o.Id
                                       orderby or.ReturnDate descending
                                       select new OrderReturnVM
                                       {
                                           OrderReturn = or,
                                           Orders = o,
                                           OrderReturnDetails = (from ord in _context.OrderReturnDetails
                                                                 where ord.ReturnId == or.Id
                                                                 join pI in _context.ProductItems on ord.ProductItemId equals pI.Id
                                                                 join p in _context.Products on pI.ProductId equals p.Id
                                                                 select new OrderReturnDetailWithOthers
                                                                 {
                                                                     OrderReturnDetails = ord,
                                                                     ProductItems = pI,
                                                                     Products = p
                                                                 }).ToList()
                                       };
                fetchOrderReturns = fetchReturnOrder.ToList();
            }
            //else
            //{
            //    var fetchOrder = from o in _context.Orders
            //                     where o.OrderStatus == orderStatus
            //                     orderby o.OrderPlaceDate descending
            //                     select new OrdersVM
            //                     {
            //                         Orders = o,
            //                         OrderDetails = (from od in _context.OrderDetails
            //                                         where od.OrderId == o.Id
            //                                         join w in _context.Warehouse on od.WarehouseId equals w.Id
            //                                         join p in _context.Products on od.ProductId equals p.Id
            //                                         select new OrderDetailWithOthers
            //                                         {
            //                                             OrderDetails = od,
            //                                             Warehouse = w,
            //                                             Products = p
            //                                         }).ToList()
            //                     };
            //    fetchOrderReturns = fetchOrder.ToList();
            //}


            var filterValues = new int[] { 6, 7 };
            ViewData["ddlOrderStatus"] = new SelectList(
                from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

            ViewData["SelectedOrderStatus"] = string.IsNullOrEmpty(orderStatus) ? "All" : orderStatus;
            ViewData["PageNumber"] = pageNumber;

            var result = await fetchOrderReturns.ToPagedListAsync(pageNumber, pageRowSize);

            return View(result);
        }

        [Produces("application/json")]
        [HttpGet, ActionName("CreateOrderReturn")]
        public async Task<IActionResult> CreateOrderReturn(string orderNo)
        {
            try
            {
                var result = (dynamic)null;

                var getOrder = _context.Orders.Where(o => String.Equals(o.OrderNo, orderNo, StringComparison.CurrentCultureIgnoreCase)).FirstOrDefault();
                if (getOrder == null || getOrder.OrderStatus == StaticValues.ApplicationStatus.Cancelled.ToString() || getOrder.OrderStatus == StaticValues.ApplicationStatus.Submitted.ToString())
                {
                    return View("CreateOrderReturn", result);
                }

                //getting already order return details
                var getReturnOrder = _context.OrderReturn.Where(o => o.OrderId == getOrder.Id).Select(s => s.Id).ToList();
                var getReturnedProducts = _context.OrderReturnDetails.Where(ord => getReturnOrder.Contains(Convert.ToInt64(ord.ReturnId))).ToList();


                //getting dispatch order details
                var getDispatchOrder = _context.OrderDispatch.Where(o => o.OrderId == getOrder.Id).Select(s => s.Id).ToList();
                var getReturnableProducts = _context.OrderDispatchDetails.Where(odd => getDispatchOrder.Contains(Convert.ToInt64(odd.DispatchId)));
                var productReturnableDetails = (from odd in getReturnableProducts
                                                join pI in _context.ProductItems on odd.ProductItemId equals pI.Id
                                                join p in _context.Products on pI.ProductId equals p.Id
                                                select new ProductItemDetails
                                                {
                                                    OrderDispatchDetails = odd,
                                                    ProductItems = pI,
                                                    Products = p,
                                                    IsAlreadyReturned = getReturnedProducts.Find(f => f.ProductItemId == odd.ProductItemId) != null ? true : false
                                                }).ToList();


                result = new CreateOrderReturnVM()
                {
                    Orders = getOrder,
                    ProductItemDetails = productReturnableDetails
                };

                ViewData["Warehouses"] = new SelectList(await _context.Warehouse.ToListAsync(), "Id", "Title");

                return View("CreateOrderReturn", result);
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return BadRequest();
            }
        }

        [HttpPost, ActionName("CreateOrderReturn")]
        public JsonResult CreateOrderReturn(CreateOrderReturnVM model)
        {
            var result = (dynamic)null;
            try
            {
                var getReturnProducts = model.ProductItemDetails.Where(p => p.IsReturnable == true).ToList();
                var getFilteredProductItems = getReturnProducts.Select(s => s.ProductItems.Id);
               
                var iSalreadyReturnInWarehouse = _context.ItemSpace.Where(pi => getFilteredProductItems.Contains((long)pi.ProductItemId));
                
                var getFilteredVirtualSpace = _context.VirtualSpace.Where(vs => vs.Status == StaticValues.ApplicationStatus.VirtualStored.ToString());
                var iSalreadyReturnInVirtualSpace = getFilteredVirtualSpace.Where(vs => getFilteredProductItems.Contains((long)vs.ProductItemId));

                if (iSalreadyReturnInWarehouse.Count() > 0 || iSalreadyReturnInVirtualSpace.Count() > 0)
                {
                    return result = Json(new { success = false, message = "Items have already returned.", redirectUrl = "" });
                }

                if (getReturnProducts.Count() > 0)
                {
                    switch (model.Storage)
                    {
                        case "VirtualStore":
                            {
                                TransactionOptions options = new TransactionOptions();
                                options.IsolationLevel = IsolationLevel.Serializable;
                                options.Timeout = new TimeSpan(0, 10, 0);
                                using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                                {

                                    var newRetun = new OrderReturn();

                                    //Return No Generate
                                    var getLastReturnNo = _context.OrderReturn.OrderByDescending(pu => pu.ReturnDate).FirstOrDefault();
                                    if (getLastReturnNo != null)
                                    {
                                        int creatReturnNo = Convert.ToInt32(getLastReturnNo.ReturnNo.Substring(10)) + 1;
                                        newRetun.ReturnNo = _cmnBusinessFunction.GenerateNumberWithPrefix("RTN-", creatReturnNo.ToString());
                                    }
                                    else
                                    {
                                        newRetun.ReturnNo = _cmnBusinessFunction.GenerateNumberWithPrefix("RTN-", 1.ToString());
                                    }

                                    //Master Record >> Order Return insertion
                                    newRetun.OrderId = model.Orders.Id;
                                    //newRetun.Status = "Status will be insert later";
                                    newRetun.ReturnDate = DateTime.UtcNow;
                                    _context.OrderReturn.Add(newRetun);
                                    _context.SaveChanges();

                                    foreach (var item in getReturnProducts)
                                    {
                                        //Child Record >> Order Return Detail insertion
                                        var newReturnDetail = new OrderReturnDetails()
                                        {
                                            ProductItemId = item.ProductItems.Id,
                                            ProductId = item.Products.Id,
                                            ProductStatus = StaticValues.ApplicationStatus.FullReturn.ToString(),
                                            ReturnId = newRetun.Id,
                                            LastUpdate = DateTime.UtcNow,
                                        };
                                        _context.OrderReturnDetails.Add(newReturnDetail);
                                        _context.SaveChanges();

                                        //Virtual Store insertion
                                        var newVStore = new VirtualSpace()
                                        {
                                            ProductItemId = item.ProductItems.Id,
                                            FromOrderId = model.Orders.Id,
                                            Status = StaticValues.ApplicationStatus.VirtualStored.ToString(),
                                            InsertedDate = DateTime.UtcNow
                                        };
                                        _context.VirtualSpace.Add(newVStore);
                                        _context.SaveChanges();
                                    }

                                    transaction.Complete();
                                    return result = Json(new { success = true, message = newRetun.ReturnNo + ": Successfully returned to virtual store.", redirectUrl = @"/Orders/CreateOrderReturnPrint?returnId="+ newRetun.Id });
                                }

                            }
                        case "WarehouseStore":
                            {
                                if (model.WarehouseId > 0)
                                {
                                    //Available Space check
                                    var isSpaceAvailable = _context.ItemSpace.Where(w => w.WarehouseId == model.WarehouseId && w.IsAllocated == false).ToList();
                                    if (isSpaceAvailable == null || isSpaceAvailable.Count() < getReturnProducts.Count())
                                    {
                                        var getWarehouseTitle = _context.Warehouse.Where(w => w.Id == model.WarehouseId);
                                        return result = Json(new { success = false, message = "No space available under " + getWarehouseTitle.FirstOrDefault().Title + " for the quantity of " + getReturnProducts.Count().ToString(), redirectUrl = "" });
                                    }

                                    TransactionOptions options = new TransactionOptions();
                                    options.IsolationLevel = IsolationLevel.Serializable;
                                    options.Timeout = new TimeSpan(0, 10, 0);
                                    using (TransactionScope transaction = new TransactionScope(TransactionScopeOption.Required, options))
                                    {

                                        var newRetun = new OrderReturn();

                                        //Return No Generate
                                        var getLastReturnNo = _context.OrderReturn.OrderByDescending(pu => pu.ReturnDate).FirstOrDefault();
                                        if (getLastReturnNo != null)
                                        {
                                            int creatReturnNo = Convert.ToInt32(getLastReturnNo.ReturnNo.Substring(10)) + 1;
                                            newRetun.ReturnNo = _cmnBusinessFunction.GenerateNumberWithPrefix("RTN-", creatReturnNo.ToString());
                                        }
                                        else
                                        {
                                            newRetun.ReturnNo = _cmnBusinessFunction.GenerateNumberWithPrefix("RTN-", 1.ToString());
                                        }

                                        //Order Return insertion
                                        newRetun.OrderId = model.Orders.Id;
                                        //newRetun.Status = "Status will be insert later";
                                        newRetun.ReturnDate = DateTime.UtcNow;
                                        _context.OrderReturn.Add(newRetun);
                                        _context.SaveChanges();

                                        for (int i = 0; i < getReturnProducts.Count(); i++)
                                        {
                                            var newReturnDetail = new OrderReturnDetails()
                                            {
                                                ProductItemId = getReturnProducts[i].ProductItems.Id,
                                                ProductId = getReturnProducts[i].Products.Id,
                                                ProductStatus = StaticValues.ApplicationStatus.FullReturn.ToString(),
                                                ReturnId = newRetun.Id,
                                                ItemSpaceId = isSpaceAvailable[i].Id,
                                                LastUpdate = DateTime.UtcNow,
                                            };
                                            _context.OrderReturnDetails.Add(newReturnDetail);
                                            _context.SaveChanges();

                                            //Update ItemSpace
                                            isSpaceAvailable[i].ProductItemId = getReturnProducts[i].ProductItems.Id;
                                            isSpaceAvailable[i].IsAllocated = true;
                                            isSpaceAvailable[i].LastUpdate = DateTime.UtcNow;
                                            isSpaceAvailable[i].ActionedBy = 0;
                                            _context.ItemSpace.Update(isSpaceAvailable[i]);
                                            _context.SaveChanges();

                                            //Stock Generate one by one while loop is running
                                            var isStockExist = _context.Stock.Where(s => s.ProductId == getReturnProducts[i].Products.Id && s.WarehouseId == model.WarehouseId).FirstOrDefault();
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
                                                    ProductId = getReturnProducts[i].Products.Id,
                                                    WarehouseId = model.WarehouseId,
                                                    ReferenecId = newRetun.ReturnNo,
                                                    TableReference = "OrderReturn",
                                                    Note = "Generated From Orders/CreateOrderReturn"
                                                });
                                            }
                                            else
                                            {
                                                var newStock = new Stock()
                                                {
                                                    WarehouseId = model.WarehouseId,
                                                    ProductId = getReturnProducts[i].Products.Id,
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
                                                    ProductId = getReturnProducts[i].Products.Id,
                                                    ReferenecId = newRetun.ReturnNo,
                                                    TableReference = "OrderReturn",
                                                    Note = "Generated From Orders/CreateOrderReturn"
                                                });
                                            }
                                        }



                                        transaction.Complete();
                                        return result = Json(new { success = true, message = newRetun.ReturnNo + ": Successfully returned to selected warehouse.", redirectUrl = @"/Orders/CreateOrderReturnPrint?returnId=" + newRetun.Id });
                                    }
                                }
                                else
                                {
                                    return result = Json(new { success = false, message = "Please select warehouse to store return product.", redirectUrl = "" });
                                }
                            }
                        default:
                            return result = Json(new { success = false, message = "Please select storage to return product.", redirectUrl = "" });
                    }
                }
                else
                    return result = Json(new { success = false, message = "Failed to place return order.", redirectUrl = "" });
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
            }
        }

        [HttpGet, ActionName("CreateOrderReturnPrint")]
        public IActionResult CreateOrderReturnPrint(long returnId)
        {
            return View("CreateOrderReturnPrint", returnId);
        }

        [Produces("application/json")]
        [HttpGet, ActionName("GetOrderReturnPrintData")]
        public IActionResult GetOrderReturnPrintData(string jsonData)
        {
            try
            {
                var result = (dynamic)null;
                var returnId = JsonConvert.DeserializeObject<long>(jsonData);

                var fetchCompany = _context.Company.FirstOrDefault();
                //Converting logo into base64 string
                string logoPath = System.IO.Path.Combine(_he.WebRootPath, fetchCompany.SmallLogo);
                string extension = System.IO.Path.GetExtension(logoPath);
                string logo = "data:image/" + extension + ";base64," + Convert.ToBase64String(System.IO.File.ReadAllBytes(logoPath));

                var fetchOrderReturn = _context.OrderReturn.Find(returnId);
                var fetchOrder = _context.Orders.Find(fetchOrderReturn.OrderId);
                //QRCode generating 
                string generateQr = "data:image/" + ".png" + ";base64," + Convert.ToBase64String(_cmnFunction.CreateQrCode(string.Format("Company Name: {0}, OrderNo: {1}, ReturnNo: {2}", fetchCompany.Name, fetchOrder.OrderNo, fetchOrderReturn.ReturnNo)));

                var fetchOrderReturnDetails = (dynamic)null;
                if (fetchOrderReturn != null)
                {
                    var fetchORD = _context.OrderReturnDetails.Where(ord => ord.ReturnId == fetchOrderReturn.Id);
                    if (fetchORD != null)
                    {
                        if (fetchORD.FirstOrDefault().ItemSpaceId == null)
                        {
                            fetchOrderReturnDetails = (from ord in fetchORD
                                                      join pI in _context.ProductItems on ord.ProductItemId equals pI.Id
                                                      join p in _context.Products on pI.ProductId equals p.Id
                                                      select new ArrayList {
                                                                p.Name + "\n" + pI.ItemSerial, "Stored into virtual store.", 1
                                                            }).ToList();
                        }
                        else {
                            fetchOrderReturnDetails = (from ord in fetchORD
                                                      join pI in _context.ProductItems on ord.ProductItemId equals pI.Id
                                                      join p in _context.Products on pI.ProductId equals p.Id

                                                      join iS in _context.ItemSpace on ord.ItemSpaceId equals iS.Id
                                                      join r in _context.Reck on iS.ReckId equals r.Id
                                                      join w in _context.Warehouse on iS.WarehouseId equals w.Id

                                                      select new ArrayList {
                                                                p.Name + "\n" + pI.ItemSerial, w.Title+"-> "+r.ReckName+"-> "+iS.ReckLevel, 1
                                                            }).ToList();
                        }
                    }

                    result = new PrintVM.CreateOrderReturnPrintVM()
                    {
                        Company = fetchCompany,
                        Logo = logo,
                        QRCode = generateQr,
                        Orders = fetchOrder,
                        OrderReturn = fetchOrderReturn,
                        OrderReturnDetails = fetchOrderReturnDetails,
                        TotalProduct = fetchOrderReturnDetails.Count
                    };
                }

                return Ok(result);
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return BadRequest();
            }
        }

        #endregion

        #region Page Related Methods
        [Produces("application/json")]
        [HttpGet, ActionName("GetProducts")]
        public async Task<IActionResult> GetProducts(string jsonData)
        {
            try
            {
                var data = JsonConvert.DeserializeObject<int>(jsonData);
                var result = (dynamic)null;
                await Task.Run(()=> {
                    var getProducts = from p in _context.Products
                                      join s in _context.Stock on p.Id equals s.ProductId
                                      where s.WarehouseId == data
                                      select new { p.Id, Name = p.Name + " Available Quantity: " + s.AvailableQuantity };

                    result = getProducts;
                });
                return Ok(result);
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return BadRequest();
            }
        }

        [Produces("application/json")]
        [HttpGet, ActionName("OrderSearch")]
        public async Task<IActionResult> OrderSearch()
        {
            try
            {
                string term = HttpContext.Request.Query["term"].ToString();
                var result = await _context.Orders.Where(p => p.OrderNo.Contains(term)).Select(p => p.OrderNo).ToListAsync();
                return Ok(result);
            }
            catch
            {
                return BadRequest();
            }
        }
        #endregion

    }
}
