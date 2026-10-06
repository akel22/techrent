using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class CustomerDto
    {
        public int CustomerId { get; set; }
        public string CustomerCode { get; set; }
        public string FullName { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public DateTime? CreatedAt { get; set; }
    }
}
