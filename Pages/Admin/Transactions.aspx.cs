using System;
using System.Collections.Generic;
using System.Web.Script.Serialization;
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
                CreateTransaction("TR-001-2026", "Customer-001", "2026-01-01 12:00:00", "2026-01-08 12:00:00", "Ongoing", "status-ongoing"),
                CreateTransaction("TR-002-2026", "Customer-002", "2026-01-02 12:00:00", "2026-01-09 12:00:00", "Late", "status-late"),
                CreateTransaction("TR-003-2026", "Customer-003", "2026-01-03 12:00:00", "2026-01-10 12:00:00", "Overdue", "status-overdue"),
                CreateTransaction("TR-004-2026", "Customer-004", "2026-01-04 12:00:00", "2026-01-11 12:00:00", "Done", "status-done"),
                CreateTransaction("TR-005-2026", "Customer-005", "2026-01-05 12:00:00", "2026-01-12 12:00:00", "Ongoing", "status-ongoing"),
                CreateTransaction("TR-006-2026", "Customer-006", "2026-01-06 12:00:00", "2026-01-13 12:00:00", "Late", "status-late"),
                CreateTransaction("TR-007-2026", "Customer-007", "2026-01-07 12:00:00", "2026-01-14 12:00:00", "Overdue", "status-overdue"),
                CreateTransaction("TR-008-2026", "Customer-008", "2026-01-08 12:00:00", "2026-01-15 12:00:00", "Done", "status-done"),
                CreateTransaction("TR-009-2026", "Customer-009", "2026-01-09 12:00:00", "2026-01-16 12:00:00", "Ongoing", "status-ongoing"),
                CreateTransaction("TR-010-2026", "Customer-010", "2026-01-10 12:00:00", "2026-01-17 12:00:00", "Late", "status-late"),
                CreateTransaction("TR-011-2026", "Customer-011", "2026-01-11 12:00:00", "2026-01-18 12:00:00", "Overdue", "status-overdue"),
                CreateTransaction("TR-012-2026", "Customer-012", "2026-01-12 12:00:00", "2026-01-19 12:00:00", "Done", "status-done"),
                CreateTransaction("TR-013-2026", "Customer-013", "2026-01-13 12:00:00", "2026-01-20 12:00:00", "Ongoing", "status-ongoing"),
                CreateTransaction("TR-014-2026", "Customer-014", "2026-01-14 12:00:00", "2026-01-21 12:00:00", "Late", "status-late"),
                CreateTransaction("TR-015-2026", "Customer-015", "2026-01-15 12:00:00", "2026-01-22 12:00:00", "Overdue", "status-overdue"),
                CreateTransaction("TR-016-2026", "Customer-016", "2026-01-16 12:00:00", "2026-01-23 12:00:00", "Done", "status-done")
            };
        }

        private static TransactionRow CreateTransaction(string transactionId, string customerId, string createdAt, string dueAt, string status, string statusClass)
        {
            return new TransactionRow
            {
                TransactionId = transactionId,
                ReceiptNumber = "RCPT-" + transactionId.Substring(3),
                CustomerId = customerId,
                CreatedAt = createdAt,
                DueAt = dueAt,
                Status = status,
                RentalFee = "$315.00",
                SecurityDeposit = "$75.00",
                Total = "$390.00",
                StatusClass = statusClass,
                Equipment = new List<TransactionEquipment>
                {
                    new TransactionEquipment { SerialNumber = "000-123-YS6", Name = "Lenovo ThinkPad T14", Rate = "$30.00 / day", Deposit = "$50.00" },
                    new TransactionEquipment { SerialNumber = "000-123-YS7", Name = "Dell 24-inch Monitor", Rate = "$15.00 / day", Deposit = "$25.00" }
                },
                PreRentalDetails = new List<PreRentalDetail>
                {
                    new PreRentalDetail { EquipmentSerialNumber = "000-123-YS6", Issue = "No visible damage", RecordedBy = "Audit log - Staff-001" },
                    new PreRentalDetail { EquipmentSerialNumber = "000-123-YS7", Issue = "Minor scratches on the stand", RecordedBy = "Audit log - Staff-001" }
                }
            };
        }

        public sealed class TransactionRow
        {
            public string TransactionId { get; set; }
            public string ReceiptNumber { get; set; }
            public string CustomerId { get; set; }
            public string CreatedAt { get; set; }
            public string DueAt { get; set; }
            public string Status { get; set; }
            public string RentalFee { get; set; }
            public string SecurityDeposit { get; set; }
            public string Total { get; set; }
            public string StatusClass { get; set; }
            public List<TransactionEquipment> Equipment { get; set; }
            public List<PreRentalDetail> PreRentalDetails { get; set; }
            [ScriptIgnore]
            public string DetailPayload
            {
                get { return new JavaScriptSerializer().Serialize(this); }
            }
        }

        public sealed class TransactionEquipment
        {
            public string SerialNumber { get; set; }
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
