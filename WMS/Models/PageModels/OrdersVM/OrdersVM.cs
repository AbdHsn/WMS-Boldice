using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.OrdersVM
{
    public class OrdersVM
    {
        public Orders Orders { get; set; }
        public List<OrderDetailWithOthers> OrderDetails { get; set; }
    }

    public class OrderDetailWithOthers {
        public OrderDetails OrderDetails { get; set; }
        public Warehouse Warehouse { get; set; }
        public Products Products { get; set; }
    }
}
 