using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using WMS.Models.Entities;

namespace WMS.Controllers
{
    public class WarehouseCapacityDefinationsController : Controller
    {
        private readonly WMSDBContext _context;

        public WarehouseCapacityDefinationsController(WMSDBContext context)
        {
            _context = context;
        }

        // GET: WarehouseCapacityDefinations
        public async Task<IActionResult> Index()
        {
            return View(await _context.WarehouseCapacityDefination.ToListAsync());
        }

        // GET: WarehouseCapacityDefinations/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var warehouseCapacityDefination = await _context.WarehouseCapacityDefination
                .FirstOrDefaultAsync(m => m.Id == id);
            if (warehouseCapacityDefination == null)
            {
                return NotFound();
            }

            return View(warehouseCapacityDefination);
        }

        // GET: WarehouseCapacityDefinations/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: WarehouseCapacityDefinations/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,WarehouseId,Row,Column,ReckQuantity,IsActive")] WarehouseCapacityDefination warehouseCapacityDefination)
        {
            if (ModelState.IsValid)
            {
                _context.Add(warehouseCapacityDefination);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(warehouseCapacityDefination);
        }

        // GET: WarehouseCapacityDefinations/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var warehouseCapacityDefination = await _context.WarehouseCapacityDefination.FindAsync(id);
            if (warehouseCapacityDefination == null)
            {
                return NotFound();
            }
            return View(warehouseCapacityDefination);
        }

        // POST: WarehouseCapacityDefinations/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,WarehouseId,Row,Column,ReckQuantity,IsActive")] WarehouseCapacityDefination warehouseCapacityDefination)
        {
            if (id != warehouseCapacityDefination.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(warehouseCapacityDefination);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!WarehouseCapacityDefinationExists(warehouseCapacityDefination.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(warehouseCapacityDefination);
        }

        // GET: WarehouseCapacityDefinations/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var warehouseCapacityDefination = await _context.WarehouseCapacityDefination
                .FirstOrDefaultAsync(m => m.Id == id);
            if (warehouseCapacityDefination == null)
            {
                return NotFound();
            }

            return View(warehouseCapacityDefination);
        }

        // POST: WarehouseCapacityDefinations/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var warehouseCapacityDefination = await _context.WarehouseCapacityDefination.FindAsync(id);
            _context.WarehouseCapacityDefination.Remove(warehouseCapacityDefination);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool WarehouseCapacityDefinationExists(int id)
        {
            return _context.WarehouseCapacityDefination.Any(e => e.Id == id);
        }
    }
}
