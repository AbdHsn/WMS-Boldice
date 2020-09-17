using WMS.CommonBusinessFunctions.BusinessModels;
using WMS.Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;

namespace WMS.CommonBusinessFunctions
{
    public class CommonBusinessLogics
    {
        private readonly WMSDBContext _context;
        public CommonBusinessLogics(WMSDBContext context)
        {
            _context = context;
        }

        public void CreateStockTrace(CreateStockTraceBM model)
        {

            var isStockTraceExist = _context.StockTrace.Where(st => st.ProductId == model.ProductId).OrderByDescending(st => st.CreatedDate).FirstOrDefault();

            var openningQty = isStockTraceExist != null ? isStockTraceExist.ClosingQuantity : 0;
            var currentQty = isStockTraceExist != null ? isStockTraceExist.CurrentQuantity + model.NewQuantity : model.NewQuantity;

            var createNewStockTrace = new StockTrace()
            {
                ProductId = model.ProductId,
                OpeningQuantity = openningQty,
                CurrentQuantity = currentQty,
                ClosingQuantity = currentQty,
                ReferenceId = model.ReferenecId,
                TableReference = model.TableReference,
                CreatedDate = DateTime.UtcNow,
                Note = model.Note
            };
            _context.StockTrace.Add(createNewStockTrace);
            _context.SaveChanges();
        }

        public string GenerateNumberWithPrefix(string prefix, string number)
        {
            return prefix + DateTime.Now.Year + DateTime.Now.Month.ToString("00") + number.PadLeft(10, '0');
        }

        public string StockIncreaseOrDecrease(string prefix, string number)
        {
            return prefix + DateTime.Now.Year + DateTime.Now.Month.ToString("00") + number.PadLeft(10, '0');
        }
    }
}
