using System;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class AuthenticatedUserRegistrationService
    {
        private readonly IAuthenticationRepository _repository;

        public AuthenticatedUserRegistrationService(IAuthenticationRepository repository)
        {
            _repository = repository;
        }

        public Guid Register(string firstName, string lastName, string email, string role, string password)
        {
            if (string.IsNullOrWhiteSpace(firstName) || string.IsNullOrWhiteSpace(lastName) || string.IsNullOrWhiteSpace(email))
            {
                throw new ArgumentException("First name, last name, and email are required.");
            }

            if (!string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) && !string.Equals(role, "RentalStaff", StringComparison.OrdinalIgnoreCase))
            {
                throw new ArgumentException("The role must be Admin or RentalStaff.");
            }

            PasswordService.ValidatePassword(password);
            var result = PasswordService.HashPassword(password);
            var userId = _repository.CreateUser(firstName.Trim(), lastName.Trim(), email.Trim(), role, result.Hash, result.Salt, true);
            if (userId == Guid.Empty)
            {
                throw new InvalidOperationException("The user could not be registered.");
            }

            return userId;
        }
    }
}
