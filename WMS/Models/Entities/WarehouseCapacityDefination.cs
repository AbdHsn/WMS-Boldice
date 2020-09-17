using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class WarehouseCapacityDefination
    {
        public int Id { get; set; }
        public long? WarehouseId { get; set; }
        public int? Row { get; set; }
        public int? Column { get; set; }
        public int? ReckQuantity { get; set; }
        public bool? IsActive { get; set; }
    }
}
