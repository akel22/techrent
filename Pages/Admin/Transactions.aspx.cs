using System;
using System.Collections.Generic;
using System.Web.UI;

namespace Techrent.Pages.Admin
{
    public partial class Transactions : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                //TransactionsRepeater is a Repeater control defined in the Transactions.aspx page. It is used to display a list of transactions.
                TransactionsRepeater.DataSource = GetSampleTransactions(); 
                TransactionsRepeater.DataBind();
            }
        }

        private static List<TransactionRow> GetSampleTransactions()
        {
            return new List<TransactionRow>
            {
                new TransactionRow { TransactionId = "TR-001-2026", CustomerId = "Customer-001", CreatedAt = "2026-01-01", Expiration = "2026-01-08", Status = "Ongoing", StatusClass = "status-ongoing" },
                new TransactionRow { TransactionId = "TR-002-2026", CustomerId = "Customer-002", CreatedAt = "2026-01-02", Expiration = "2026-01-09", Status = "Late", StatusClass = "status-late" },
                new TransactionRow { TransactionId = "TR-003-2026", CustomerId = "Customer-003", CreatedAt = "2026-01-03", Expiration = "2026-01-10", Status = "Overdue", StatusClass = "status-overdue" },
                new TransactionRow { TransactionId = "TR-004-2026", CustomerId = "Customer-004", CreatedAt = "2026-01-04", Expiration = "2026-01-11", Status = "Done", StatusClass = "status-done" },
                new TransactionRow { TransactionId = "TR-005-2026", CustomerId = "Customer-005", CreatedAt = "2026-01-05", Expiration = "2026-01-12", Status = "Ongoing", StatusClass = "status-ongoing" },
                new TransactionRow { TransactionId = "TR-006-2026", CustomerId = "Customer-006", CreatedAt = "2026-01-06", Expiration = "2026-01-13", Status = "Late", StatusClass = "status-late" },
                new TransactionRow { TransactionId = "TR-007-2026", CustomerId = "Customer-007", CreatedAt = "2026-01-07", Expiration = "2026-01-14", Status = "Overdue", StatusClass = "status-overdue" },
                new TransactionRow { TransactionId = "TR-008-2026", CustomerId = "Customer-008", CreatedAt = "2026-01-08", Expiration = "2026-01-15", Status = "Done", StatusClass = "status-done" },
                new TransactionRow { TransactionId = "TR-009-2026", CustomerId = "Customer-009", CreatedAt = "2026-01-09", Expiration = "2026-01-16", Status = "Ongoing", StatusClass = "status-ongoing" },
                new TransactionRow { TransactionId = "TR-010-2026", CustomerId = "Customer-010", CreatedAt = "2026-01-10", Expiration = "2026-01-17", Status = "Late", StatusClass = "status-late" },
                new TransactionRow { TransactionId = "TR-011-2026", CustomerId = "Customer-011", CreatedAt = "2026-01-11", Expiration = "2026-01-18", Status = "Overdue", StatusClass = "status-overdue" },
                new TransactionRow { TransactionId = "TR-012-2026", CustomerId = "Customer-012", CreatedAt = "2026-01-12", Expiration = "2026-01-19", Status = "Done", StatusClass = "status-done" },
                new TransactionRow { TransactionId = "TR-013-2026", CustomerId = "Customer-013", CreatedAt = "2026-01-13", Expiration = "2026-01-20", Status = "Ongoing", StatusClass = "status-ongoing" },
                new TransactionRow { TransactionId = "TR-014-2026", CustomerId = "Customer-014", CreatedAt = "2026-01-14", Expiration = "2026-01-21", Status = "Late", StatusClass = "status-late" },
                new TransactionRow { TransactionId = "TR-015-2026", CustomerId = "Customer-015", CreatedAt = "2026-01-15", Expiration = "2026-01-22", Status = "Overdue", StatusClass = "status-overdue" },
                new TransactionRow { TransactionId = "TR-016-2026", CustomerId = "Customer-016", CreatedAt = "2026-01-16", Expiration = "2026-01-23", Status = "Done", StatusClass = "status-done" }
            };
        }

        public sealed class TransactionRow
        {
            public string TransactionId { get; set; }
            public string CustomerId { get; set; }
            public string CreatedAt { get; set; }
            public string Expiration { get; set; }
            public string Status { get; set; }
            public string StatusClass { get; set; }
        }
    }
}
