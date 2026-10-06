using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.DataAccessLayer.Repositories
{
    public class RentalRepository : SqlRepositoryBase, IRentalRepository
    {
        public int CreateRental(RentalTransactionDto transaction)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            {
                conn.Open();
                using (var tx = conn.BeginTransaction())
                {
                    try
                    {
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = tx;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "usp_CreateRental";
                            cmd.Parameters.AddWithValue("@CustomerId", transaction.CustomerId);
                            cmd.Parameters.AddWithValue("@DueDate", transaction.DueDate);
                            cmd.Parameters.AddWithValue("@RentalFee", transaction.RentalFee);
                            cmd.Parameters.AddWithValue("@SecurityDeposit", transaction.SecurityDeposit);
                            var outId = new SqlParameter("@RentalTransactionId", SqlDbType.Int) { Direction = ParameterDirection.Output };
                            cmd.Parameters.Add(outId);
                            cmd.ExecuteNonQuery();

                            var rentalId = (int)outId.Value;

                            // insert items
                            foreach (var item in transaction.Items)
                            {
                                using (var itemCmd = conn.CreateCommand())
                                {
                                    itemCmd.Transaction = tx;
                                    itemCmd.CommandType = CommandType.StoredProcedure;
                                    itemCmd.CommandText = "usp_AddRentalItem";
                                    itemCmd.Parameters.AddWithValue("@RentalTransactionId", rentalId);
                                    itemCmd.Parameters.AddWithValue("@EquipmentId", item.EquipmentId);
                                    itemCmd.Parameters.AddWithValue("@Quantity", item.Quantity);
                                    itemCmd.Parameters.AddWithValue("@SerialNumber", item.SerialNumber ?? (object)DBNull.Value);
                                    itemCmd.ExecuteNonQuery();
                                }
                            }

                            tx.Commit();
                            return rentalId;
                        }
                    }
                    catch
                    {
                        tx.Rollback();
                        throw;
                    }
                }
            }
        }

        public RentalTransactionDto GetById(int rentalTransactionId)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetRentalById"))
            {
                cmd.Parameters.AddWithValue("@RentalTransactionId", rentalTransactionId);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        var tx = new RentalTransactionDto
                        {
                            RentalTransactionId = rdr.GetInt32(rdr.GetOrdinal("RentalTransactionId")),
                            TransactionCode = rdr.GetString(rdr.GetOrdinal("TransactionCode")),
                            CustomerId = rdr.GetInt32(rdr.GetOrdinal("CustomerId")),
                            CustomerName = rdr.GetString(rdr.GetOrdinal("CustomerName")),
                            CreatedAt = rdr.GetDateTime(rdr.GetOrdinal("CreatedAt")),
                            DueDate = rdr.GetDateTime(rdr.GetOrdinal("DueDate")),
                            Status = rdr.GetString(rdr.GetOrdinal("Status")),
                            RentalFee = rdr.GetDecimal(rdr.GetOrdinal("RentalFee")),
                            SecurityDeposit = rdr.GetDecimal(rdr.GetOrdinal("SecurityDeposit"))
                        };

                        // read items if present in next result set
                        if (rdr.NextResult())
                        {
                            while (rdr.Read())
                            {
                                tx.Items.Add(new RentalItemDto
                                {
                                    RentalItemId = rdr.GetInt32(rdr.GetOrdinal("RentalItemId")),
                                    EquipmentId = rdr.GetInt32(rdr.GetOrdinal("EquipmentId")),
                                    EquipmentName = rdr.GetString(rdr.GetOrdinal("EquipmentName")),
                                    SerialNumber = rdr.IsDBNull(rdr.GetOrdinal("SerialNumber")) ? null : rdr.GetString(rdr.GetOrdinal("SerialNumber")),
                                    Quantity = rdr.GetInt32(rdr.GetOrdinal("Quantity")),
                                    Rate = rdr.GetDecimal(rdr.GetOrdinal("Rate"))
                                });
                            }
                        }

                        return tx;
                    }
                }
            }

            return null;
        }

        public IEnumerable<RentalTransactionDto> GetActiveRentals()
        {
            var list = new List<RentalTransactionDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetActiveRentals"))
            {
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        list.Add(new RentalTransactionDto
                        {
                            RentalTransactionId = rdr.GetInt32(rdr.GetOrdinal("RentalTransactionId")),
                            TransactionCode = rdr.GetString(rdr.GetOrdinal("TransactionCode")),
                            CustomerId = rdr.GetInt32(rdr.GetOrdinal("CustomerId")),
                            CustomerName = rdr.GetString(rdr.GetOrdinal("CustomerName")),
                            CreatedAt = rdr.GetDateTime(rdr.GetOrdinal("CreatedAt")),
                            DueDate = rdr.GetDateTime(rdr.GetOrdinal("DueDate")),
                            Status = rdr.GetString(rdr.GetOrdinal("Status")),
                            RentalFee = rdr.GetDecimal(rdr.GetOrdinal("RentalFee")),
                            SecurityDeposit = rdr.GetDecimal(rdr.GetOrdinal("SecurityDeposit"))
                        });
                    }
                }
            }

            return list;
        }

        public void CompleteRental(int rentalTransactionId)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_CompleteRental"))
            {
                cmd.Parameters.AddWithValue("@RentalTransactionId", rentalTransactionId);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
