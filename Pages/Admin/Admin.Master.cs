using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Techrent.Pages.Admin
{
    public partial class AdminMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentPage = VirtualPathUtility.GetFileName(Page.AppRelativeVirtualPath);
            SetNavigationState(DashboardLink, string.Equals(currentPage, "Dashboard.aspx", StringComparison.OrdinalIgnoreCase));
            SetNavigationState(TransactionsLink, string.Equals(currentPage, "Transactions.aspx", StringComparison.OrdinalIgnoreCase));
            SetNavigationState(AuditLogsLink, string.Equals(currentPage, "AuditLogs.aspx", StringComparison.OrdinalIgnoreCase));
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
