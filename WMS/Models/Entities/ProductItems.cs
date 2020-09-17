using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class ProductItems
    {
        public long Id { get; set; }
        public long? ProductId { get; set; }
        public string ProductSerial { get; set; }
        public DateTime? CreatedDate { get; set; }
    }
}
