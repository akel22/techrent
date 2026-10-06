using System;
using System.Collections.Generic;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.RentalStaff
{
    public partial class ActiveTransactions : System.Web.UI.Page
    {
        // Expose active rentals for future integration with the page markup
        protected List<RentalTransactionDto> ActiveRentals { get; private set; } = new List<RentalTransactionDto>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    var svc = ServiceFactory.CreateRentalService();
                    ActiveRentals = new List<RentalTransactionDto>(svc.GetActiveRentals());
                    // Integration into the markup is intentionally deferred; ActiveRentals is available for future binding.
                }
                catch (Exception)
                {
                    // Swallowing exceptions here to keep the page available while the DB is optional in development.
                }
            }
        }
    }
}
