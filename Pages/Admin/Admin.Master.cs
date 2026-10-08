using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Techrent.Pages.Admin
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var actor = Techrent.ApplicationLayer.Services.AuthenticatedUserContext.Current;
            if (actor == null || !actor.IsAdmin)
            {
                throw new HttpException(403, "Access denied.");
            }

            string currentPage = VirtualPathUtility.GetFileName(Page.AppRelativeVirtualPath);
            SetNavigationState(DashboardLink, string.Equals(currentPage, "Dashboard.aspx", StringComparison.OrdinalIgnoreCase));
            SetNavigationState(TransactionsLink, string.Equals(currentPage, "Transactions.aspx", StringComparison.OrdinalIgnoreCase));
            SetNavigationState(AuditLogsLink, string.Equals(currentPage, "AuditLogs.aspx", StringComparison.OrdinalIgnoreCase));
            SetNavigationState(CustomersLink, string.Equals(currentPage, "Customers.aspx", StringComparison.OrdinalIgnoreCase));
            SetNavigationState(DamageChargeGuidelinesLink, string.Equals(currentPage, "DamageChargeGuidelines.aspx", StringComparison.OrdinalIgnoreCase));
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            var actor = Techrent.ApplicationLayer.Services.AuthenticatedUserContext.Current;
            if (actor != null)
            {
                try
                {
                    Techrent.ApplicationLayer.Services.ServiceFactory.CreateAuditService().Insert(
                        Techrent.ApplicationLayer.Services.AuditEventFactory.Success(
                            actor.UserId,
                            actor.ActorName,
                            Techrent.ApplicationLayer.Services.AuditEventFactory.AccountCategory,
                            "SignOut",
                            "User",
                            actor.UserId,
                            "A user signed out."));
                }
                catch
                {
                }
            }

            FormsAuthentication.SignOut();
            Session.Clear();
            Session.Abandon();
            Response.Redirect(ResolveUrl("~/signin"), false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private static void SetNavigationState(HyperLink link, bool isActive)
        {
            link.CssClass = isActive ? "nav-link active" : "nav-link";

            if (isActive)
            {
                link.Attributes["aria-current"] = "page";
            }
            else
            {
                link.Attributes.Remove("aria-current");
            }
        }
    }
}
