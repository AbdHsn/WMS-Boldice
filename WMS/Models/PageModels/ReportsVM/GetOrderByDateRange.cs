using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.ReportsVM.GetOrderByDateRange
{
    public class GetOrderByDateRange
    {
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string Status { get; set; }
        public Company Company { get; set; }
        public List<OrdersVM> OrdersVM { get; set; }
    }

    public class OrdersVM
    {
        public Orders Orders { get; set; }
        public List<OrderDetailWithOthers> OrderDetails { get; set; }
    }

    public class OrderDetailWithOthers
    {
        public OrderDetails OrderDetails { get; set; }
        public Warehouse Warehouse { get; set; }
        public Products Products { get; set; }
    }
}
