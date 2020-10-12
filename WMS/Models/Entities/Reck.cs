using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Reck
    {
        public long Id { get; set; }
        public int? WarehouseId { get; set; }
        public string ReckName { get; set; }
        public int? SetupRow { get; set; }
        public int? SetupColumn { get; set; }
        public int? ReckLevel { get; set; }
        public bool? IsActive { get; set; }
    }
}
