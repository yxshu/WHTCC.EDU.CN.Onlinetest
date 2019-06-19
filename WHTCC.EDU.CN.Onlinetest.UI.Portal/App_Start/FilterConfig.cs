using System.Web;
using System.Web.Mvc;

namespace WHTCC.EDU.CN.Onlinetest.UI.Portal
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
        }
    }
}
