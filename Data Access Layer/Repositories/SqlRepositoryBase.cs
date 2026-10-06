using System;
using System.Data;
using System.Data.SqlClient;

namespace Techrent.DataAccessLayer.Repositories
{
    internal abstract class SqlRepositoryBase
    {
        protected SqlCommand CreateStoredProcCommand(SqlConnection connection, string procedureName)
        {
            var cmd = connection.CreateCommand();
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = procedureName;
            cmd.CommandTimeout = 60; // reasonable default
            return cmd;
        }

        protected static T GetField<T>(SqlDataReader reader, string name)
        {
            var ordinal = reader.GetOrdinal(name);
            if (reader.IsDBNull(ordinal))
                return default(T);
            return (T)reader.GetFieldValue(typeof(T), ordinal);
        }
    }
}
