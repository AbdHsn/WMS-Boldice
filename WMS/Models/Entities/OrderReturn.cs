using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class OrderReturn
    {
        public long Id { get; set; }
        public long? OrderId { get; set; }
        public string ReturnNo { get; set; }
        public DateTime? ReturnDate { get; set; }
        public string Status { get; set; }
        public long? ReturnBy { get; set; }
    }
}
