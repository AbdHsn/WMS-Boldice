using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.ItemVM
{
    public class ListProductVM
    {
        public Products Products { get; set; }
        public ProductType ProductType { get; set; }
        public Brand Brand { get; set; }
        public Manufacturer Manufacturer { get; set; }
    }
}
