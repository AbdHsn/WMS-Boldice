using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.CommonBusinessFunctions.BusinessModels
{
    public class CreateStockTraceBM
    {
        public int WarehouseId { get; set; }
        public long ProductId { get; set; }
        public int NewQuantity { get; set; }
        public string ReferenecId { get; set; }
        public string TableReference { get; set; }
        public string Note { get; set; }
    }
}
