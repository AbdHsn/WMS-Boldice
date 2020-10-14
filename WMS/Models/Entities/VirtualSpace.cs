using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class VirtualSpace
    {
        public long Id { get; set; }
        public long? ProductItemId { get; set; }
        public long? FromOrderId { get; set; }
        public string Status { get; set; }
        public DateTime? InsertedDate { get; set; }
        public long? InsertedBy { get; set; }
    }
}
