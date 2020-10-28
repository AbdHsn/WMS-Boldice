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
using WMS.Models.PageModels.ReportsVM.GetOrderDispatchByDateRange;
using WMS.Models.PageModels.ReportsVM.GetOrderReturnByDateRange;
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

        public async Task<IActionResult> GetOrderDispatchByDateRange(GetOrderDispatchByDateRange model)
        {
            var result = (dynamic)null;

            var filterValues = new int[] { 4, 5 };
            ViewData["ddlOrderDispatchStatus"] = new SelectList(
                from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = e.ToString(), Name = e.ToString() }, "Id", "Name");

            var mappedData = new List<OrderDispatchVM>();
            if (model.FromDate != null && model.ToDate != null)
            {
                if (string.IsNullOrEmpty(model.Status) || model.Status == "All")
                {
                    var fetchDispatchOrders = (from od in _context.OrderDispatch
                                               join o in _context.Orders on od.OrderId equals o.Id
                                               where od.DispatchDate.Value.Date >= model.FromDate.Value.Date
                                               && od.DispatchDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
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
                                                                           })
                                               });


                    mappedData = fetchDispatchOrders.ToList();
                }
                else
                {
                    var fetchDispatchOrders = (from od in _context.OrderDispatch
                                               join o in _context.Orders on od.OrderId equals o.Id
                                               where od.DispatchDate.Value.Date >= model.FromDate.Value.Date
                                               && od.DispatchDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
                                               && od.Status == model.Status
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
                                                                           })
                                               });


                    mappedData = fetchDispatchOrders.ToList();
                }

                result = new GetOrderDispatchByDateRange()
                {
                    Status = string.IsNullOrEmpty(model.Status) ? "All" : model.Status,
                    OrdersDispatchVM = mappedData,
                    FromDate = model.FromDate,
                    ToDate = model.ToDate,
                };
            }

            return View(result);
        }

        public async Task<IActionResult> PrintOrderDispatchByDateRange(GetOrderDispatchByDateRange model)
        {
            var result = (dynamic)null;

            var filterValues = new int[] { 4, 5 };
            ViewData["ddlOrderDispatchStatus"] = new SelectList(
                from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = e.ToString(), Name = e.ToString() }, "Id", "Name");

            var mappedData = new List<OrderDispatchVM>();
            if (model.FromDate != null && model.ToDate != null)
            {
                if (string.IsNullOrEmpty(model.Status) || model.Status == "All")
                {
                    var fetchDispatchOrders = (from od in _context.OrderDispatch
                                               join o in _context.Orders on od.OrderId equals o.Id
                                               where od.DispatchDate.Value.Date >= model.FromDate.Value.Date
                                               && od.DispatchDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
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
                                                                           })
                                               });


                    mappedData = fetchDispatchOrders.ToList();
                }
                else
                {
                    var fetchDispatchOrders = (from od in _context.OrderDispatch
                                               join o in _context.Orders on od.OrderId equals o.Id
                                               where od.DispatchDate.Value.Date >= model.FromDate.Value.Date
                                               && od.DispatchDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
                                               && od.Status == model.Status
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
                                                                           })
                                               });


                    mappedData = fetchDispatchOrders.ToList();
                }

                result = new GetOrderDispatchByDateRange()
                {
                    Status = string.IsNullOrEmpty(model.Status) ? "All" : model.Status,
                    OrdersDispatchVM = mappedData,
                    FromDate = model.FromDate,
                    ToDate = model.ToDate,
                    Company = _context.Company.FirstOrDefault()
                };
            }

            return View(result);
        }

        #endregion

        #region OrderReturn Methods

        public async Task<IActionResult> GetOrderReturnByDateRange(GetOrderReturnByDateRange model)
        {
            var result = (dynamic)null;

            var filterValues = new int[] { 6, 7 };
            ViewData["ddlOrderReturnStatus"] = new SelectList(
                from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = e.ToString(), Name = e.ToString() }, "Id", "Name");

            var mappedData = new List<OrderReturnVM>();
            if (model.FromDate != null && model.ToDate != null)
            {
                if (string.IsNullOrEmpty(model.Status) || model.Status == "All")
                {
                    var fetchReturnOrder = from or in _context.OrderReturn
                                           join o in _context.Orders on or.OrderId equals o.Id
                                           where or.ReturnDate.Value.Date >= model.FromDate.Value.Date
                                           && or.ReturnDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
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
                                                                     })
                                           };
                    mappedData = fetchReturnOrder.ToList();
                }
                else
                {
                    var fetchReturnOrder = from or in _context.OrderReturn
                                           join o in _context.Orders on or.OrderId equals o.Id
                                           where or.ReturnDate.Value.Date >= model.FromDate.Value.Date
                                           && or.ReturnDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
                                           && or.Status == model.Status
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
                                                                     })
                                           };
                    mappedData = fetchReturnOrder.ToList();
                }

                result = new GetOrderReturnByDateRange()
                {
                    Status = string.IsNullOrEmpty(model.Status) ? "All" : model.Status,
                    OrderReturnVM = mappedData,
                    FromDate = model.FromDate,
                    ToDate = model.ToDate
                };
            }

            return View(result);
        }

        public async Task<IActionResult> PrintOrderReturnByDateRange(GetOrderReturnByDateRange model)
        {
            var result = (dynamic)null;

            var filterValues = new int[] { 6, 7 };
            ViewData["ddlOrderDispatchStatus"] = new SelectList(
                from StaticValues.ApplicationStatus e in Enum.GetValues(typeof(StaticValues.ApplicationStatus))
                where filterValues.Contains((int)e)
                select new { Id = e.ToString(), Name = e.ToString() }, "Id", "Name");

            var mappedData = new List<OrderReturnVM>();
            if (model.FromDate != null && model.ToDate != null)
            {
                if (string.IsNullOrEmpty(model.Status) || model.Status == "All")
                {
                    var fetchReturnOrder = from or in _context.OrderReturn
                                           join o in _context.Orders on or.OrderId equals o.Id
                                           where or.ReturnDate.Value.Date >= model.FromDate.Value.Date
                                           && or.ReturnDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
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
                                                                     })
                                           };
                    mappedData = fetchReturnOrder.ToList();
                }
                else
                {
                    var fetchReturnOrder = from or in _context.OrderReturn
                                           join o in _context.Orders on or.OrderId equals o.Id
                                           where or.ReturnDate.Value.Date >= model.FromDate.Value.Date
                                           && or.ReturnDate.Value.Date < model.ToDate.Value.Date.AddDays(1)
                                           && or.Status == model.Status
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
                                                                     })
                                           };
                    mappedData = fetchReturnOrder.ToList();
                }

                result = new GetOrderReturnByDateRange()
                {
                    Status = string.IsNullOrEmpty(model.Status) ? "All" : model.Status,
                    OrderReturnVM = mappedData,
                    FromDate = model.FromDate,
                    ToDate = model.ToDate,
                    Company = _context.Company.FirstOrDefault()
                };
            }

            return View(result);
        }

        #endregion

    }
}
