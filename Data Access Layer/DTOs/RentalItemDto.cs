using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class RentalItemDto
    {
        public int RentalItemId { get; set; }
        public int EquipmentId { get; set; }
        public string EquipmentName { get; set; }
        public string SerialNumber { get; set; }
        public int Quantity { get; set; }
        public decimal Rate { get; set; }
    }
}
