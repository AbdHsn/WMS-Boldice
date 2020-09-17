using Microsoft.AspNetCore.Http;
using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.ProductVM
{
    public class CreateProductVM
    {
        public Products Products { get; set; }

        #region Extra Properties
        public int InsertionQuantity { get; set; }
        #endregion
    }
}
