using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class RentalItemDto
    {
        public Guid TransactionId { get; set; }
        public Guid EquipmentId { get; set; }
        public string Model { get; set; }
        public string Sku { get; set; }
        public string Category { get; set; }
        public string EquipmentType { get; set; }
        public string EquipmentStatus { get; set; }
        public int Quantity { get; set; }
        public decimal RentalFee { get; set; }
        public decimal DepositFee { get; set; }
    }
}
