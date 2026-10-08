using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class EquipmentDto
    {
        public Guid EquipmentId { get; set; }
        public string Category { get; set; }
        public string Type { get; set; }
        public string Status { get; set; }
        public string Model { get; set; }
        public string Sku { get; set; }
        public byte[] Image { get; set; }
        public int Stock { get; set; }
        public decimal BaseRentalFee { get; set; }
        public decimal SecurityDeposit { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
