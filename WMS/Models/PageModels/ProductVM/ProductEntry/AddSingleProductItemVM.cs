using Microsoft.AspNetCore.Http;
using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.ProductVM.ProductEntry
{
    public class AddSingleProductItemVM
    {
        public ProductInsertion ProductInsertion { get; set; }
        public Warehouse Warehouse { get; set; }
        public ItemSpace ItemSpace { get; set; }
        public Reck Reck { get; set; }

        #region Extra Properties

        public int WarehouseId { get; set; }

        #endregion

    }
}
