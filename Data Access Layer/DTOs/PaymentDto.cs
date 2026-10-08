using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class PaymentDto
    {
        public Guid PaymentId { get; set; }
        public Guid TransactionId { get; set; }
        public string PaymentType { get; set; }
        public decimal Amount { get; set; }
        public string PaymentMethod { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}