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
using Newtonsoft.Json;
using WMS.CommonBusinessFunctions;
using WMS.CommonBusinessFunctions.BusinessModels;
using WMS.Models.Entities;
using WMS.Models.PageModels.ReportsVM.GetOrderByDateRange;
using WMS.Models.SharedModels;
using X.PagedList;


namespace WMS.Controllers
{
    public class ReportsController : Controller
    {

        #region Global Variables
        private readonly WMSDBContext _context;
        private readonly CommonFunctions _cmnFunction;
        private readonly CommonBusinessLogics _cmnBusinessFunction;
        private readonly IHostingEnvironment _he;
        #endregion

        #region Constructor
        public ReportsController(
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

        #region Order Reports
        public async Task<IActionResult> GetOrderByDateRange(GetOrderByDateRange model)
        {
            var result = (dynamic)null;
            var filterValues = new int[] { 1, 2, 5 };
            ViewData["ddlOrderStatus"] = new SelectList(
                from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = e.ToString(), Name = e.ToString() }, "Id", "Name");

            var fetchOrders = new List<OrdersVM>();
            if (model.FromDate != null && model.ToDate != null)
            {
                if (string.IsNullOrEmpty(model.Status) || model.Status == "All")
                {
                    var fetchOrder = from o in _context.Orders
                                     where o.OrderPlaceDate.Value.Date >= model.FromDate.Value.Date
                                     && o.OrderPlaceDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
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
                                     where o.OrderPlaceDate.Value.Date >= model.FromDate.Value.Date
                                     && o.OrderPlaceDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
                                     && o.OrderStatus == model.Status
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

                result = new GetOrderByDateRange()
                {
                    Status = string.IsNullOrEmpty(model.Status) ? "All" : model.Status,
                    OrdersVM = fetchOrders,
                    FromDate = model.FromDate,
                    ToDate = model.ToDate,
                };
            }

            return View(result);
        }

        [HttpGet, ActionName("PrintOrderByDateRange")]
        public async Task<IActionResult> PrintOrderByDateRange(GetOrderByDateRange model)
        {
            var fetchOrders = new List<OrdersVM>();
            if (model.FromDate != null && model.ToDate != null)
            {
                if (string.IsNullOrEmpty(model.Status) || model.Status == "All")
                {
                    var fetchOrder = from o in _context.Orders
                                     where o.OrderPlaceDate.Value.Date >= model.FromDate.Value.Date 
                                     && o.OrderPlaceDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
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
                                     where o.OrderPlaceDate.Value.Date >= model.FromDate.Value.Date 
                                     && o.OrderPlaceDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
                                     && o.OrderStatus == model.Status
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
            }

            var ReportData = new GetOrderByDateRange() { 
                Status = string.IsNullOrEmpty(model.Status) ? "All" : model.Status,
                OrdersVM = fetchOrders,
                FromDate = model.FromDate,
                ToDate = model.ToDate,
                Company = _context.Company.FirstOrDefault()
            };

            return View(ReportData);
        }

        #endregion

        #region OrderDispatch Reports

        //public async Task<IActionResult> GetOrderDispatchByDateRange(GetOrderDispatchByDateRange model)
        //{
        //    var fetchOrders = new List<OrdersVM>();
        //    if (model.FromDate != null && model.ToDate != null)
        //    {
        //        if (string.IsNullOrEmpty(model.Status) || model.Status == "All")
        //        {
        //            var fetchOrder = from o in _context.Orders
        //                             where o.OrderPlaceDate.Value.Date >= model.FromDate.Value.Date
        //                             && o.OrderPlaceDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
        //                             orderby o.OrderPlaceDate descending
        //                             select new OrdersVM
        //                             {
        //                                 Orders = o,
        //                                 OrderDetails = (from od in _context.OrderDetails
        //                                                 where od.OrderId == o.Id
        //                                                 join w in _context.Warehouse on od.WarehouseId equals w.Id
        //                                                 join p in _context.Products on od.ProductId equals p.Id
        //                                                 select new OrderDetailWithOthers
        //                                                 {
        //                                                     OrderDetails = od,
        //                                                     Warehouse = w,
        //                                                     Products = p
        //                                                 }).ToList()
        //                             };
        //            fetchOrders = fetchOrder.ToList();
        //        }
        //        else
        //        {
        //            var fetchOrder = from o in _context.Orders
        //                             where o.OrderPlaceDate.Value.Date >= model.FromDate.Value.Date
        //                             && o.OrderPlaceDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
        //                             && o.OrderStatus == model.Status
        //                             orderby o.OrderPlaceDate descending
        //                             select new OrdersVM
        //                             {
        //                                 Orders = o,
        //                                 OrderDetails = (from od in _context.OrderDetails
        //                                                 where od.OrderId == o.Id
        //                                                 join w in _context.Warehouse on od.WarehouseId equals w.Id
        //                                                 join p in _context.Products on od.ProductId equals p.Id
        //                                                 select new OrderDetailWithOthers
        //                                                 {
        //                                                     OrderDetails = od,
        //                                                     Warehouse = w,
        //                                                     Products = p
        //                                                 }).ToList()
        //                             };
        //            fetchOrders = fetchOrder.ToList();
        //        }
        //    }


        //    var ReportData = new GetOrderByDateRange()
        //    {
        //        Status = string.IsNullOrEmpty(model.Status) ? "All" : model.Status,
        //        OrdersVM = fetchOrders,
        //        FromDate = model.FromDate,
        //        ToDate = model.ToDate,

        //    };

        //    var filterValues = new int[] { 1, 2, 5 };
        //    ViewData["ddlOrderStatus"] = new SelectList(
        //        from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
        //        where filterValues.Contains((int)e)
        //        select new { Id = e.ToString(), Name = e.ToString() }, "Id", "Name");
        //    //   select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

        //    return View(ReportData);
        //}


        //public async Task<IActionResult> OrderDispatch(int? page, string orderStatus = null)
        //{
        //    var result = (dynamic)null;
        //    try
        //    {
        //        var pageNumber = page ?? 1;
        //        int pageRowSize = 10;

        //        var fetchDispatchOrders = await (from od in _context.OrderDispatch
        //                                         join o in _context.Orders on od.OrderId equals o.Id
        //                                         orderby od.DispatchDate descending
        //                                         select new OrderDispatchVM
        //                                         {
        //                                             Orders = o,
        //                                             OrderDispatch = od,
        //                                             OrderDispatchDetails = (from odd in _context.OrderDispatchDetails
        //                                                                     where odd.DispatchId == od.Id
        //                                                                     join pi in _context.ProductItems on odd.ProductItemId equals pi.Id
        //                                                                     join p in _context.Products on pi.ProductId equals p.Id
        //                                                                     join iS in _context.ItemSpace on odd.ItemSpaceId equals iS.Id
        //                                                                     join w in _context.Warehouse on iS.WarehouseId equals w.Id
        //                                                                     join r in _context.Reck on iS.ReckId equals r.Id
        //                                                                     select new OrderDispatchWithDetails
        //                                                                     {
        //                                                                         OrderDispatchDetails = odd,
        //                                                                         ProductItems = pi,
        //                                                                         Products = p,
        //                                                                         ItemSpace = iS,
        //                                                                         Warehouse = w,
        //                                                                         Reck = r
        //                                                                     }).ToList()
        //                                         }).ToListAsync();
        //        var filterValues = new int[] { 4, 5 };
        //        ViewData["ddlOrderStatus"] = new SelectList(
        //            from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
        //            where filterValues.Contains((int)e)
        //            select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

        //        ViewData["SelectedOrderStatus"] = string.IsNullOrEmpty(orderStatus) ? "All" : orderStatus;
        //        ViewData["PageNumber"] = pageNumber;
        //        result = fetchDispatchOrders; //fetchDispatchOrders.ToPagedList(pageNumber, pageRowSize);
        //    }
        //    catch (Exception ex)
        //    {
        //        string error = ex.ToString();
        //    }


        //    return View(result);
        //}




        //>>>>>>>>>>>>>>>>>>>>>>>>>

        //[Produces("application/json")]
        //[HttpGet, ActionName("GetOrderDispatchPrintData")]
        //public IActionResult GetOrderDispatchPrintData(string jsonData)
        //{
        //    try
        //    {
        //        var result = (dynamic)null;
        //        var dispatchId = JsonConvert.DeserializeObject<long>(jsonData);

        //        var fetchCompany = _context.Company.FirstOrDefault();
        //        //Converting logo into base64 string
        //        string logoPath = System.IO.Path.Combine(_he.WebRootPath, fetchCompany.SmallLogo);
        //        string extension = System.IO.Path.GetExtension(logoPath);
        //        string logo = "data:image/" + extension + ";base64," + Convert.ToBase64String(System.IO.File.ReadAllBytes(logoPath));

        //        var fetchOrderDispatch = _context.OrderDispatch.Find(dispatchId);
        //        var fetchOrder = _context.Orders.Find(fetchOrderDispatch.OrderId);
        //        //QRCode generating 
        //        string generateQr = "data:image/" + ".png" + ";base64," + Convert.ToBase64String(_cmnFunction.CreateQrCode(string.Format("Company Name: {0}, OrderNo: {1}, DispatchNo: {2}", fetchCompany.Name, fetchOrder.OrderNo, fetchOrderDispatch.DispatchNo)));

        //        if (fetchOrderDispatch != null)
        //        {
        //            var fetchOrderDispatchDetails = from odd in _context.OrderDispatchDetails
        //                                            where odd.DispatchId == fetchOrderDispatch.Id

        //                                            join pI in _context.ProductItems on odd.ProductItemId equals pI.Id
        //                                            join p in _context.Products on pI.ProductId equals p.Id

        //                                            join iS in _context.ItemSpace on odd.ItemSpaceId equals iS.Id
        //                                            join r in _context.Reck on iS.ReckId equals r.Id
        //                                            join w in _context.Warehouse on iS.WarehouseId equals w.Id

        //                                            orderby iS.LastUpdate

        //                                            select new ArrayList {
        //                                               pI.ItemSerial, p.Name, w.Title+"->"+ r.ReckName+"->"+iS.ReckLevel
        //                                            };

        //            result = new PrintVM.CreateOrderDispatchPrintVM()
        //            {
        //                Company = fetchCompany,
        //                Logo = logo,
        //                QRCode = generateQr,
        //                Orders = fetchOrder,
        //                OrderDispatch = fetchOrderDispatch,
        //                OrderDispatchDetails = fetchOrderDispatchDetails.ToList(),
        //                TotalProduct = fetchOrderDispatchDetails.Count()
        //            };
        //        }

        //        return Ok(result);
        //    }
        //    catch (Exception ex)
        //    {
        //        string err = ex.ToString();
        //        return BadRequest();
        //    }
        //}
        #endregion

        #region OrderReturn Methods
        //public async Task<IActionResult> OrderReturn(int? page, string orderStatus = null)
        //{
        //    var pageNumber = page ?? 1;
        //    int pageRowSize = 10;

        //    var fetchOrderReturns = new List<OrderReturnVM>();
        //    if (string.IsNullOrEmpty(orderStatus) || orderStatus == "All")
        //    {
        //        var fetchReturnOrder = from or in _context.OrderReturn
        //                               join o in _context.Orders on or.OrderId equals o.Id
        //                               orderby or.ReturnDate descending
        //                               select new OrderReturnVM
        //                               {
        //                                   OrderReturn = or,
        //                                   Orders = o,
        //                                   OrderReturnDetails = (from ord in _context.OrderReturnDetails
        //                                                         where ord.ReturnId == or.Id
        //                                                         join pI in _context.ProductItems on ord.ProductItemId equals pI.Id
        //                                                         join p in _context.Products on pI.ProductId equals p.Id
        //                                                         select new OrderReturnDetailWithOthers
        //                                                         {
        //                                                             OrderReturnDetails = ord,
        //                                                             ProductItems = pI,
        //                                                             Products = p
        //                                                         }).ToList()
        //                               };
        //        fetchOrderReturns = fetchReturnOrder.ToList();
        //    }
        //    //else
        //    //{
        //    //    var fetchOrder = from o in _context.Orders
        //    //                     where o.OrderStatus == orderStatus
        //    //                     orderby o.OrderPlaceDate descending
        //    //                     select new OrdersVM
        //    //                     {
        //    //                         Orders = o,
        //    //                         OrderDetails = (from od in _context.OrderDetails
        //    //                                         where od.OrderId == o.Id
        //    //                                         join w in _context.Warehouse on od.WarehouseId equals w.Id
        //    //                                         join p in _context.Products on od.ProductId equals p.Id
        //    //                                         select new OrderDetailWithOthers
        //    //                                         {
        //    //                                             OrderDetails = od,
        //    //                                             Warehouse = w,
        //    //                                             Products = p
        //    //                                         }).ToList()
        //    //                     };
        //    //    fetchOrderReturns = fetchOrder.ToList();
        //    //}


        //    var filterValues = new int[] { 6, 7 };
        //    ViewData["ddlOrderStatus"] = new SelectList(
        //        from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
        //        where filterValues.Contains((int)e)
        //        select new { Id = (int)e, Name = e.ToString() }, "Id", "Name");

        //    ViewData["SelectedOrderStatus"] = string.IsNullOrEmpty(orderStatus) ? "All" : orderStatus;
        //    ViewData["PageNumber"] = pageNumber;

        //    var result = await fetchOrderReturns.ToPagedListAsync(pageNumber, pageRowSize);

        //    return View(result);
        //}

        //[Produces("application/json")]
        //[HttpGet, ActionName("GetOrderReturnPrintData")]
        //public IActionResult GetOrderReturnPrintData(string jsonData)
        //{
        //    try
        //    {
        //        var result = (dynamic)null;
        //        var returnId = JsonConvert.DeserializeObject<long>(jsonData);

        //        var fetchCompany = _context.Company.FirstOrDefault();
        //        //Converting logo into base64 string
        //        string logoPath = System.IO.Path.Combine(_he.WebRootPath, fetchCompany.SmallLogo);
        //        string extension = System.IO.Path.GetExtension(logoPath);
        //        string logo = "data:image/" + extension + ";base64," + Convert.ToBase64String(System.IO.File.ReadAllBytes(logoPath));

        //        var fetchOrderReturn = _context.OrderReturn.Find(returnId);
        //        var fetchOrder = _context.Orders.Find(fetchOrderReturn.OrderId);
        //        //QRCode generating 
        //        string generateQr = "data:image/" + ".png" + ";base64," + Convert.ToBase64String(_cmnFunction.CreateQrCode(string.Format("Company Name: {0}, OrderNo: {1}, ReturnNo: {2}", fetchCompany.Name, fetchOrder.OrderNo, fetchOrderReturn.ReturnNo)));

        //        var fetchOrderReturnDetails = (dynamic)null;
        //        if (fetchOrderReturn != null)
        //        {
        //            var fetchORD = _context.OrderReturnDetails.Where(ord => ord.ReturnId == fetchOrderReturn.Id);
        //            if (fetchORD != null)
        //            {
        //                if (fetchORD.FirstOrDefault().ItemSpaceId == null)
        //                {
        //                    fetchOrderReturnDetails = (from ord in fetchORD
        //                                              join pI in _context.ProductItems on ord.ProductItemId equals pI.Id
        //                                              join p in _context.Products on pI.ProductId equals p.Id
        //                                              select new ArrayList {
        //                                                        p.Name + "\n" + pI.ItemSerial, "Stored into virtual store.", 1
        //                                                    }).ToList();
        //                }
        //                else {
        //                    fetchOrderReturnDetails = (from ord in fetchORD
        //                                              join pI in _context.ProductItems on ord.ProductItemId equals pI.Id
        //                                              join p in _context.Products on pI.ProductId equals p.Id

        //                                              join iS in _context.ItemSpace on ord.ItemSpaceId equals iS.Id
        //                                              join r in _context.Reck on iS.ReckId equals r.Id
        //                                              join w in _context.Warehouse on iS.WarehouseId equals w.Id

        //                                              select new ArrayList {
        //                                                        p.Name + "\n" + pI.ItemSerial, w.Title+"-> "+r.ReckName+"-> "+iS.ReckLevel, 1
        //                                                    }).ToList();
        //                }
        //            }

        //            result = new PrintVM.CreateOrderReturnPrintVM()
        //            {
        //                Company = fetchCompany,
        //                Logo = logo,
        //                QRCode = generateQr,
        //                Orders = fetchOrder,
        //                OrderReturn = fetchOrderReturn,
        //                OrderReturnDetails = fetchOrderReturnDetails,
        //                TotalProduct = fetchOrderReturnDetails.Count
        //            };
        //        }

        //        return Ok(result);
        //    }
        //    catch (Exception ex)
        //    {
        //        string err = ex.ToString();
        //        return BadRequest();
        //    }
        //}

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
