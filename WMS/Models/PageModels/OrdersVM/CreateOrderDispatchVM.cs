using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.OrdersVM
{
    public class CreateOrderDispatchVM
    {
        public Orders Orders { get; set; }
        public List<OrderWithDetails> OrderDetails { get; set; }
    }

    public class OrderWithDetails
    {
        public OrderDetails OrderDetails { get; set; }
        public Products Products { get; set; }
        public Warehouse Warehouse { get; set; }
        public List<ProductItemWithDetails> ProductItemDetails { get; set; }
    }
    
    public class ProductItemWithDetails
    {
        public ProductItems ProductItems { get; set; }
        public ItemSpace ItemSpace { get; set; }
        public Reck Reck { get; set; }
    }

}
 