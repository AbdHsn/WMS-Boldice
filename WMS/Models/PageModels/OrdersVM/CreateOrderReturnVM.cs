using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.OrdersVM
{
    public class CreateOrderReturnVM
    {
        public Orders Orders { get; set; }
        public List<ProductItemDetails> ProductItemDetails { get; set; }
    }

    public class ProductItemDetails {
        public OrderDispatchDetails OrderDispatchDetails { get; set; }
        public OrderReturnDetails OrderReturnDetails { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
        public bool IsAlreadyReturned { get; set; }
        public bool IsReturnable { get; set; }
    }

}
 