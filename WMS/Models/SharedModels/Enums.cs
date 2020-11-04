using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;


/*
 Summeries:
 Application default vaues or constant values are listed here.

 ---> For getting name of constant following structure can be used.
      1. DefaultValues.OrderStatus.Process.ToString() :Recommended
      2. nameof(DefaultValues.OrderStatus.Process); 
      3. Enum.GetName(typeof(DefaultValues), DefaultValues.OrderStatus.Process);

 ---> For getting index value of constant following structure can be used.
      1. (int)DefaultValues.OrderStatus.Process : Recommended
      2. DefaultValues.OrderStatus.Process.GetHashCode()
      3. Convert.ToInt32(DefaultValues.OrderStatus.Process);
 */

namespace WMS.Models.SharedModels
{
    public class StaticValues
    {
        public enum ApplicationStatus
        {
            Submitted = 1,                             // 1
            Cancelled,                                 // 2
            Deleted,                                   // 3
            [Display(Name = "Full Dispatch")]          //
            FullDispatch,                              // 4
            [Display(Name = "Partial Dispatch")]       //
            PartialDispatch,                           // 5
            [Display(Name = "Full Return")]            //
            FullReturn,                                // 6
            [Display(Name = "Partial Return")]         //
            PartialReturn,                             // 7
            VirtualStored,                             // 8
            StockRetrived,                             // 9
            Damage,                                    //10
            FreshProduct,                              //11
            ReturnProduct                              //12
        }

        public enum UserTypes
        {
            SuperAdmin = 1,                             // 1
            Admin,                                 // 2
            Employee,                                   // 3
            Customer                             // 4
        }
    }
}
