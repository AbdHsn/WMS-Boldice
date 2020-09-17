using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class ProductInsertion
    {
        public long Id { get; set; }
        public long? ProductId { get; set; }
        public string EntryNo { get; set; }
        public int? Quantity { get; set; }
        public DateTime? EntryDate { get; set; }
        public string Note { get; set; }
    }
}
