using System;
using System.Configuration;
using System.Data.SqlClient;

namespace Techrent.DataAccessLayer.Repositories
{
    public static class DatabaseConnectionFactory
    {
        public static SqlConnection CreateConnection()
        {
            var settings = ConfigurationManager.ConnectionStrings["TechrentConnection"];
            if (settings == null || string.IsNullOrWhiteSpace(settings.ConnectionString))
            {
                throw new InvalidOperationException("Connection string 'TechrentConnection' is not configured in Web.config.");
            }

            return new SqlConnection(settings.ConnectionString);
        }
    }
}
