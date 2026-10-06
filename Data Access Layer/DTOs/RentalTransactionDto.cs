using System;
using System.Collections.Generic;

namespace Techrent.DataAccessLayer.DTOs
{
    public class RentalTransactionDto
    {
        public int RentalTransactionId { get; set; }
        public string TransactionCode { get; set; }
        public int CustomerId { get; set; }
        public string CustomerName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime DueDate { get; set; }
        public string Status { get; set; }
        public decimal RentalFee { get; set; }
        public decimal SecurityDeposit { get; set; }
        public List<RentalItemDto> Items { get; set; } = new List<RentalItemDto>();
    }
}
