using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Collections;

namespace WMS.Models.PageModels.OrdersVM.PrintVM
{
    public class CreateOrderDispatchPrintVM
    {
        public Company Company { get; set; }
        public Orders Orders { get; set; }
        public OrderDispatch OrderDispatch { get; set; }
        public List<ArrayList> OrderDispatchDetails { get; set; }
        public string Logo { get; set; }
        public string QRCode { get; set; }
        public int TotalProduct { get; set; }
    }
}
 