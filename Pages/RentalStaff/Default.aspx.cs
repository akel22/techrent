using System;

namespace Techrent.Pages.RentalStaff
{
    public partial class Default : System.Web.UI.Page
    {
        protected string RentalStaffFirstName { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            var actor = Techrent.ApplicationLayer.Services.AuthenticatedUserContext.Current;
            RentalStaffFirstName = actor == null || string.IsNullOrWhiteSpace(actor.ActorName)
                ? "Rental Staff"
                : actor.ActorName;
        }
    }
}
