using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Warehouse
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Location { get; set; }
        public bool? IsActive { get; set; }
    }
}
