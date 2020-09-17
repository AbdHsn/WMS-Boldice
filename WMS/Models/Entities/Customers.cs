using System;
using System.Collections.Generic;

namespace WMS.Models.Entities
{
    public partial class Customers
    {
        public Customers()
        {
            SalesReturn = new HashSet<SalesReturn>();
            SalesTransaction = new HashSet<SalesTransaction>();
        }

        public long Id { get; set; }
        public string Name { get; set; }
        public string Icno { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Telephone { get; set; }
        public int? CountryId { get; set; }
        public int? StateId { get; set; }
        public int? PostalCode { get; set; }
        public string Address { get; set; }
        public bool? IsActive { get; set; }

        public virtual ICollection<SalesReturn> SalesReturn { get; set; }
        public virtual ICollection<SalesTransaction> SalesTransaction { get; set; }
    }
}
