using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Damage
    {
        public long Id { get; set; }
        public string DamageNo { get; set; }
        public long? ProductItemId { get; set; }
        public DateTime? DamagedDate { get; set; }
        public string Note { get; set; }
        public long? InsertedBy { get; set; }
    }
}
