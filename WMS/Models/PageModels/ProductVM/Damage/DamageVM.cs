using System.Collections.Generic;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.ProductVM.DamageVM
{
    public class DamageVM
    {
        public Damage Damage { get; set; }
        public ProductItems ProductItems { get; set; }
        public Products Products { get; set; }
    }
}
