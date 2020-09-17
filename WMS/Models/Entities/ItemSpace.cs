using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class ItemSpace
    {
        public long Id { get; set; }
        public long? WarehouseId { get; set; }
        public long? ReckId { get; set; }
        public int? ReckLevel { get; set; }
        public long? ProductItemId { get; set; }
        public bool? IsAllocated { get; set; }
        public DateTime? LastUpdate { get; set; }
        public long? ActionedBy { get; set; }
    }
}
