
using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.StockVM
{
    public class ListVirtualSpaceVM
    {
        
        public VirtualSpace VirtualSpace { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
        public Orders Orders { get; set; }
        public OrderReturn OrderReturn { get; set; }

    }
}
