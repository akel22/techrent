using System;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IAuthenticationRepository
    {
        AuthenticatedUserDto GetByEmail(string email);
        AuthenticatedUserDto GetById(Guid userId);
        bool SetPassword(Guid userId, byte[] passwordHash, byte[] passwordSalt);
        Guid CreateUser(string firstName, string lastName, string email, string role, byte[] passwordHash, byte[] passwordSalt, bool canProvision);
    }
}
