using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class ProductItems
    {
        public long Id { get; set; }
        public long? ProductId { get; set; }
        public string ItemSerial { get; set; }
        public string PackSerial { get; set; }
        public string ManualSerial { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string Status { get; set; }
    }
}
