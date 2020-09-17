using Microsoft.AspNetCore.Http;
using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.CompaniesVM
{
    public class CompanyDetails
    {
        public Company Company { get; set; }
        public IFormFile ActualCompanyLogo { get; set; }
        public bool ImageClearActive { get; set; }
    }
}
