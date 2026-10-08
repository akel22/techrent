using System;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using Newtonsoft.Json;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.RentalStaff
{
    public partial class ActiveTransactions : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTransactions();
            }
        }

        protected void CompleteTransactionButton_Click(object sender, EventArgs e)
        {
            Guid transactionId;
            if (!Guid.TryParse(SelectedTransactionIdHidden.Value, out transactionId))
            {
                BindTransactions();
                return;
            }

            var additionalCharges = string.IsNullOrWhiteSpace(AdditionalChargesHidden.Value)
                ? new System.Collections.Generic.List<AdditionalChargeDto>()
                : JsonConvert.DeserializeObject<System.Collections.Generic.List<AdditionalChargeDto>>(AdditionalChargesHidden.Value);

            ServiceFactory.CreateRentalService().CompleteRental(transactionId, ReturnConditionNotesHidden.Value, additionalCharges);
            BindTransactions();
        }

        private void BindTransactions()
        {
            ActiveTransactionsRepeater.DataSource = ServiceFactory.CreateRentalService()
                .GetActiveRentals()
                .Select(CreateRow)
                .ToList();
            ActiveTransactionsRepeater.DataBind();
        }

        private static ActiveTransactionRow CreateRow(RentalTransactionDto transaction)
        {
            return new ActiveTransactionRow
            {
                TransactionId = transaction.TransactionId.ToString(),
                CustomerId = transaction.UserId.ToString(),
                CustomerName = (transaction.FirstName + " " + transaction.LastName).Trim(),
                DueDate = transaction.DueAt.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                Status = transaction.Status
            };
        }

        public sealed class ActiveTransactionRow
        {
            public string TransactionId { get; set; }
            public string CustomerId { get; set; }
            public string CustomerName { get; set; }
            public string DueDate { get; set; }
            public string Status { get; set; }
        }
    }
}
