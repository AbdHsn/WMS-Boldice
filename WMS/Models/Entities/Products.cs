using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Products
    {
        public long Id { get; set; }
        public string ProductCode { get; set; }
        public string Name { get; set; }
        public int? ProductTypeId { get; set; }
        public int? BrandId { get; set; }
        public long? ManufacturerId { get; set; }
        public string Description { get; set; }
        public string SmallImage { get; set; }
        public string BigImage { get; set; }
        public decimal? CostPrice { get; set; }
        public decimal? SellingPrice { get; set; }
        public string MetaTags { get; set; }
        public bool? IsActive { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? UpdateDate { get; set; }
    }
}
