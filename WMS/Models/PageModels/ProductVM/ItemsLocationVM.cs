using Microsoft.AspNetCore.Mvc.RazorPages.Infrastructure;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WMS.Models.Entities;

namespace WMS.Models.PageModels.ProductVM
{
    public class ItemsLocationVM
    {
        //public Products Products { get; set; }
        //public ProductItems ProductItems { get; set; }
        //public ItemSpace ItemSpace { get; set; }
        //public Warehouse Warehouse { get; set; }
        //public Reck Reck { get; set; }

        public string Warehouse { get; set; }
        public List<ItemWithDetail> ItemDetails { get; set; }

    }

    public class ItemWithDetail
    {
        public long ProductId { get; set; }
        public string ProductName { get; set; }
        public string ItemSerial { get; set; }
        public string WarehouseTitle { get; set; }
        public string ReckTitle { get; set; }
        public int ReckLevel { get; set; }

    } 
}
