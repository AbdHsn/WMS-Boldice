using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.ReportsVM.GetOrderReturnByDateRange
{

    public class GetOrderReturnByDateRange
    {
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public string Status { get; set; }
        public Company Company { get; set; }

        public List<OrderReturnVM> OrderReturnVM { get; set; }
    }

    public class OrderReturnVM
    {
        public OrderReturn OrderReturn { get; set; }
        public Orders Orders { get; set; }
        public IQueryable<OrderReturnDetailWithOthers> OrderReturnDetails { get; set; }
    }

    public class OrderReturnDetailWithOthers
    {
        public OrderReturnDetails OrderReturnDetails { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
    }

}
 