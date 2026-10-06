using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class EquipmentDto
    {
        public int EquipmentId { get; set; }
        public string Name { get; set; }
        public string Category { get; set; }
        public decimal RentalRate { get; set; }
        public int AvailableQuantity { get; set; }
    }
}
