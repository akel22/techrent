using System;
using System.Data.SqlClient;

namespace Techrent.DataAccessLayer.Repositories
{
    public static class DatabaseConnectionFactory
    {
        public static SqlConnection CreateConnection()
        {
            var connectionString = Environment.GetEnvironmentVariable("TECHRENT_CONNECTION_STRING");
            if (string.IsNullOrWhiteSpace(connectionString))
            {
                throw new InvalidOperationException("The TECHRENT_CONNECTION_STRING environment variable is not configured.");
            }

            return new SqlConnection(connectionString);
        }
    }
}
