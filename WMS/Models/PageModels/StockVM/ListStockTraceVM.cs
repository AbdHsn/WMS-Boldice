
using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.StockVM
{
    public class ListStockTraceVM
    {
        public StockTrace StockTrace { get; set; }
        public Products Products { get; set; }
        public ProductType ProductType { get; set; }
    }
}
