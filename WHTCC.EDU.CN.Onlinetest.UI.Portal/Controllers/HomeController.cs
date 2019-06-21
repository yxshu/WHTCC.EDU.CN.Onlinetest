using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WHTCC.EDU.CN.Onlinetest.Entity;

namespace WHTCC.EDU.CN.Onlinetest.UI.Portal.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            SuggestionKeyword keyword = new SuggestionKeyword();
            keyword.Keyword = "key";
           // keyword.SuggestionKeywordCreateTime = DateTime.Now;
            keyword.SuggestionKeywordNum = 100;
            DataEntityConn context = new DataEntityConn();
            context.SuggestionKeyword.Add(keyword);
            context.SaveChanges();
            System.Diagnostics.Debug.WriteLine(keyword.Keyword);
            ViewBag.Title =keyword.Keyword;
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}