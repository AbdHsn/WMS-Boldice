using System.Collections.Generic;
using System.Linq;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.WarehouseVM
{
    public class WarehouseCapasityVM
    {
        public IQueryable<ListWarehouseCapasity> ListWarehouseCapacity { get; set; }
    }

    public class ListWarehouseCapasity
    {
        public Warehouse Warehouse { get; set; }
        public WarehouseCapacityDefination WarehouseCapacity { get; set; }
        public IQueryable<Reck> ListReck { get; set; }
        public bool IsSpaceAvailable { get; set; }
    }
}
