using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.ProductVM
{
    public class StockChartVM
    {
        public string ProductModel { get; set; }
        public int  AvailableQuantity { get; set; }
    }
}
