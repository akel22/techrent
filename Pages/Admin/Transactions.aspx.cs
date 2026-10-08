using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.Admin
{
    public partial class Transactions : Page
    {
        private const decimal SharedLateFeePerDay = 25.00m;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTransactions();
            }
        }

        protected void TransactionsRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (!string.Equals(e.CommandName, "Archive", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            Guid transactionId;
            if (!Guid.TryParse(Convert.ToString(e.CommandArgument, CultureInfo.InvariantCulture), out transactionId) ||
                !ServiceFactory.CreateRentalService().ArchiveRental(transactionId))
            {
                ArchiveMessage.Text = "Only completed transactions can be archived. The transaction list was not changed.";
                ArchiveMessage.Visible = true;
            }

            BindTransactions();
        }

        private void BindTransactions()
        {
            var rentalService = ServiceFactory.CreateRentalService();
            TransactionsRepeater.DataSource = rentalService.GetTransactionLog()
                .Select(transaction => rentalService.GetById(transaction.TransactionId))
                .Where(transaction => transaction != null)
                .Select(CreateTransactionRow);
            TransactionsRepeater.DataBind();
        }

        private static TransactionRow CreateTransactionRow(RentalTransactionDto rental)
        {
            TransactionRow transaction = new TransactionRow
            {
                TransactionId = rental.TransactionId.ToString(),
                ReceiptNumber = "RCPT-" + rental.TransactionId.ToString("N").Substring(0, 8).ToUpperInvariant(),
                CustomerId = rental.UserId.ToString(),
                CustomerName = (rental.FirstName + " " + rental.LastName).Trim(),
                 CustomerEmail = rental.Email,
                 CustomerMobile = rental.MobileNumber,
                CreatedAt = rental.CreatedAt.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                DueAt = rental.DueAt.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                RentalStartDate = rental.CreatedAt.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                ReturnDate = rental.DueAt.ToString("dd MMM yyyy", CultureInfo.InvariantCulture),
                Status = rental.Status,
                RentalFee = FormatCurrency(rental.Items.Sum(item => item.RentalFee * item.Quantity)),
                SecurityDeposit = FormatCurrency(rental.Items.Sum(item => item.DepositFee * item.Quantity)),
                 LateFeePerDay = SharedLateFeePerDay.ToString("C2", CultureInfo.GetCultureInfo("en-PH")),
                StatusClass = "status-" + rental.Status.ToLowerInvariant(),
                Equipment = rental.Items.Select((item, index) => new TransactionEquipment
                {
                     Sku = item.Sku,
                    Name = item.Model,
                    Rate = FormatCurrency(item.RentalFee),
                    Deposit = FormatCurrency(item.DepositFee)
                }).ToList(),
                PreRentalDetails = new List<PreRentalDetail>()
            };

            transaction.ActualReturnAt = string.Equals(rental.Status, "Done", StringComparison.OrdinalIgnoreCase)
                ? string.Empty
                : string.Empty;
            CalculateCharges(transaction);
            var payments = ServiceFactory.CreatePaymentService().GetByTransaction(rental.TransactionId).ToList();
            decimal persistedLateFee = payments
                .Where(payment => string.Equals(payment.PaymentType, "LateFee", StringComparison.OrdinalIgnoreCase))
                .Sum(payment => payment.Amount);
            decimal rentalFee = rental.Items.Sum(item => item.RentalFee * item.Quantity);
            decimal securityDeposit = rental.Items.Sum(item => item.DepositFee * item.Quantity);
            transaction.LateFee = FormatCurrency(persistedLateFee);
            transaction.Total = FormatCurrency(rentalFee + securityDeposit + persistedLateFee);
            transaction.PaidAmount = FormatCurrency(payments.Sum(payment => payment.Amount));
            decimal total = rentalFee + securityDeposit + persistedLateFee;
            transaction.Change = FormatCurrency(Math.Max(0m, payments.Sum(payment => payment.Amount) - total));
            return transaction;
        }

        private static string FormatCurrency(decimal amount)
        {
            return amount.ToString("C2", CultureInfo.GetCultureInfo("en-PH"));
        }

        private static string GetActualReturnAt(string dueAt, string status)
        {
            if (string.Equals(status, "Ongoing", StringComparison.OrdinalIgnoreCase))
            {
                return string.Empty;
            }

            DateTime dueDate = DateTime.ParseExact(dueAt, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
            int additionalDays = string.Equals(status, "Late", StringComparison.OrdinalIgnoreCase) ? 2 :
                string.Equals(status, "Overdue", StringComparison.OrdinalIgnoreCase) ? 5 : 0;
            return dueDate.AddDays(additionalDays).ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
        }

        private static void CalculateCharges(TransactionRow transaction)
        {
            CultureInfo pesoCulture = CultureInfo.GetCultureInfo("en-PH");
            decimal rentalFee = decimal.Parse(transaction.RentalFee, NumberStyles.Currency, pesoCulture);
            decimal securityDeposit = decimal.Parse(transaction.SecurityDeposit, NumberStyles.Currency, pesoCulture);
            decimal lateFee = 0m;

            if (!string.IsNullOrEmpty(transaction.ActualReturnAt))
            {
                DateTime dueDate = DateTime.ParseExact(transaction.DueAt, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
                DateTime actualReturnDate = DateTime.ParseExact(transaction.ActualReturnAt, "yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture);
                transaction.LateDays = Math.Max(0, (actualReturnDate.Date - dueDate.Date).Days);
                lateFee = transaction.LateDays * SharedLateFeePerDay;
            }

            transaction.LateFee = lateFee.ToString("C2", pesoCulture);
            transaction.Total = (rentalFee + securityDeposit + lateFee).ToString("C2", CultureInfo.GetCultureInfo("en-PH"));
        }

        public sealed class TransactionRow
        {
            public string TransactionId { get; set; }
            public string ReceiptNumber { get; set; }
            public string CustomerId { get; set; }
            public string CustomerName { get; set; }
            public string CustomerEmail { get; set; }
            public string CustomerMobile { get; set; }
            public string CreatedAt { get; set; }
            public string DueAt { get; set; }
            public string RentalStartDate { get; set; }
            public string ReturnDate { get; set; }
            public string Status { get; set; }
            public string RentalFee { get; set; }
            public string SecurityDeposit { get; set; }
            public string ActualReturnAt { get; set; }
            public int LateDays { get; set; }
            public string LateFeePerDay { get; set; }
            public string LateFee { get; set; }
            public string Total { get; set; }
            public string PaidAmount { get; set; }
            public string Change { get; set; }
            public string StatusClass { get; set; }
            public List<TransactionEquipment> Equipment { get; set; }
            public List<PreRentalDetail> PreRentalDetails { get; set; }
            [ScriptIgnore]
            public string DetailPayload
            {
                get { return new JavaScriptSerializer().Serialize(this); }
            }

            public TransactionRow()
            {
                ActualReturnAt = string.Empty;
            }
        }

        public sealed class TransactionEquipment
        {
            public string Sku { get; set; }
            public string Name { get; set; }
            public string Rate { get; set; }
            public string Deposit { get; set; }
        }

        public sealed class PreRentalDetail
        {
            public string EquipmentSerialNumber { get; set; }
            public string Issue { get; set; }
            public string RecordedBy { get; set; }
        }
    }
}
