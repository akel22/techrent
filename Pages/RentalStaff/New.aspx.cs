using System;
using System.Linq;
using Techrent.ApplicationLayer.Services;

namespace Techrent.Pages.RentalStaff
{
    public partial class New : System.Web.UI.Page
    {
        protected int CustomerCount { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var customers = ServiceFactory.CreateCustomerService().Search(null).Select(customer => new CustomerRow
                {
                    CustomerId = customer.CustomerId.ToString(),
                    FirstName = customer.FirstName,
                    LastName = customer.LastName,
                    Email = customer.Email,
                    MobileNumber = customer.MobileNumber,
                    Occupation = customer.Occupation,
                    OrganizationAddress = customer.OrganizationAddress,
                    AccountStatus = "Active",
                    ImageData = customer.IdentificationCard == null ? string.Empty : Convert.ToBase64String(customer.IdentificationCard)
                }).ToList();
                CustomerCount = customers.Count;
                CustomerRepeater.DataSource = customers;
                CustomerRepeater.DataBind();
            }
        }

        public sealed class CustomerRow
        {
            public string CustomerId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string FullName { get { return (FirstName + " " + LastName).Trim(); } }
            public string Email { get; set; }
            public string MobileNumber { get; set; }
            public string Occupation { get; set; }
            public string OrganizationAddress { get; set; }
            public string AccountStatus { get; set; }
            public string ImageData { get; set; }
            public string SearchText { get { return string.Join(" ", CustomerId, FullName, Email, MobileNumber); } }
        }
    }
}
