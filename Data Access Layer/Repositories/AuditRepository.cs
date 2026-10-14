using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.DataAccessLayer.Repositories
{
    public class AuditRepository : SqlRepositoryBase, IAuditRepository
    {
        public Guid Insert(AuditRecordDto record)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_InsertAudit"))
            {
                cmd.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier).Value = record.UserId == Guid.Empty ? (object)DBNull.Value : record.UserId;
                cmd.Parameters.Add("@UserLogged", SqlDbType.NVarChar, 100).Value = (object)record.UserLogged ?? DBNull.Value;
                cmd.Parameters.Add("@Category", SqlDbType.NVarChar, 30).Value = (object)record.Category ?? DBNull.Value;
                cmd.Parameters.Add("@EventType", SqlDbType.NVarChar, 60).Value = (object)record.EventType ?? DBNull.Value;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar, -1).Value = (object)record.Description ?? DBNull.Value;
                var output = new SqlParameter("@LogID", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(output);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    return (Guid)output.Value;
                }
                catch (Exception e)
                {
                    throw new Exception("An error occurred while inserting the audit record.", e);
                }
            }
        }

        public IEnumerable<AuditRecordDto> QueryRecent(int maxRows)
        {
            var list = new List<AuditRecordDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetRecentAudits"))
            {
                cmd.Parameters.AddWithValue("@MaxRows", maxRows);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        list.Add(new AuditRecordDto
                        {
                            LogId = rdr.GetGuid(rdr.GetOrdinal("LogID")),
                            UserId = rdr.IsDBNull(rdr.GetOrdinal("UserID")) ? Guid.Empty : rdr.GetGuid(rdr.GetOrdinal("UserID")),
                            UserLogged = rdr.GetString(rdr.GetOrdinal("UserLogged")),
                            UserRole = rdr.IsDBNull(rdr.GetOrdinal("Role")) ? null : rdr.GetString(rdr.GetOrdinal("Role")),
                            LoggedAt = rdr.GetDateTime(rdr.GetOrdinal("LoggedAt")),
                            Category = GetNullableString(rdr, "Category"),
                            EventType = GetNullableString(rdr, "EventType"),
                            Description = rdr.IsDBNull(rdr.GetOrdinal("Description")) ? null : rdr.GetString(rdr.GetOrdinal("Description"))
                        });
                    }
                }
            }

            return list;
        }

        public IEnumerable<AuditRecordDto> QueryFiltered(int page, int pageSize, DateTime? dateFrom, DateTime? dateTo, string category, string query, out int totalRows)
        {
            var list = new List<AuditRecordDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_SearchAudits"))
            {
                cmd.Parameters.AddWithValue("@Page", page);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);
                cmd.Parameters.AddWithValue("@Category", (object)category ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Query", (object)query ?? DBNull.Value);

                var pDateFrom = new SqlParameter("@DateFrom", SqlDbType.DateTime) { Direction = ParameterDirection.Input };
                if (dateFrom.HasValue) pDateFrom.Value = dateFrom.Value;
                else pDateFrom.Value = DBNull.Value;
                cmd.Parameters.Add(pDateFrom);

                var pDateTo = new SqlParameter("@DateTo", SqlDbType.DateTime) { Direction = ParameterDirection.Input };
                if (dateTo.HasValue) pDateTo.Value = dateTo.Value;
                else pDateTo.Value = DBNull.Value;
                cmd.Parameters.Add(pDateTo);

                var output = new SqlParameter("@TotalRows", SqlDbType.Int) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(output);

                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        list.Add(new AuditRecordDto
                        {
                            LogId = rdr.GetGuid(rdr.GetOrdinal("LogID")),
                            UserId = rdr.IsDBNull(rdr.GetOrdinal("UserID")) ? Guid.Empty : rdr.GetGuid(rdr.GetOrdinal("UserID")),
                            UserLogged = rdr.GetString(rdr.GetOrdinal("UserLogged")),
                            UserRole = rdr.IsDBNull(rdr.GetOrdinal("Role")) ? null : rdr.GetString(rdr.GetOrdinal("Role")),
                            LoggedAt = rdr.GetDateTime(rdr.GetOrdinal("LoggedAt")),
                            Category = GetNullableString(rdr, "Category"),
                            EventType = GetNullableString(rdr, "EventType"),
                            Description = rdr.IsDBNull(rdr.GetOrdinal("Description")) ? null : rdr.GetString(rdr.GetOrdinal("Description"))
                        });
                    }
                }

                totalRows = output.Value == DBNull.Value ? 0 : (int)output.Value;
            }

            return list;
        }

        private static string GetNullableString(SqlDataReader reader, string columnName)
        {
            var ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? null : reader.GetString(ordinal);
        }
    }
}
