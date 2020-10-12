using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;
using System.Transactions;
using CommonLogics;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using MimeKit.IO.Filters;
using Newtonsoft.Json;
using WMS.CommonBusinessFunctions;
using WMS.CommonBusinessFunctions.BusinessModels;
using WMS.Models.Entities;
using WMS.Models.PageModels.OrdersVM;
using WMS.Models.PageModels.PaymentsVM;
using WMS.Models.SharedModels;
using X.PagedList;
using ZXing.QrCode.Internal;

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


        //[HttpGet, ActionName("pdf")]
        //[Produces("application/json")]
        //public IActionResult Pdf()
        //{
        //    try
        //    {
        //        var getOrder =    from o in _context.Orders
        //                          where o.Id == 1
        //                          select new OrdersVM{ 
        //                             Orders = o,
        //                             OrderDetails = _context.OrderDetails.Where(od => od.OrderId == o.Id).ToList()
        //                          };

        //        var result = getOrder;
        //        return Ok(result);
        //    }
        //    catch (Exception ex)
        //    {
        //        string err = ex.ToString();
        //        return BadRequest();
        //    }
        //}

        //#region Orders


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
                from StaticValues.OrderStatus e in Enum.GetValues(typeof(StaticValues.OrderStatus))
                where filterValues.Contains((int)e)
                select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

            ViewData["SelectedOrderStatus"] = string.IsNullOrEmpty(orderStatus) ? "All" : orderStatus;
            ViewData["PageNumber"] = pageNumber;

            var result = await fetchOrders.ToPagedListAsync(pageNumber, pageRowSize);

            return View(result);
        }

        public async Task<IActionResult> OrderDispatch(int? page, string orderStatus = null)
        {
            var result = (dynamic)null;
            try
            {
                var pageNumber = page ?? 1;
                int pageRowSize = 10;
                
                var fetchDispatchOrders = (from od in _context.OrderDispatch
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
                                           }).ToList();
                var filterValues = new int[] { 4, 5 };
                ViewData["ddlOrderStatus"] = new SelectList(
                    from StaticValues.OrderStatus e in Enum.GetValues(typeof(StaticValues.OrderStatus))
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
                from StaticValues.OrderStatus e in Enum.GetValues(typeof(StaticValues.OrderStatus))
                where filterValues.Contains((int)e)
                select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

            ViewData["SelectedOrderStatus"] = string.IsNullOrEmpty(orderStatus) ? "All" : orderStatus;
            ViewData["PageNumber"] = pageNumber;

            var result = await fetchOrderReturns.ToPagedListAsync(pageNumber, pageRowSize);

            return View(result);
        }


        [HttpPost, ActionName("CreateDispatchOrder")]
        public async Task<JsonResult> CreateDispatchOrder(Orders obj)
        {
            var result = (dynamic)null;
            try
            {
                if (ModelState.IsValid)
                {

                    var fetchOrder = _context.Orders.Find(obj.Id);
                    if (fetchOrder != null)
                    {
                        var fetchOrderDetails = from od in _context.OrderDetails
                                                where od.OrderId == fetchOrder.Id
                                                select new OrderWithDetails
                                                {
                                                    OrderDetails = od,
                                                    ProductItemDetails = (from pi in _context.ProductItems
                                                                          join iS in _context.ItemSpace on pi.Id equals iS.ProductItemId
                                                                          where pi.ProductId == od.ProductId && iS.WarehouseId == od.WarehouseId && iS.IsAllocated == true
                                                                          orderby iS.LastUpdate
                                                                          select new ProductItemWithDetails
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
                                Status = StaticValues.OrderStatus.FullDispatch.ToString()
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
                                        ProductStatus = StaticValues.OrderStatus.FullDispatch.ToString()
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
                                updateOrderDetail.ProductStatus = StaticValues.OrderStatus.FullDispatch.ToString();
                                updateOrderDetail.LastUpdate = DateTime.UtcNow;
                                _context.OrderDetails.Update(updateOrderDetail);
                                _context.SaveChanges();
                            }

                            //Update Old Order
                            var updateOrder = fetchOrder;
                            updateOrder.OrderStatus = StaticValues.OrderStatus.FullDispatch.ToString();
                            updateOrder.LastUpdate = DateTime.UtcNow;
                            _context.Orders.Update(updateOrder);
                            _context.SaveChanges();

                            transaction.Complete();
                        }
                    }
                    return result = Json(new { success = true, message = "Order successfully dispatched.", redirectUrl = @"/Orders/Dispatch" });
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

        //public async Task<IActionResult> OrdersStatusModified(long orderId, string newOrderStatus, int? page, string oldOrderStatus = null)
        //{
        //    var fetchOrder = await _context.Orders.FindAsync(orderId);
        //    if (fetchOrder != null)
        //    {
        //        fetchOrder.OrderStatus = newOrderStatus;
        //        fetchOrder.LastUpdate = DateTime.UtcNow;
        //        _context.Orders.Update(fetchOrder);
        //        _context.SaveChanges();
        //    }

        //    return RedirectToAction("Orders", new { page, orderStatus = oldOrderStatus });
        //}

        [HttpGet, ActionName("CreateDispatchOrder")]
        public async Task<IActionResult> CreateDispatchOrder(long orderId)
        {
            var model = (dynamic)null;
            try
            {
                var fetchOrder = _context.Orders.Find(orderId);
                if (fetchOrder != null)
                {
                    var fetchOrderDetails = from od in _context.OrderDetails
                                            where od.OrderId == fetchOrder.Id
                                            join p in _context.Products on od.ProductId equals p.Id
                                            join w in _context.Warehouse on od.WarehouseId equals w.Id
                                            select new OrderWithDetails
                                            {
                                                OrderDetails = od,
                                                Products = p,
                                                Warehouse = w,
                                                ProductItemDetails = (from pi in _context.ProductItems
                                                                      join iS in _context.ItemSpace on pi.Id equals iS.ProductItemId
                                                                      join r in _context.Reck on iS.ReckId equals r.Id
                                                                      where pi.ProductId == od.ProductId && iS.WarehouseId == w.Id && iS.IsAllocated == true
                                                                      orderby iS.LastUpdate
                                                                      select new ProductItemWithDetails
                                                                      {
                                                                          ProductItems = pi,
                                                                          ItemSpace = iS,
                                                                          Reck = r
                                                                      }).Take(Convert.ToInt32(od.Quantity)).ToList()
                                            };
                    var returnModel = new CreateOrderDispatchVM()
                    {
                        Orders = fetchOrder,
                        OrderDetails = fetchOrderDetails.ToList()
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

        [HttpPost, ActionName("OrderCancel")]
        public async Task<JsonResult> OrderCancel(Orders model)
        {
            var result = (dynamic)null;
            try
            {
                var or = await _context.Orders.FindAsync(model.Id);

                if (or != null)
                {
                    var fetchOrderDetail = _context.OrderDetails.Where(od => od.OrderId == or.Id).ToList();

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
                                    TableReference = "OrderDetails",
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
                                    TableReference = "OrderDetails",
                                    Note = "Generated From Order Cancellation Orders/OrderCancel"
                                });
                            }

                            item.ProductStatus = StaticValues.OrderStatus.Cancelled.ToString();
                            item.LastUpdate = DateTime.UtcNow;
                            _context.OrderDetails.Update(item);
                            _context.SaveChanges();
                        }

                        or.OrderStatus = StaticValues.OrderStatus.Cancelled.ToString();
                        or.LastUpdate = DateTime.UtcNow;
                        _context.Orders.Update(or);
                        _context.SaveChanges();

                        transaction.Complete();
                    }
                    return result = Json(new { success = true, message = " Order successfully cancelled.", redirectUrl = @"/Orders/Orders" });
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



       
        //  #region Order
        [HttpGet, ActionName("CreateOrder")]
        public async Task<IActionResult> CreateOrder()
        {
            await Task.Run(async () =>
            {
                ViewData["Warehouses"] = new SelectList(await _context.Warehouse.ToListAsync(), "Id", "Title");
            });
            return View("CreateOrder");
        }

        [Produces("application/json")]
        [HttpGet, ActionName("GetProducts")]
        public async Task<IActionResult> GetProducts(string jsonData)
        {
            try
            {
                var data = JsonConvert.DeserializeObject<int>(jsonData);

                var getProducts = from p in _context.Products
                                  join s in _context.Stock on p.Id equals s.ProductId
                                  where s.WarehouseId == data
                                  select new { p.Id, Name = p.Name + " Available Quantity: " + s.AvailableQuantity };

                var result = getProducts;
                return Ok(result);
            }
            catch (Exception ex)
            {
                string err = ex.ToString();
                return BadRequest();
            }
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
                        newOrder.OrderStatus = StaticValues.OrderStatus.Submitted.ToString();
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
                            item.ProductStatus = StaticValues.OrderStatus.Submitted.ToString();
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
                                ReferenecId = newOrder.OrderNo,
                                TableReference = "Orders",
                                Note = "Generated From Orders/CreateOrders"
                            });
                        }

                        transaction.Complete();
                        return result = Json(new { success = true, message = " Order successfully placed.", redirectUrl = @"/Orders/Orders" });
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

        //[HttpGet, ActionName("CCOrderInvoice")]
        //public async Task<IActionResult> CCInvoice(long? orderId)
        //{
        //    var result = (dynamic)null;
        //    var order = await _context.Orders.FindAsync(orderId);
        //    if (order == null)
        //    {
        //        return result = Json(new { success = false, message = " Order details are not found.", redirectUrl = "/Technical/{404}" });
        //    }

        //    var getUser = _context.Users.Where(u => u.Id == order.UserId).FirstOrDefault();
        //    var getPersonalInfo = _context.PersonalDetail.Where(u => u.UserId == order.UserId).FirstOrDefault();
        //    var orderDetails = from od in _context.OrderDetails
        //                       where od.OrderId == order.Id
        //                       join p in _context.Products on od.ProductId equals p.Id
        //                       select new Models.PageModels.OrdersVM.CCOrderInvoice.ListOfOrderDetail
        //                       {
        //                           OrderDetail = od,
        //                           Product = p
        //                       };
        //    //Get Payments records
        //    var getPayments = _context.Payment.Where(p => p.InstrumentNo == order.OrderNo);

        //    var model = new CCOrderInvoiceVM()
        //    {
        //        Order = order,
        //        User = getUser,
        //        PersonalDetail = getPersonalInfo,
        //        ListOrderDetails = orderDetails.ToList(),
        //        TotalAmount = order.GrandTotal,
        //        PaidAmount = getPayments == null ? 0 : getPayments.Sum(s => s.PaidAmount),
        //        QrCode = _cmnFunction.CreateQrCode(string.Format("#:{0}, OrderNo:{1}, OrderDate:{2}, TotalPrice:{3}", order.Id, order.OrderNo, order.OrderPlaceDate, order.GrandTotal))
        //    };
        //    model.DueAmount = model.TotalAmount - model.PaidAmount;
        //    ViewData["PaymentMethods"] = new SelectList(_context.PaymentMethods, "Id", "Name");

        //    return View("Invoices/CCOrderInvoice", model);
        //}

        //#endregion

        //#region Revceive OrdersPayment
        //[HttpPost, ActionName("CreatePayment")]
        //public JsonResult OrderPayment(Models.PageModels.PaymentsVM.PaymentsVM model)
        //{
        //    var result = (dynamic)null;
        //    try
        //    {

        //        if (model != null)
        //        {

        //            using (TransactionScope transaction = new TransactionScope())
        //            {
        //                var newPayment = new Payment();
        //                Payment lastPayment = _context.Payment.OrderByDescending(o => o.TransactionDate).FirstOrDefault();

        //                //Order No generating...
        //                if (lastPayment != null)
        //                {
        //                    int newPaymentNo = Convert.ToInt32(lastPayment.TransactionNo.Substring(10)) + 1;
        //                    newPayment.TransactionNo = _cmnBusinessFunction.GenerateNumberWithPrefix("TRN-", newPaymentNo.ToString());
        //                }
        //                else
        //                {
        //                    newPayment.TransactionNo = _cmnBusinessFunction.GenerateNumberWithPrefix("TRN-", 1.ToString());
        //                }

        //                //Creating new payment record...
        //                newPayment.UserId = model.UserId;
        //                newPayment.InstrumentNo = model.OrderNo;
        //                newPayment.TransactionDate = DateTime.UtcNow;
        //                newPayment.PaidAmount = model.PaidAmount;
        //                newPayment.PaymentMethodId = model.PaymentMethodId;
        //                newPayment.TableReference = "Orders";
        //                _context.Payment.Add(newPayment);
        //                _context.SaveChanges();

        //                transaction.Complete();
        //                return result = Json(new { success = true, message = " Payment successfully Done.", redirectUrl = model.RedirectLink + "?orderId=" + model.OrderId });
        //            }
        //        }
        //        else
        //            return result = Json(new { success = false, message = "Payment Failed!.", redirectUrl = "" });
        //    }
        //    catch (Exception ex)
        //    {
        //        string err = ex.ToString();
        //        return result = Json(new { success = false, message = "Operation failed. Contact with system admin.", redirectUrl = "" });
        //    }
        //}
        //#endregion

        //#region Customer GetMethods
        //[HttpGet, ActionName("CreateCustomer")]
        //public async Task<IActionResult> Create()
        //{
        //    var customerTypes = new List<int> { 4, 5, 6, 7 };

        //    ViewData["UserTypeId"] = new SelectList(await _context.UserType.Where(u => customerTypes.Contains(u.Id)).ToListAsync(), "Id", "TypeName");
        //    return PartialView("_CreateCustomer", new CreateCustomerVM());
        //}
        //#endregion

        //#region Customer PostMethods
        //[HttpPost, ActionName("CreateCustomer")]
        //public async Task<JsonResult> CreateCustomer(CreateCustomerVM user)
        //{
        //    var result = (dynamic)null;
        //    try
        //    {
        //        if (ModelState.IsValid)
        //        {
        //            user.Users.CreateDate = DateTime.UtcNow;
        //            user.Users.UserName = user.Users.Email;
        //            _context.Users.Add(user.Users);
        //            await _context.SaveChangesAsync();

        //            user.PersonalDetail.UserId = user.Users.Id;
        //            _context.PersonalDetail.Add(user.PersonalDetail);
        //            await _context.SaveChangesAsync();

        //            ////Image insertion Code
        //            //if (user.Users.Id > 0)
        //            //{
        //            //    if (user.file != null)
        //            //    {
        //            //        string extension = Path.GetExtension(user.file.FileName);
        //            //        string smallImage = "StaticFiles/Users/SmallImage/";
        //            //        string bigImage = "StaticFiles/Users/BigImage/";

        //            //        if (_cmnFunction.SaveImage(user.file, user.Users.Id.ToString(), Path.Combine(_he.WebRootPath, smallImage), extension, 60, 60))
        //            //        {
        //            //            user.Users.SmallImage = smallImage + user.Users.Id.ToString() + extension;
        //            //        }

        //            //        if (_cmnFunction.SaveImage(user.file, user.Users.Id.ToString(), Path.Combine(_he.WebRootPath, bigImage), extension))
        //            //        {
        //            //            user.Users.BigImage = bigImage + user.Users.Id.ToString() + extension;
        //            //        }

        //            //        _context.Entry(user.Users).State = EntityState.Modified;
        //            //        await _context.SaveChangesAsync();
        //            //    }
        //            //}
        //            ////Image insertion Code
        //            ///
        //            return result = Json(new { success = true, message = user.PersonalDetail.Name + " successfully created.", redirectUrl = @"/Orders/CLOrder" });
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

        //#endregion


        #region OrderSearchMethods

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


        [Produces("application/json")]
        [HttpGet, ActionName("CreateOrderReturn")]
        public async Task<IActionResult> CreateOrderReturn(string orderNo)
        {
            try
            {
                var result = (dynamic)null;

                var getOrder = _context.Orders.Where(o => String.Equals(o.OrderNo, orderNo, StringComparison.CurrentCultureIgnoreCase)).FirstOrDefault();
                if (getOrder == null || getOrder.OrderStatus == StaticValues.OrderStatus.Cancelled.ToString() || getOrder.OrderStatus == StaticValues.OrderStatus.Submitted.ToString())
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


                result = new CreateOrderReturnVM() { 
                    Orders = getOrder,
                    ProductItemDetails = productReturnableDetails
                };

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
                var getReturnProducts = model.ProductItemDetails.Where(p => p.IsReturnable == true);
                if (getReturnProducts.Count() > 0)
                {
                    using (TransactionScope transaction = new TransactionScope())
                    {
                    
                        transaction.Complete();
                        return result = Json(new { success = true, message = " Order successfully placed.", redirectUrl = @"/Orders/Orders" });
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


        #endregion

    }
}
