using System;
using System.Collections.Generic;

namespace Techrent.DataAccessLayer.DTOs
{
    public class RentalTransactionDto
    {
        public Guid TransactionId { get; set; }
        public Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string MobileNumber { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime DueAt { get; set; }
        public string Status { get; set; }
        public bool IsArchived { get; set; }
        public byte[] Receipt { get; set; }
        public List<RentalItemDto> Items { get; set; } = new List<RentalItemDto>();
    }
}
