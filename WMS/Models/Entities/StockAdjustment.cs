using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class StockAdjustment
    {
        public long Id { get; set; }
        public string AdjustmentNo { get; set; }
        public int? WarehouseId { get; set; }
        public long? ProductId { get; set; }
        public int? Quantity { get; set; }
        public string TargetOnEffect { get; set; }
        public string Note { get; set; }
        public long? CreatedBy { get; set; }
        public DateTime? EntryDate { get; set; }
    }
}
