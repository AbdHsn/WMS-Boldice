using System.Collections.Generic;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.ProductVM.DamageVM
{
    public class CreateDamageVM
    {
        public Warehouse Warehouse { get; set; }
        public ProductItems ProductItems { get; set; }
        public string Note { get; set; }
    }
}
