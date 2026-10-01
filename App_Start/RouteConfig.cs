using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace Techrent
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.MapPageRoute("Default", "", "~/Pages/Signin.aspx");
            routes.MapPageRoute("Dashboard", "dashboard", "~/Pages/Admin/Dashboard.aspx");
            routes.MapPageRoute("Transactions", "transactions", "~/Pages/Admin/Transactions.aspx");
            routes.MapPageRoute("AuditLogs", "auditLogs", "~/Pages/Admin/AuditLogs.aspx");

            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings);
        }
    }
}
