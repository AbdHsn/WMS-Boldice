using System.Collections.Generic;
using System.Linq;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.ProductVM.ReckView
{
    public class SingleReckViewVM
    {
        public Reck Reck { get; set; }
        public Warehouse Warehouse { get; set; }
        public IQueryable<ReckItems> ReckItems { get; set; }
    }
    
    public class ReckItems
    {
        public ItemSpace ItemSpace { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
        public ProductType ProductType { get; set; }
    }
}
