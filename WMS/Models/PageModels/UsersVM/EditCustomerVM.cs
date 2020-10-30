using Microsoft.AspNetCore.Http;
using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.UsersVM
{
    public class EditCustomerVM
    {
        public Users Users { get; set; }
        public PersonalDetail PersonalDetail { get; set; }

        #region Extra Properties
        public IFormFile file { get; set; }
        #endregion

    }
}
