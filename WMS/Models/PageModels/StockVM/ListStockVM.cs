using WMS.Models.Entities;

namespace WMS.Models.PageModels.StockVM
{
    public class ListStockVM
    {
        public Stock Stock { get; set; }
        public Products Products { get; set; }
        public ProductType ProductType { get; set; }
    }
}
