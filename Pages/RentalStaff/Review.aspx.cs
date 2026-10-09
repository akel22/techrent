using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.RentalStaff
{
    public partial class Review : System.Web.UI.Page
    {
        protected string CustomerName { get; private set; }
        protected string CustomerId { get; private set; }
        protected string CustomerEmail { get; private set; }
        protected string CustomerMobile { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            CustomerName = "Customer not selected";
            CustomerId = string.Empty;
            CustomerEmail = string.Empty;
            CustomerMobile = string.Empty;

            Guid customerId;
            if (Guid.TryParse(Request.QueryString["customerId"], out customerId))
            {
                var customer = ServiceFactory.CreateCustomerService().GetCustomerById(customerId);
                if (customer != null)
                {
                    CustomerName = (customer.FirstName + " " + customer.LastName).Trim();
                    CustomerId = customer.UserId.ToString();
                    CustomerEmail = customer.Email;
                    CustomerMobile = customer.MobileNumber;
                }
            }
        }

        protected void SaveRentalButton_ServerClick(object sender, EventArgs e)
        {
            Guid customerId;
            DateTime startDate;
            DateTime returnDate;
            decimal amountPaid;
            if (!Guid.TryParse(Request.QueryString["customerId"], out customerId) ||
                !DateTime.TryParseExact(rentalStartDateValue.Value, "yyyy-MM-dd'T'HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out startDate) ||
                !DateTime.TryParseExact(rentalReturnDateValue.Value, "yyyy-MM-dd'T'HH:mm", CultureInfo.InvariantCulture, DateTimeStyles.None, out returnDate) ||
                !decimal.TryParse(paymentAmountValue.Value, NumberStyles.Number, CultureInfo.InvariantCulture, out amountPaid))
            {
                ShowSaveMessage("Select a customer, rental start and return date-time, and valid payment amount before saving.", false);
                return;
            }

            if (startDate < DateTime.Now)
            {
                ShowSaveMessage("The rental start date and time cannot be in the past.", false);
                return;
            }

            if (returnDate <= startDate)
            {
                ShowSaveMessage("The return date and time must be after the rental start date and time.", false);
                return;
            }

            var billableHours = (int)Math.Ceiling((returnDate - startDate).TotalHours);

            Dictionary<string, SelectedEquipment> selected;
            try
            {
                selected = new JavaScriptSerializer().Deserialize<Dictionary<string, SelectedEquipment>>(selectedEquipmentJson.Value);
            }
            catch
            {
                selected = null;
            }

            if (selected == null || selected.Count == 0)
            {
                ShowSaveMessage("Add at least one available equipment item before saving.", false);
                return;
            }

            var items = new List<RentalItemDto>();
            decimal total = 0m;
            foreach (var entry in selected)
            {
                Guid equipmentId;
                if (!Guid.TryParse(entry.Key, out equipmentId) || entry.Value == null || entry.Value.Quantity < 1)
                {
                    ShowSaveMessage("The selected equipment data is invalid.", false);
                    return;
                }

                var equipment = ServiceFactory.CreateEquipmentService().GetById(equipmentId);
                if (equipment == null || !string.Equals(equipment.Status, "Available", StringComparison.OrdinalIgnoreCase) || equipment.Stock < entry.Value.Quantity)
                {
                    ShowSaveMessage("One or more selected equipment items are no longer available.", false);
                    return;
                }

                items.Add(new RentalItemDto
                {
                    EquipmentId = equipmentId,
                    Quantity = entry.Value.Quantity,
                    RentalFee = equipment.BaseRentalFee * billableHours,
                    DepositFee = equipment.SecurityDeposit
                });
            }

            total = items.Sum(item => item.RentalFee * item.Quantity + item.DepositFee * item.Quantity);
            if (amountPaid < total)
            {
                ShowSaveMessage("The payment amount is less than the rental total.", false);
                return;
            }

            try
            {
                var transactionId = ServiceFactory.CreateRentalService().CreateRental(
                    new RentalTransactionDto { UserId = customerId, StartAt = startDate, DueAt = returnDate, BillableHours = billableHours, Items = items },
                    new PaymentDto { Amount = amountPaid, PaymentType = "RentalFee", PaymentMethod = "Cash" });
                ShowSaveMessage("Rental " + transactionId.ToString() + " was saved successfully.", true);
                saveRentalButton.Disabled = true;
                ClientScript.RegisterStartupScript(GetType(), "ReopenRentalReceiptModal", "window.addEventListener('load', function () { if (window.showRentalReceiptModal) { window.showRentalReceiptModal(); } });", true);
            }
            catch (Exception ex)
            {
                ShowSaveMessage(ex.Message, false);
            }
        }

        private void ShowSaveMessage(string message, bool success)
        {
            saveRentalMessage.InnerText = message;
            saveRentalMessage.Attributes["class"] = success ? "alert alert-success mt-3 mb-0" : "alert alert-danger mt-3 mb-0";
            saveRentalMessage.Visible = true;
        }

        private sealed class SelectedEquipment
        {
            public int Quantity { get; set; }
        }
    }
}
