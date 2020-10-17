using Microsoft.AspNetCore.Http;

using WMS.Models.Entities;

namespace WMS.Models.PageModels.ManufacturersVM
{
    public class EditManufacturerVM
    {
        public Manufacturer Manufacturer { get; set; }

        #region Extra Properties
        public IFormFile file { get; set; }
        #endregion

    }
}
