using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.Admin
{
    public partial class Equipments : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindInventory();
            }
        }

        protected void DeleteEquipmentButton_Click(object sender, EventArgs e)
        {
            Guid equipmentId;
            if (!Guid.TryParse(inventoryDetailEquipmentId.Value, out equipmentId))
            {
                ShowEquipmentDeleteMessage("The equipment could not be identified.", false);
                return;
            }

            try
            {
                var deleted = ServiceFactory.CreateEquipmentService().Delete(equipmentId);
                if (!deleted)
                {
                    ShowEquipmentDeleteMessage("This equipment cannot be deleted while its stock is greater than zero.", false);
                    return;
                }

                BindInventory();
                inventoryDetailEquipmentId.Value = string.Empty;
                ShowEquipmentDeleteMessage("The equipment record was deleted successfully.", true);
            }
            catch (Exception ex)
            {
                ShowEquipmentDeleteMessage(ex.Message, false);
            }
        }

        private void ShowEquipmentDeleteMessage(string message, bool success)
        {
            EquipmentDeleteMessage.Text = message;
            EquipmentDeleteMessage.CssClass = success ? "alert alert-success d-block" : "alert alert-danger d-block";
            EquipmentDeleteMessage.Visible = true;
        }

        public int AvailableEquipmentCount { get; private set; }
        public int MaintenanceEquipmentCount { get; private set; }
        public int TotalInventoryCount { get; private set; }

        private void BindInventory()
        {
            var equipment = ServiceFactory.CreateEquipmentService().Search(null).ToList();
            AvailableEquipmentCount = equipment.Where(item => string.Equals(item.Status, "Available", StringComparison.OrdinalIgnoreCase)).Sum(item => item.Stock);
            MaintenanceEquipmentCount = equipment.Where(item => string.Equals(item.Status, "Maintenance", StringComparison.OrdinalIgnoreCase)).Sum(item => item.Stock);
            TotalInventoryCount = equipment.Sum(item => item.Stock);
            InventoryRepeater.DataSource = equipment.Select(CreateInventoryRow).ToList();
            InventoryRepeater.DataBind();
        }

        protected void SaveInventoryDetails_ServerClick(object sender, EventArgs e)
        {
            Guid equipmentId;
            int stock;
            decimal rentalRate;
            decimal deposit;
            if (!Guid.TryParse(inventoryDetailEquipmentId.Value, out equipmentId) ||
                !int.TryParse(inventoryDetailQuantity.Value, out stock) || stock < 0 ||
                !decimal.TryParse(inventoryDetailRentalRate.Value, NumberStyles.Number, CultureInfo.InvariantCulture, out rentalRate) || rentalRate < 0 ||
                !decimal.TryParse(inventoryDetailDeposit.Value, NumberStyles.Number, CultureInfo.InvariantCulture, out deposit) || deposit < 0 ||
                string.IsNullOrWhiteSpace(inventoryDetailStatus.Value) ||
                string.IsNullOrWhiteSpace(inventoryDetailType.Value))
            {
                ShowInventoryMessage("Enter valid status, type, quantity, rental, and deposit values.", false);
                return;
            }

            try
            {
                ServiceFactory.CreateEquipmentService().Update(new EquipmentDto
                {
                    EquipmentId = equipmentId,
                    Status = inventoryDetailStatus.Value,
                    Type = inventoryDetailType.Value,
                    Stock = stock,
                    BaseRentalFee = rentalRate,
                    SecurityDeposit = deposit
                });
                BindInventory();
                ShowInventoryMessage("Equipment changes saved successfully.", true);
            }
            catch (Exception ex)
            {
                ShowInventoryMessage(ex.Message, false);
            }
        }

        private void ShowInventoryMessage(string message, bool success)
        {
            inventoryDetailAlert.InnerText = message;
            inventoryDetailAlert.Attributes["class"] = success
                ? "alert alert-success"
                : "alert alert-danger";
        }

        private static InventoryRow CreateInventoryRow(EquipmentDto equipment)
        {
            return new InventoryRow
            {
                EquipmentId = equipment.EquipmentId.ToString(),
                SerialNumber = equipment.Sku,
                Model = equipment.Model,
                Category = equipment.Category,
                Type = equipment.Type,
                Status = equipment.Status,
                StatusClass = "status-" + (equipment.Status ?? string.Empty).ToLowerInvariant(),
                Quantity = equipment.Stock.ToString(),
                RentalRate = equipment.BaseRentalFee.ToString("0.00", CultureInfo.InvariantCulture),
                Deposit = equipment.SecurityDeposit.ToString("0.00", CultureInfo.InvariantCulture),
                DateAdded = equipment.CreatedAt.ToString("yyyy-MM-dd"),
                ImageData = equipment.Image == null ? string.Empty : Convert.ToBase64String(equipment.Image)
            };
        }

        public sealed class InventoryRow
        {
            public string EquipmentId { get; set; }
            public string SerialNumber { get; set; }
            public string Model { get; set; }
            public string Category { get; set; }
            public string Type { get; set; }
            public string Status { get; set; }
            public string StatusClass { get; set; }
            public string Quantity { get; set; }
            public string RentalRate { get; set; }
            public string Deposit { get; set; }
            public string DateAdded { get; set; }
            public string ImageData { get; set; }
        }
    }
}
