using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Damage
    {
        public long Id { get; set; }
        public string DamageNo { get; set; }
        public string ProductSerial { get; set; }
        public long? ProductId { get; set; }
        public decimal? TotalAmount { get; set; }
        public DateTime? EntryDate { get; set; }
        public string Note { get; set; }
    }
}
