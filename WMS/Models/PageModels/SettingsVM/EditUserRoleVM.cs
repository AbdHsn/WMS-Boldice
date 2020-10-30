using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.SettingsVM
{
    public class EditUserRoleVM
    {
        public Users Users { get; set; }
        public PersonalDetail PersonalDetail { get; set; }
        public UserType UserType { get; set; }
        public IQueryable<EditListAuthorizations> ListAuthorization { get; set; }
        public List<int> AuthorizationTypeId { get; set; }
    }
    
    
    public class EditListAuthorizations
    {
        public AuthorizeType AuthorizeType { get; set; }
        public Authorizations Authorizations { get; set; }
    }
    
}
