using System;
using System.Collections.Generic;
using System.Web.UI;

namespace Techrent.Pages.Admin
{
    public partial class Equipments : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InventoryRepeater.DataSource = GetSampleInventory();
                InventoryRepeater.DataBind();
            }
        }

        private static List<InventoryRow> GetSampleInventory()
        {
            return new List<InventoryRow>
            {
                new InventoryRow { EquipmentId = "EQUIPMENT-001", SerialNumber = "SN-LPT-001", Model = "Samsung-LPT-001", Category = "Laptop", Type = "Obsolete", Status = "Available", StatusClass = "status-available", Quantity = "50", RentalRate = "₱25 / hr", Deposit = "₱10 / hr", DateAdded = "2026-09-10" },
                new InventoryRow { EquipmentId = "EQUIPMENT-002", SerialNumber = "SN-LPT-002", Model = "Dell Latitude 5440", Category = "Laptop", Type = "Standard", Status = "Available", StatusClass = "status-available", Quantity = "8", RentalRate = "₱35 / hr", Deposit = "₱15 / hr", DateAdded = "2026-09-11" },
                new InventoryRow { EquipmentId = "EQUIPMENT-003", SerialNumber = "SN-MON-001", Model = "Dell P2422H", Category = "Monitor", Type = "Standard", Status = "Available", StatusClass = "status-available", Quantity = "12", RentalRate = "₱18 / hr", Deposit = "₱8 / hr", DateAdded = "2026-09-12" },
                new InventoryRow { EquipmentId = "EQUIPMENT-004", SerialNumber = "SN-PRJ-001", Model = "Epson EB-X06", Category = "Projector", Type = "Standard", Status = "In Maintenance", StatusClass = "status-maintenance", Quantity = "2", RentalRate = "₱45 / hr", Deposit = "₱20 / hr", DateAdded = "2026-09-13" },
                new InventoryRow { EquipmentId = "EQUIPMENT-005", SerialNumber = "SN-TAB-001", Model = "iPad 10th Generation", Category = "Tablet", Type = "Standard", Status = "Available", StatusClass = "status-available", Quantity = "10", RentalRate = "₱28 / hr", Deposit = "₱12 / hr", DateAdded = "2026-09-14" },
                new InventoryRow { EquipmentId = "EQUIPMENT-006", SerialNumber = "SN-CAM-001", Model = "Canon EOS 90D", Category = "Camera", Type = "Professional", Status = "Rented", StatusClass = "status-rented", Quantity = "3", RentalRate = "₱60 / hr", Deposit = "₱30 / hr", DateAdded = "2026-09-15" },
                new InventoryRow { EquipmentId = "EQUIPMENT-007", SerialNumber = "SN-LPT-003", Model = "HP ProBook 450", Category = "Laptop", Type = "Standard", Status = "Available", StatusClass = "status-available", Quantity = "6", RentalRate = "₱30 / hr", Deposit = "₱12 / hr", DateAdded = "2026-09-16" },
                new InventoryRow { EquipmentId = "EQUIPMENT-008", SerialNumber = "SN-MIC-001", Model = "Shure SM58", Category = "Audio", Type = "Professional", Status = "Available", StatusClass = "status-available", Quantity = "4", RentalRate = "₱20 / hr", Deposit = "₱10 / hr", DateAdded = "2026-09-17" },
                new InventoryRow { EquipmentId = "EQUIPMENT-009", SerialNumber = "SN-NET-001", Model = "TP-Link Archer AX55", Category = "Networking", Type = "Standard", Status = "Available", StatusClass = "status-available", Quantity = "5", RentalRate = "₱15 / hr", Deposit = "₱7 / hr", DateAdded = "2026-09-18" },
                new InventoryRow { EquipmentId = "EQUIPMENT-010", SerialNumber = "SN-PRN-001", Model = "Brother HL-L2375DW", Category = "Printer", Type = "Standard", Status = "In Maintenance", StatusClass = "status-maintenance", Quantity = "2", RentalRate = "₱22 / hr", Deposit = "₱10 / hr", DateAdded = "2026-09-19" },
                new InventoryRow { EquipmentId = "EQUIPMENT-011", SerialNumber = "SN-LPT-004", Model = "Lenovo ThinkPad E14", Category = "Laptop", Type = "Standard", Status = "Available", StatusClass = "status-available", Quantity = "7", RentalRate = "₱32 / hr", Deposit = "₱14 / hr", DateAdded = "2026-09-20" },
                new InventoryRow { EquipmentId = "EQUIPMENT-012", SerialNumber = "SN-TAB-002", Model = "Samsung Galaxy Tab S9", Category = "Tablet", Type = "Professional", Status = "Available", StatusClass = "status-available", Quantity = "5", RentalRate = "₱30 / hr", Deposit = "₱14 / hr", DateAdded = "2026-09-21" }
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
        }
    }
}
