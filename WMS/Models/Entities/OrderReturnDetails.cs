using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class OrderReturnDetails
    {
        public long Id { get; set; }
        public long? ReturnId { get; set; }
        public long? ProductId { get; set; }
        public long? ProductItemId { get; set; }
        public string ProductStatus { get; set; }
        public DateTime? LastUpdate { get; set; }
    }
}
