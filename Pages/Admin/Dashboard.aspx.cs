using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI;
using Techrent.ApplicationLayer.Services;

namespace Techrent.Pages.Admin
{
    public partial class AdminDashboard : Page
    {
        protected string RevenueText { get; private set; }
        protected string ActiveRentalsText { get; private set; }
        protected string RevenueChartData { get; private set; }
        protected string RevenueChartLabels { get; private set; }
        protected string TransactionChartData { get; private set; }
        protected string EquipmentChartData { get; private set; }
        protected string SelectedPeriod { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindDashboard();
            }
        }

        private void BindDashboard()
        {
            SelectedPeriod = NormalizePeriod(Request.QueryString["period"]);
            var payments = ServiceFactory.CreatePaymentService().GetActivity().ToList();
            var transactions = ServiceFactory.CreateRentalService().GetTransactionLog().ToList();
            var equipment = ServiceFactory.CreateEquipmentService().Search(null).ToList();
            var serializer = new JavaScriptSerializer();
            DateTime today = DateTime.UtcNow.Date;
            DateTime periodStart = SelectedPeriod == "year" ? new DateTime(today.Year, 1, 1) : today.AddDays(1 - int.Parse(SelectedPeriod));
            DateTime periodEnd = today.AddDays(1);
            var periodPayments = payments.Where(payment => payment.CreatedAt >= periodStart && payment.CreatedAt < periodEnd).ToList();

            RevenueText = periodPayments.Sum(payment => payment.Amount).ToString("C2", System.Globalization.CultureInfo.GetCultureInfo("en-PH"));
            ActiveRentalsText = ServiceFactory.CreateRentalService().GetActiveRentals().Count().ToString();

            BuildRevenueChart(periodPayments, periodStart, periodEnd, serializer);
            int ongoingTransactions = transactions.Count(transaction => string.Equals(transaction.Status, "Ongoing", StringComparison.OrdinalIgnoreCase));
            int completedTransactions = transactions.Count(transaction => string.Equals(transaction.Status, "Done", StringComparison.OrdinalIgnoreCase));
            int lateTransactions = transactions.Count(transaction => string.Equals(transaction.Status, "Late", StringComparison.OrdinalIgnoreCase));
            int overdueTransactions = transactions.Count(transaction => string.Equals(transaction.Status, "Overdue", StringComparison.OrdinalIgnoreCase));
            TransactionChartData = serializer.Serialize(new[]
            {
                ongoingTransactions,
                completedTransactions,
                lateTransactions,
                overdueTransactions
            });
            EquipmentChartData = serializer.Serialize(new[]
            {
                equipment.Where(item => string.Equals(item.Status, "Available", StringComparison.OrdinalIgnoreCase)).Sum(item => item.Stock),
                equipment.Where(item => string.Equals(item.Status, "Maintenance", StringComparison.OrdinalIgnoreCase)).Sum(item => item.Stock)
            });
        }

        private void BuildRevenueChart(IEnumerable<Techrent.DataAccessLayer.DTOs.PaymentDto> payments, DateTime periodStart, DateTime periodEnd, JavaScriptSerializer serializer)
        {
            int bucketCount = SelectedPeriod == "year" ? 12 : SelectedPeriod == "60" ? 8 : 4;
            double totalDays = (periodEnd - periodStart).TotalDays;
            double bucketDays = SelectedPeriod == "year" ? 0 : totalDays / bucketCount;
            var labels = new string[bucketCount];
            var values = new decimal[bucketCount];

            for (int index = 0; index < bucketCount; index++)
            {
                DateTime bucketStart = SelectedPeriod == "year"
                    ? periodStart.AddMonths(index)
                    : periodStart.AddDays(Math.Floor((bucketCount - index - 1) * bucketDays));
                DateTime bucketEnd = SelectedPeriod == "year"
                    ? bucketStart.AddMonths(1)
                    : index == 0 ? periodEnd : periodStart.AddDays(Math.Floor((bucketCount - index) * bucketDays));

                labels[index] = SelectedPeriod == "year"
                    ? bucketStart.ToString("MMM", System.Globalization.CultureInfo.InvariantCulture)
                    : "Week " + (index + 1);
                values[index] = payments.Where(payment => payment.CreatedAt >= bucketStart && payment.CreatedAt < bucketEnd).Sum(payment => payment.Amount);
            }

            RevenueChartLabels = serializer.Serialize(labels);
            RevenueChartData = serializer.Serialize(values);
        }

        private static string NormalizePeriod(string period)
        {
            return string.Equals(period, "60", StringComparison.OrdinalIgnoreCase) || string.Equals(period, "year", StringComparison.OrdinalIgnoreCase)
                ? period.ToLowerInvariant()
                : "30";
        }
    }
}
