using System;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class AuthenticationService
    {
        private readonly IAuthenticationRepository _repository;
        private readonly IAuditRepository _auditRepository;

        public AuthenticationService(IAuthenticationRepository repository, IAuditRepository auditRepository)
        {
            _repository = repository;
            _auditRepository = auditRepository;
        }

        public AuthenticatedUserDto Authenticate(string email, string password)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrEmpty(password))
            {
                return null;
            }

            var user = _repository.GetByEmail(email.Trim());
            if (user == null || !user.IsActive || !PasswordService.VerifyPassword(password, user.PasswordHash, user.PasswordSalt))
            {
                // Keep Guid.Empty as the anonymous failure sentinel; repository maps it to DB NULL.
                TryAudit(AuditEventFactory.Failure(
                    Guid.Empty,
                    email.Trim(),
                    AuditEventFactory.AccountCategory,
                    "SignIn",
                    "User",
                    null,
                    "A sign-in attempt failed.",
                    null));
                return null;
            }

            TryAudit(AuditEventFactory.Success(
                user.UserId,
                user.DisplayName,
                AuditEventFactory.AccountCategory,
                "SignIn",
                "User",
                user.UserId,
                "A user signed in successfully."));
            return user;
        }

        public AuthenticatedUserDto GetCurrentUser(Guid userId)
        {
            var user = _repository.GetById(userId);
            return user != null && user.IsActive &&
                (string.Equals(user.Role, "Admin", StringComparison.OrdinalIgnoreCase) ||
                 string.Equals(user.Role, "RentalStaff", StringComparison.OrdinalIgnoreCase))
                ? user
                : null;
        }

        public bool SetPassword(Guid userId, string password)
        {
            var passwordHash = PasswordService.HashPassword(password);
            return _repository.SetPassword(userId, passwordHash.Hash, passwordHash.Salt);
        }

        private void TryAudit(DataAccessLayer.DTOs.AuditRecordDto record)
        {
            try
            {
                _auditRepository.Insert(record);
            }
            catch
            {
            }
        }
    }
}
