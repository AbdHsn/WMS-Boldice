using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.OrdersVM
{
    public class OrderDispatchVM
    {
        public OrderDispatch OrderDispatch { get; set; }
        public Orders Orders { get; set; }
        public List<OrderDispatchWithDetails> OrderDispatchDetails { get; set; }
    }

    public class OrderDispatchWithDetails {
        public OrderDispatchDetails OrderDispatchDetails { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
        public ItemSpace ItemSpace { get; set; }
        public Warehouse Warehouse { get; set; }
        public Reck Reck { get; set; }
    }

}
 