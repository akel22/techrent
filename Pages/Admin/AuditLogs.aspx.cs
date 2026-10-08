using System;
using System.Linq;
using System.Web.UI;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.Admin
{
    public partial class AuditLogs : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AuditLogsRepeater.DataSource = ServiceFactory.CreateAuditService()
                    .GetRecent(25)
                    .Select(CreateAuditRow)
                    .ToList();
                AuditLogsRepeater.DataBind();
            }
        }

        private static AuditLogRow CreateAuditRow(AuditRecordDto record)
        {
            return new AuditLogRow
            {
                LogId = record.LogId.ToString(),
                ActionBy = record.UserLogged,
                Role = record.UserRole ?? string.Empty,
                Category = GetCategory(record.Description),
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
