using System;
using System.Collections.Generic;
using System.Web.UI;

namespace Techrent.Pages.Admin
{
    public partial class AuditLogs : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AuditLogsRepeater.DataSource = GetSampleAuditLogs();
                AuditLogsRepeater.DataBind();
            }
        }

        private static List<AuditLogRow> GetSampleAuditLogs()
        {
            return new List<AuditLogRow>
            {
                new AuditLogRow { LogId = "LOG-001", ActionBy = "Ezekiel_admin123", Role = "Admin", Category = "Inventory", Timestamp = "2026-09-17 10:00 AM", DateKey = "2026-09-17", Description = "Updated equipment availability from Available to In Repair.", Target = "Equipment EQ-1042 — Dell Latitude 5440", IpAddress = "192.168.1.24" },
                new AuditLogRow { LogId = "LOG-002", ActionBy = "John_staff456", Role = "Rental Staff", Category = "Rental", Timestamp = "2026-09-17 09:42 AM", DateKey = "2026-09-17", Description = "Marked a rental as returned and recorded the return condition.", Target = "Rental TR-2026-0184", IpAddress = "192.168.1.31" },
                new AuditLogRow { LogId = "LOG-003", ActionBy = "Ezekiel_admin123", Role = "Admin", Category = "Customer", Timestamp = "2026-09-16 04:18 PM", DateKey = "2026-09-16", Description = "Updated the customer's contact phone number.", Target = "Customer CU-0081", IpAddress = "192.168.1.24" },
                new AuditLogRow { LogId = "LOG-004", ActionBy = "Maria_staff210", Role = "Rental Staff", Category = "Rental", Timestamp = "2026-09-16 02:05 PM", DateKey = "2026-09-16", Description = "Created a rental transaction for a customer.", Target = "Rental TR-2026-0183", IpAddress = "192.168.1.38" },
                new AuditLogRow { LogId = "LOG-005", ActionBy = "Ezekiel_admin123", Role = "Admin", Category = "Account", Timestamp = "2026-09-15 11:27 AM", DateKey = "2026-09-15", Description = "Changed the role assigned to a staff account.", Target = "Account AC-0017 — Rental Staff", IpAddress = "192.168.1.24" },
                new AuditLogRow { LogId = "LOG-006", ActionBy = "John_staff456", Role = "Rental Staff", Category = "Inventory", Timestamp = "2026-09-15 09:13 AM", DateKey = "2026-09-15", Description = "Updated the condition notes for returned equipment.", Target = "Equipment EQ-1028 — HP ProBook 450", IpAddress = "192.168.1.31" },
                new AuditLogRow { LogId = "LOG-007", ActionBy = "Ezekiel_admin123", Role = "Admin", Category = "Inventory", Timestamp = "2026-09-14 03:36 PM", DateKey = "2026-09-14", Description = "Added a new equipment item to the inventory.", Target = "Equipment EQ-1042 — Dell Latitude 5440", IpAddress = "192.168.1.24" },
                new AuditLogRow { LogId = "LOG-008", ActionBy = "Maria_staff210", Role = "Rental Staff", Category = "Customer", Timestamp = "2026-09-14 01:50 PM", DateKey = "2026-09-14", Description = "Created a customer profile for a new rental.", Target = "Customer CU-0081", IpAddress = "192.168.1.38" },
                new AuditLogRow { LogId = "LOG-009", ActionBy = "Ezekiel_admin123", Role = "Admin", Category = "Rental", Timestamp = "2026-09-13 10:22 AM", DateKey = "2026-09-13", Description = "Cancelled a rental transaction at the customer's request.", Target = "Rental TR-2026-0179", IpAddress = "192.168.1.24" },
                new AuditLogRow { LogId = "LOG-010", ActionBy = "John_staff456", Role = "Rental Staff", Category = "Inventory", Timestamp = "2026-09-12 04:41 PM", DateKey = "2026-09-12", Description = "Recorded equipment as returned and available for rental.", Target = "Equipment EQ-1028 — HP ProBook 450", IpAddress = "192.168.1.31" },
                new AuditLogRow { LogId = "LOG-011", ActionBy = "Ezekiel_admin123", Role = "Admin", Category = "Account", Timestamp = "2026-09-11 02:14 PM", DateKey = "2026-09-11", Description = "Created an account for a new rental staff member.", Target = "Account AC-0021 — Rental Staff", IpAddress = "192.168.1.24" },
                new AuditLogRow { LogId = "LOG-012", ActionBy = "Maria_staff210", Role = "Rental Staff", Category = "Rental", Timestamp = "2026-09-10 08:56 AM", DateKey = "2026-09-10", Description = "Extended the rental expiration date after approval.", Target = "Rental TR-2026-0175", IpAddress = "192.168.1.38" }
            };
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
