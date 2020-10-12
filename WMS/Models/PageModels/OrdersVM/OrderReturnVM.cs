using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.OrdersVM
{
    public class OrderReturnVM
    {
        public OrderReturn OrderReturn { get; set; }
        public Orders Orders { get; set; }
        public List<OrderReturnDetailWithOthers> OrderReturnDetails { get; set; }
    }

    public class OrderReturnDetailWithOthers {
        public OrderReturnDetails OrderReturnDetails { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
    }
}
 