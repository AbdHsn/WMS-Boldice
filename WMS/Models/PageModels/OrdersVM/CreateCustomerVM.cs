﻿using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WMS.Models.PageModels.OrdersVM
{
    public class CreateCustomerVM
    {
        public Users Users { get; set; }
        public PersonalDetail PersonalDetail { get; set; }

        #region Extra Properties
        #endregion
    }
}
