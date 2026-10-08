using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace Techrent
{
    public static class RouteConfig
    {
        public const string RequiredRoleKey = "RequiredRole";

        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.MapPageRoute("Signin", "signin", "~/Pages/Signin.aspx");

            MapProtectedPageRoute(routes, "RentalStaff", "", "~/Pages/RentalStaff/Default.aspx", "RentalStaff");
            MapProtectedPageRoute(routes, "RentalStaffActiveTransactions", "rental-staff/active-transactions", "~/Pages/RentalStaff/ActiveTransactions.aspx", "RentalStaff");
            MapProtectedPageRoute(routes, "RentalStaffNew", "rental-staff/new", "~/Pages/RentalStaff/New.aspx", "RentalStaff");
            MapProtectedPageRoute(routes, "RentalStaffRegisterCustomer", "rental-staff/register-customer", "~/Pages/RentalStaff/RegisterCustomer.aspx", "RentalStaff");
            MapProtectedPageRoute(routes, "RentalStaffEquipment", "rental-staff/equipment", "~/Pages/RentalStaff/Equipment.aspx", "RentalStaff");
            MapProtectedPageRoute(routes, "RentalStaffReview", "rental-staff/review", "~/Pages/RentalStaff/Review.aspx", "RentalStaff");

            MapProtectedPageRoute(routes, "Dashboard", "dashboard", "~/Pages/Admin/Dashboard.aspx", "Admin");
            MapProtectedPageRoute(routes, "Transactions", "transactions", "~/Pages/Admin/Transactions.aspx", "Admin");
            MapProtectedPageRoute(routes, "Payments", "payments", "~/Pages/Admin/Payments.aspx", "Admin");
            MapProtectedPageRoute(routes, "AuditLogs", "audit-logs", "~/Pages/Admin/AuditLogs.aspx", "Admin");
            MapProtectedPageRoute(routes, "Customers", "customers", "~/Pages/Admin/Customers.aspx", "Admin");
            MapProtectedPageRoute(routes, "Equipments", "equipments", "~/Pages/Admin/Equipments.aspx", "Admin");
            MapProtectedPageRoute(routes, "AdminInsertEquipment", "equipments/insert", "~/Pages/Admin/InsertEquipment.aspx", "Admin");
            MapProtectedPageRoute(routes, "DamageChargeGuidelines", "damage-charge-guidelines", "~/Pages/Admin/Guidelines.aspx", "Admin");

            var settings = new FriendlyUrlSettings
            {
                AutoRedirectMode = RedirectMode.Permanent
            };
            routes.EnableFriendlyUrls(settings);
        }

        public static string GetRequiredRole(RouteData routeData, string path)
        {
            if (routeData != null && routeData.Values[RequiredRoleKey] is string routeRole)
            {
                return routeRole;
            }

            var normalizedPath = (path ?? string.Empty).TrimEnd('/');
            if (normalizedPath.IndexOf("/Pages/Admin/", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return "Admin";
            }

            if (normalizedPath.IndexOf("/Pages/RentalStaff/", StringComparison.OrdinalIgnoreCase) >= 0)
            {
                return "RentalStaff";
            }

            return null;
        }

        private static void MapProtectedPageRoute(RouteCollection routes, string routeName, string routeUrl, string physicalFile, string requiredRole)
        {
            routes.MapPageRoute(
                routeName,
                routeUrl,
                physicalFile,
                false,
                new RouteValueDictionary
                {
                    { RequiredRoleKey, requiredRole }
                },
                new RouteValueDictionary(),
                new RouteValueDictionary());
        }
    }
}
