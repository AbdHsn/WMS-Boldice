using System.Collections.Generic;
using System.Linq;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.WarehouseVM.WarehouseCapacityVM
{
    public class WarehouseCapacityVM
    {
        public Warehouse Warehouse { get; set; }
        public IQueryable<WarehouseCapacityDefination> WarehouseCapacity { get; set; }
    }

}
