using CoreWebApp.Data;
using CoreWebApp.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;

namespace CoreWebApp.Pages
{
    public class IndexModel : PageModel
    {
        private readonly ILogger<IndexModel> _logger;
        private readonly SchoolContext _context;
        public List<Student> Students {get;set;}
        public IndexModel(ILogger<IndexModel> logger, SchoolContext context)
        {
            _logger = logger;
            _context = context;
        }
        public void OnGet()
        {
            var t = _context.Students.ToListAsync();
            t.Wait();
            Students = t.Result;
        }
    }
}