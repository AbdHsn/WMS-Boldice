using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class OrderDispatch
    {
        public long Id { get; set; }
        public long? OrderId { get; set; }
        public string DispatchNo { get; set; }
        public DateTime? DispatchDate { get; set; }
        public string Status { get; set; }
        public long? DispatchBy { get; set; }
    }
}
