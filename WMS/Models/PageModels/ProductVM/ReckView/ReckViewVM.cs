using System.Collections.Generic;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.ProductVM.ReckView
{
    public class ReckViewVM
    {
        public Reck Reck { get; set; }
        public List<ListOfItem> ListOfItems { get; set; }
    }

    public class ListOfItem
    {
        public ItemSpace ItemSpace { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
        public ProductType ProductType { get; set; }
    }
}
