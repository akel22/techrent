using System;
using System.Web;

namespace Techrent.Pages.RentalStaff
{
    public partial class SerialAssignment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string customerId = Request.QueryString["customerId"];
            string reviewUrl = GetRouteUrl("RentalStaffReview", null);
            if (!string.IsNullOrWhiteSpace(customerId))
            {
                reviewUrl += "?customerId=" + HttpUtility.UrlEncode(customerId);
            }

            Response.Redirect(reviewUrl, false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
