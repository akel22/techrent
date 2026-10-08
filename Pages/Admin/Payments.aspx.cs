using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.Admin
{
    public partial class Payments : Page
    {
        private const string ViewStatePageKey = "Payments_CurrentPage";
        private int CurrentPage
        {
            get { return (int?)(ViewState[ViewStatePageKey]) ?? 1; }
            set { ViewState[ViewStatePageKey] = value; }
        }

        private const int PageSize = 10;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindPayments();
            }
        }

        private void BindPayments()
        {
            string search = PaymentSearch?.Text?.Trim();
            string sort = PaymentSort?.SelectedValue ?? "DESC";
            int total;
            var result = ServiceFactory.CreatePaymentService().GetActivityPaged(CurrentPage, PageSize, string.IsNullOrEmpty(search) ? null : search, sort);

            var items = result.Items ?? new List<PaymentDto>();
            total = result.TotalCount;

            PaymentActivityRepeater.DataSource = items.Select(CreatePaymentRow);
            PaymentActivityRepeater.DataBind();

            int totalPages = (int)Math.Ceiling(total / (double)PageSize);
            if (totalPages < 1) totalPages = 1;
            PageInfo.Text = $"Page {CurrentPage} of {totalPages} ({total} items)";
            PrevPage.Enabled = CurrentPage > 1;
            NextPage.Enabled = CurrentPage < totalPages;

            EmptyPanel.Visible = items == null || !items.Any();
        }

        protected void OnFilterChanged(object sender, EventArgs e)
        {
            CurrentPage = 1;
            BindPayments();
        }

        protected void OnSearchClicked(object sender, EventArgs e)
        {
            CurrentPage = 1;
            BindPayments();
        }

        protected void PrevPage_Click(object sender, EventArgs e)
        {
            if (CurrentPage > 1) CurrentPage--;
            BindPayments();
        }

        protected void NextPage_Click(object sender, EventArgs e)
        {
            CurrentPage++;
            BindPayments();
        }

        private static PaymentRow CreatePaymentRow(PaymentDto payment)
        {
            string paymentId = payment.PaymentId.ToString();
            string transactionId = payment.TransactionId.ToString();
            string paymentType = payment.PaymentType ?? string.Empty;
            string paymentMethod = payment.PaymentMethod ?? string.Empty;

            return new PaymentRow
            {
                PaymentId = paymentId,
                TransactionId = transactionId,
                PaymentType = paymentType,
                Amount = payment.Amount.ToString("C2", CultureInfo.GetCultureInfo("en-PH")),
                PaymentMethod = paymentMethod,
                CreatedAt = payment.CreatedAt.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture),
                CreatedAtSort = payment.CreatedAt.ToString("yyyyMMddHHmmssfffffff", CultureInfo.InvariantCulture),
                SearchText = string.Join(" ", new List<string> { paymentId, transactionId, paymentType, paymentMethod, payment.Amount.ToString(CultureInfo.InvariantCulture), payment.CreatedAt.ToString("yyyy-MM-dd HH:mm:ss", CultureInfo.InvariantCulture) })
            };
        }

        public sealed class PaymentRow
        {
            public string PaymentId { get; set; }
            public string TransactionId { get; set; }
            public string PaymentType { get; set; }
            public string Amount { get; set; }
            public string PaymentMethod { get; set; }
            public string CreatedAt { get; set; }
            public string CreatedAtSort { get; set; }
            public string SearchText { get; set; }
        }
    }
}
