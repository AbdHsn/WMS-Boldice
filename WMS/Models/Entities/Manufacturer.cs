using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Manufacturer
    {
        public int Id { get; set; }
        public string ManufacturerName { get; set; }
        public string ContactInfo { get; set; }
        public string SmallImage { get; set; }
        public string BigImage { get; set; }
    }
}
