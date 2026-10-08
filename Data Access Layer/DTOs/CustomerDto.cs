using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class CustomerDto
    {
        public Guid CustomerId { get; set; }
        public Guid UserId
        {
            get { return CustomerId; }
            set { CustomerId = value; }
        }
        public string Role { get { return "Customer"; } }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Occupation { get; set; }
        public string Email { get; set; }
        public string MobileNumber { get; set; }
        public string OrganizationAddress { get; set; }
        public byte[] IdentificationCard { get; set; }
        public DateTime? CreatedAt { get; set; }
    }
}
