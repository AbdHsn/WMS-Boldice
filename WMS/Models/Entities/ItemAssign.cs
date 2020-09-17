using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class ItemAssign
    {
        public int Id { get; set; }
        public long? WarehouseId { get; set; }
        public long? ReckId { get; set; }
        public long? ReckLevel { get; set; }
        public string ProductSerial { get; set; }
        public bool? IsAvailable { get; set; }
        public DateTime? LastUpdateDate { get; set; }
        public bool? IsActive { get; set; }
    }
}
