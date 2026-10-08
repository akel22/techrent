using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using Techrent.ApplicationLayer.Services;

namespace Techrent
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        protected void Application_PostAuthenticateRequest(object sender, EventArgs e)
        {
            var formsIdentity = Context.User == null ? null : Context.User.Identity as FormsIdentity;
            if (formsIdentity == null || formsIdentity.Ticket == null)
            {
                return;
            }

            Guid userId;
            string ticketRole;
            if (!AuthenticatedUserContext.TryReadTicket(formsIdentity.Ticket, out userId, out ticketRole))
            {
                FormsAuthentication.SignOut();
                Context.User = new System.Security.Principal.GenericPrincipal(formsIdentity, new string[0]);
                return;
            }

            var user = ServiceFactory.CreateAuthenticationService().GetCurrentUser(userId);
            if (user == null || !string.Equals(user.Role, ticketRole, StringComparison.OrdinalIgnoreCase))
            {
                FormsAuthentication.SignOut();
                Context.User = new System.Security.Principal.GenericPrincipal(formsIdentity, new string[0]);
                return;
            }

            Context.User = new System.Security.Principal.GenericPrincipal(formsIdentity, new[] { user.Role });
            AuthenticatedUserContext.SetCurrent(AuthenticatedUserContext.Create(user.UserId, user.FirstName, user.Role));
        }

        protected void Application_AuthorizeRequest(object sender, EventArgs e)
        {
            var requiredRole = RouteConfig.GetRequiredRole(Request.RequestContext.RouteData, Request.Path);
            if (string.IsNullOrWhiteSpace(requiredRole))
            {
                return;
            }

            if (Context.User == null || !Context.User.Identity.IsAuthenticated || !Context.User.IsInRole(requiredRole))
            {
                Response.Clear();
                Response.StatusCode = 403;
                Response.TrySkipIisCustomErrors = true;
                Response.Write("Access denied.");
                CompleteRequest();
                return;
            }
        }
    }
}