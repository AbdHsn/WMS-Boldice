using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.UsersVM
{
    public class ListCustomer
    {
        public Users User { get; set; }
        public UserType UserType { get; set; }
        public PersonalDetail PersonalDetail { get; set; }
    }
}
