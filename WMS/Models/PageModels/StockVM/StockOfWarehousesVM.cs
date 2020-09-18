using System.Collections.Generic;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.StockVM
{
    public class StockOfWarehousesVM
    {
        public Warehouse Warehouse { get; set; }
        public List<ListOfStock> ListOfStocks { get; set; }
    }

    public class ListOfStock
    {
        public Stock Stock { get; set; }
        public Products Products { get; set; }
        public ProductType ProductType { get; set; }
    }
}
