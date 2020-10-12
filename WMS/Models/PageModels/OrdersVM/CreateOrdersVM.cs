using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.OrdersVM
{
    public class CreateOrdersVM
    {
        #region Customer Properties
        #endregion


        #region OrderDetail Properties
        public List<OrderDetails> ListOrderDetails { get; set; }

        #endregion
    }
}
