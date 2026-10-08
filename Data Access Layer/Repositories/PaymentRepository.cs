using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.DataAccessLayer.Repositories
{
    public class PaymentRepository : SqlRepositoryBase, IPaymentRepository
    {
        public Guid Create(PaymentDto payment)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_CreatePayment"))
            {
                cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = payment.TransactionId;
                cmd.Parameters.AddWithValue("@PaymentType", payment.PaymentType);
                cmd.Parameters.AddWithValue("@Amount", payment.Amount);
                cmd.Parameters.AddWithValue("@PaymentMethod", payment.PaymentMethod);
                var output = new SqlParameter("@PaymentID", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(output);
                conn.Open();
                cmd.ExecuteNonQuery();
                return (Guid)output.Value;
            }
        }

        public IEnumerable<PaymentDto> GetByTransaction(Guid id)
        {
            var list = new List<PaymentDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetPaymentsByTransaction"))
            {
                cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = id;
                conn.Open();
                using (var r = cmd.ExecuteReader())
                    while (r.Read())
                        list.Add(new PaymentDto
                        {
                            PaymentId = r.GetGuid(r.GetOrdinal("PaymentID")),
                            TransactionId = r.GetGuid(r.GetOrdinal("TransactionID")),
                            PaymentType = r.GetString(r.GetOrdinal("PaymentType")),
                            Amount = r.GetDecimal(r.GetOrdinal("Amount")),
                            PaymentMethod = r.GetString(r.GetOrdinal("PaymentMethod")),
                            CreatedAt = r.GetDateTime(r.GetOrdinal("CreatedAt"))
                        });
            }

            return list;
        }

        public IEnumerable<PaymentDto> GetActivity()
        {
            var list = new List<PaymentDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetPaymentActivity"))
            {
                conn.Open();
                using (var r = cmd.ExecuteReader())
                    while (r.Read())
                        list.Add(new PaymentDto
                        {
                            PaymentId = r.GetGuid(r.GetOrdinal("PaymentID")),
                            TransactionId = r.GetGuid(r.GetOrdinal("TransactionID")),
                            PaymentType = r.GetString(r.GetOrdinal("PaymentType")),
                            Amount = r.GetDecimal(r.GetOrdinal("Amount")),
                            PaymentMethod = r.GetString(r.GetOrdinal("PaymentMethod")),
                            CreatedAt = r.GetDateTime(r.GetOrdinal("CreatedAt"))
                        });
            }

            return list;
        }

        public IEnumerable<PaymentDto> GetActivityPaged(int pageNumber, int pageSize, string searchTerm, string sortDirection, out int totalCount)
        {
            var list = new List<PaymentDto>();
            totalCount = 0;
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetPaymentActivity"))
            {
                cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);
                cmd.Parameters.AddWithValue("@SearchTerm", (object)searchTerm ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@SortDirection", sortDirection ?? "DESC");
                var outParam = new SqlParameter("@TotalCount", SqlDbType.Int) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outParam);

                conn.Open();
                using (var r = cmd.ExecuteReader())
                    while (r.Read())
                        list.Add(new PaymentDto
                        {
                            PaymentId = r.GetGuid(r.GetOrdinal("PaymentID")),
                            TransactionId = r.GetGuid(r.GetOrdinal("TransactionID")),
                            PaymentType = r.GetString(r.GetOrdinal("PaymentType")),
                            Amount = r.GetDecimal(r.GetOrdinal("Amount")),
                            PaymentMethod = r.GetString(r.GetOrdinal("PaymentMethod")),
                            CreatedAt = r.GetDateTime(r.GetOrdinal("CreatedAt"))
                        });

                // After reader is consumed, retrieve output parameter
                if (outParam.Value != DBNull.Value)
                    totalCount = Convert.ToInt32(outParam.Value);
            }

            return list;
        }
    }
}