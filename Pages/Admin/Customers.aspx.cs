using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.Admin
{
    public partial class Customers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCustomers();
            }
        }

        protected void DeleteCustomerButton_Click(object sender, EventArgs e)
        {
            Guid customerId;
            if (!Guid.TryParse(selectedCustomerId.Value, out customerId))
            {
                ShowCustomerDeleteMessage("The customer could not be identified.", false);
                return;
            }

            try
            {
                ServiceFactory.CreateCustomerService().DeleteCustomer(customerId);
                BindCustomers();
                selectedCustomerId.Value = string.Empty;
                ShowCustomerDeleteMessage("The customer record and its rental history were deleted successfully.", true);
            }
            catch (Exception ex)
            {
                ShowCustomerDeleteMessage(ex.Message, false);
            }
        }

        private void ShowCustomerDeleteMessage(string message, bool success)
        {
            CustomerDeleteMessage.Text = message;
            CustomerDeleteMessage.CssClass = success ? "alert alert-success d-block" : "alert alert-danger d-block";
            CustomerDeleteMessage.Visible = true;
        }

        private void BindCustomers()
        {
            var activeCustomerIds = new HashSet<Guid>(ServiceFactory.CreateRentalService()
                .GetActiveRentals()
                .Select(transaction => transaction.UserId));

            CustomersRepeater.DataSource = ServiceFactory.CreateCustomerService()
                .Search(null)
                .Select(customer => CreateCustomerRow(customer, activeCustomerIds.Contains(customer.UserId)))
                .ToList();
            CustomersRepeater.DataBind();
        }

        protected void SaveCustomerChanges_ServerClick(object sender, EventArgs e)
        {
            Guid userId;
            if (!Guid.TryParse(selectedCustomerId.Value, out userId))
            {
                return;
            }

            var customerService = ServiceFactory.CreateCustomerService();
            var existingCustomer = customerService.GetCustomerById(userId);
            customerService.UpdateCustomer(new CustomerDto
            {
                UserId = userId,
                FirstName = customerDetailFirstName.Value.Trim(),
                LastName = customerDetailLastName.Value.Trim(),
                Email = customerDetailEmail.Value.Trim(),
                MobileNumber = customerDetailMobile.Value.Trim(),
                Occupation = NormalizeOccupation(customerDetailOrganization.Value),
                OrganizationAddress = customerDetailAddress.Value.Trim(),
                IdentificationCard = existingCustomer == null ? null : existingCustomer.IdentificationCard
            });

            BindCustomers();
        }

        public string TransactionHistoryJson
        {
            get
            {
                var history = new List<CustomerTransaction>();
                history.AddRange(ServiceFactory.CreateRentalService()
                    .GetTransactionLog()
                    .Select(CreateCustomerTransaction));

                return new JavaScriptSerializer().Serialize(history);
            }
        }

        private static CustomerRow CreateCustomerRow(CustomerDto customer, bool hasActiveRental)
        {
            return new CustomerRow
            {
                CustomerId = customer.UserId.ToString(),
                FirstName = customer.FirstName,
                LastName = customer.LastName,
                Email = customer.Email,
                MobileNumber = customer.MobileNumber,
                TelephoneNumber = string.Empty,
                Organization = NormalizeOccupation(customer.Occupation),
                Address = customer.OrganizationAddress,
                AccountStatus = "Active",
                ImageData = customer.IdentificationCard == null ? string.Empty : Convert.ToBase64String(customer.IdentificationCard)
            };
        }

        private static CustomerTransaction CreateCustomerTransaction(RentalTransactionDto transaction)
        {
            return new CustomerTransaction
            {
                CustomerId = transaction.UserId.ToString(),
                TransactionId = transaction.TransactionId.ToString(),
                CreatedAt = transaction.CreatedAt.ToString("yyyy-MM-dd HH:mm:ss"),
                DueAt = transaction.DueAt.ToString("yyyy-MM-dd HH:mm:ss"),
                Status = transaction.Status
            };
        }

        public sealed class CustomerRow
        {
            public string CustomerId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string FullName { get { return (FirstName + " " + LastName).Trim(); } }
            public string Email { get; set; }
            public string MobileNumber { get; set; }
            public string TelephoneNumber { get; set; }
            public string Organization { get; set; }
            public string Address { get; set; }
            public string AccountStatus { get; set; }
            public string ImageData { get; set; }
        }

        private static string NormalizeOccupation(string value)
        {
            var allowedOccupations = new[] { "Student", "Employed", "Unemployed", "Other" };
            var occupation = allowedOccupations.FirstOrDefault(option =>
                string.Equals(option, value, StringComparison.OrdinalIgnoreCase));

            if (occupation != null)
            {
                return occupation;
            }

            if (string.Equals(value, "Employee", StringComparison.OrdinalIgnoreCase))
            {
                return "Employed";
            }

            return "Other";
        }

        public sealed class CustomerTransaction
        {
            public string CustomerId { get; set; }
            public string TransactionId { get; set; }
            public string CreatedAt { get; set; }
            public string DueAt { get; set; }
            public string Status { get; set; }
        }
    }
}
