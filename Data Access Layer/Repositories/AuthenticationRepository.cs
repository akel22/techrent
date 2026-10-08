using System;
using System.Data;
using System.Data.SqlClient;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.DataAccessLayer.Repositories
{
    public class AuthenticationRepository : SqlRepositoryBase, IAuthenticationRepository
    {
        public AuthenticatedUserDto GetByEmail(string email)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetUserForAuthentication"))
            {
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 32).Value = email;
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    return reader.Read() ? Map(reader) : null;
                }
            }
        }

        public AuthenticatedUserDto GetById(Guid userId)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetUserForAuthorization"))
            {
                cmd.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier).Value = userId;
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    return reader.Read() ? Map(reader) : null;
                }
            }
        }

        public Guid CreateUser(string firstName, string lastName, string email, string role, byte[] passwordHash, byte[] passwordSalt, bool canProvision)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_CreateAuthenticatedUser"))
            {
                cmd.Parameters.Add("@FirstName", SqlDbType.NVarChar, 24).Value = firstName;
                cmd.Parameters.Add("@LastName", SqlDbType.NVarChar, 24).Value = lastName;
                cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 32).Value = email;
                cmd.Parameters.Add("@Role", SqlDbType.NVarChar, 24).Value = role;
                cmd.Parameters.Add("@PasswordHash", SqlDbType.VarBinary, 64).Value = passwordHash;
                cmd.Parameters.Add("@PasswordSalt", SqlDbType.VarBinary, 32).Value = passwordSalt;
                cmd.Parameters.Add("@CanProvision", SqlDbType.Bit).Value = canProvision;
                var output = new SqlParameter("@UserID", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(output);
                conn.Open();
                cmd.ExecuteNonQuery();
                return output.Value == DBNull.Value ? Guid.Empty : (Guid)output.Value;
            }
        }

        public bool SetPassword(Guid userId, byte[] passwordHash, byte[] passwordSalt)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_SetUserPassword"))
            {
                cmd.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier).Value = userId;
                cmd.Parameters.Add("@PasswordHash", SqlDbType.VarBinary, 64).Value = passwordHash;
                cmd.Parameters.Add("@PasswordSalt", SqlDbType.VarBinary, 32).Value = passwordSalt;
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    return reader.Read() && reader.GetBoolean(reader.GetOrdinal("PasswordUpdated"));
                }
            }
        }


        private static AuthenticatedUserDto Map(IDataRecord record)
        {
            return new AuthenticatedUserDto
            {
                UserId = record.GetGuid(record.GetOrdinal("UserID")),
                FirstName = record.GetString(record.GetOrdinal("FirstName")),
                LastName = record.GetString(record.GetOrdinal("LastName")),
                Role = record.GetString(record.GetOrdinal("Role")),
                Email = record.GetString(record.GetOrdinal("Email")),
                PasswordHash = record.IsDBNull(record.GetOrdinal("PasswordHash")) ? null : (byte[])record["PasswordHash"],
                PasswordSalt = record.IsDBNull(record.GetOrdinal("PasswordSalt")) ? null : (byte[])record["PasswordSalt"],
                IsActive = record.GetBoolean(record.GetOrdinal("IsActive"))
            };
        }
    }
}
