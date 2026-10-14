using System;
using System.Linq;
using System.Web.UI;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.Admin
{
    public partial class AuditLogs : Page
    {
        private const int DefaultPageSize = 8;

        // Using server-side OnClick from the asp:Button; no dynamic hookup required.

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var page = 1;
                if (int.TryParse(Request.QueryString["p"], out var parsedPage) && parsedPage > 0)
                {
                    page = parsedPage;
                }

                LoadPage(page, DefaultPageSize, null, null, string.Empty, string.Empty);
            }
        }

        protected void ApplyAuditFilters_Click(object sender, EventArgs e)
        {
            DateTime? from = null;
            DateTime? to = null;

            var fromValue = Request.Form["auditDateFrom"];
            if (!string.IsNullOrWhiteSpace(fromValue) && DateTime.TryParse(fromValue, out var parsedFrom))
            {
                from = parsedFrom.Date;
            }

            var toValue = Request.Form["auditDateTo"];
            if (!string.IsNullOrWhiteSpace(toValue) && DateTime.TryParse(toValue, out var parsedTo))
            {
                to = parsedTo.Date;
            }

            var category = Request.Form["auditCategory"] ?? string.Empty;
            var query = AuditSearch?.Text?.Trim() ?? string.Empty;

            if (from.HasValue && to.HasValue && from.Value > to.Value)
            {
                auditFilterError.InnerText = "Date From must be on or before Date To.";
                auditFilterError.Visible = true;
                return;
            }

            auditFilterError.InnerText = string.Empty;
            auditFilterError.Visible = false;

            LoadPage(1, DefaultPageSize, from, to, category, query);
        }

        private void LoadPage(int pageNumber, int pageSize, DateTime? from, DateTime? to, string category, string query)
        {
            var service = ServiceFactory.CreateAuditService();
            var result = service.GetPage(
                pageNumber,
                pageSize,
                from,
                to,
                string.IsNullOrWhiteSpace(category) ? null : category,
                string.IsNullOrWhiteSpace(query) ? null : query);

            var rows = result.Records.Select(CreateAuditRow).ToList();
            AuditLogsRepeater.DataSource = rows;
            AuditLogsRepeater.DataBind();

            auditEmptyMessage.Visible = rows.Count == 0;
            auditPagination.InnerHtml = string.Empty;

            var pageCount = (int)Math.Ceiling((double)result.TotalRows / pageSize);
            if (pageCount <= 1)
            {
                return;
            }

            for (var p = 1; p <= pageCount; p++)
            {
                var activeClass = p == pageNumber ? " active" : string.Empty;
                auditPagination.InnerHtml += $"<li class=\"page-item{activeClass}\"><a class=\"page-link\" href=\"?p={p}\">{p}</a></li>";
            }
        }

        private static AuditLogRow CreateAuditRow(AuditRecordDto record)
        {
            return new AuditLogRow
            {
                LogId = record.LogId.ToString(),
                ActionBy = record.UserLogged,
                Role = record.UserRole ?? string.Empty,
                Category = string.IsNullOrWhiteSpace(record.Category) ? GetCategory(record.Description) : record.Category,
                Timestamp = record.LoggedAt.ToString("yyyy-MM-dd HH:mm:ss"),
                DateKey = record.LoggedAt.ToString("yyyy-MM-dd"),
                Description = record.Description ?? string.Empty,
                Target = string.Empty,
                IpAddress = string.Empty
            };
        }

        private static string GetCategory(string description)
        {
            if (string.IsNullOrWhiteSpace(description))
            {
                return "Account";
            }

            var value = description.ToLowerInvariant();
            if (value.Contains("rental") || value.Contains("transaction")) return "Rental";
            if (value.Contains("equipment") || value.Contains("inventory")) return "Inventory";
            if (value.Contains("customer")) return "Customer";
            return "Account";
        }

        public sealed class AuditLogRow
        {
            public string LogId { get; set; }
            public string ActionBy { get; set; }
            public string Role { get; set; }
            public string Category { get; set; }
            public string Timestamp { get; set; }
            public string DateKey { get; set; }
            public string Description { get; set; }
            public string Target { get; set; }
            public string IpAddress { get; set; }
        }
    }
}
