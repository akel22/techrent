using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Techrent.Pages.RentalStaff
{
    public partial class RentalStaff : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var actor = Techrent.ApplicationLayer.Services.AuthenticatedUserContext.Current;
            if (actor == null || !actor.IsRentalStaff)
            {
                throw new HttpException(403, "Access denied.");
            }
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Clear();
            Session.Abandon();
            Response.Redirect(ResolveUrl("~/signin"), false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}