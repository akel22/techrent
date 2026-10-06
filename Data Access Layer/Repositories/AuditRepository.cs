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
        public void Insert(AuditRecordDto record)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_InsertAudit"))
            {
                cmd.Parameters.AddWithValue("@Category", record.Category ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Description", record.Description ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@PerformedBy", record.PerformedBy ?? (object)DBNull.Value);
                conn.Open();
                cmd.ExecuteNonQuery();
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
                            AuditId = rdr.GetInt32(rdr.GetOrdinal("AuditId")),
                            Category = rdr.IsDBNull(rdr.GetOrdinal("Category")) ? null : rdr.GetString(rdr.GetOrdinal("Category")),
                            Description = rdr.IsDBNull(rdr.GetOrdinal("Description")) ? null : rdr.GetString(rdr.GetOrdinal("Description")),
                            PerformedBy = rdr.IsDBNull(rdr.GetOrdinal("PerformedBy")) ? null : rdr.GetString(rdr.GetOrdinal("PerformedBy")),
                            CreatedAt = rdr.GetDateTime(rdr.GetOrdinal("CreatedAt"))
                        });
                    }
                }
            }

            return list;
        }
    }
}
