using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Stock
    {
        public long Id { get; set; }
        public long? WarehouseId { get; set; }
        public long? ProductId { get; set; }
        public int? AvailableQuantity { get; set; }
        public int? LastQuantity { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? LastUpdate { get; set; }
    }
}
