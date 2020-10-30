using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.SettingsVM
{
    public class AssignUserRoleVM
    {
        public Users Users { get; set; }
        public PersonalDetail PersonalDetail { get; set; }
        public UserType UserType { get; set; }
        public IQueryable<ListAuthorizations> ListAuthorization { get; set; }
    }
    
    
    public class ListAuthorizations
    {
        public AuthorizeType AuthorizeType { get; set; }
        public Authorizations Authorizations { get; set; }
    }
    
}
