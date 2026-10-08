using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class AuthenticatedUserDto
    {
        public Guid UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Role { get; set; }
        public string Email { get; set; }
        public byte[] PasswordHash { get; set; }
        public byte[] PasswordSalt { get; set; }
        public bool IsActive { get; set; }

        public string DisplayName
        {
            get { return (FirstName + " " + LastName).Trim(); }
        }
    }
}
