using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.OrdersVM
{
    public class OrdersReturnsChartVM
    {
        public string Label { get; set; }
        public string BackgroundColor { get; set; } //= "rgb(5, 99, 132)"; //Default value assigned
        public string BorderColor { get; set; }// = "rgb(25, 99, 132)"; //Default value assigned
        public List<int> Data { get; set; }
    }

    public class MonthWithValue{

    }
}
