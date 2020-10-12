using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class OrderDispatchDetails
    {
        public long Id { get; set; }
        public long? DispatchId { get; set; }
        public long? ProductId { get; set; }
        public long? ProductItemId { get; set; }
        public long? ItemSpaceId { get; set; }
        public string ProductStatus { get; set; }
        public DateTime? LastUpdate { get; set; }
    }
}
