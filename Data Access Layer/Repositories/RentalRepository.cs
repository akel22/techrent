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
        public Guid CreateRental(RentalTransactionDto transaction)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection()) { conn.Open(); using (var transactionScope = conn.BeginTransaction()) try { Guid id; using (var cmd = conn.CreateCommand()) { cmd.Transaction = transactionScope; cmd.CommandType = CommandType.StoredProcedure; cmd.CommandText = "usp_CreateTransaction"; cmd.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier).Value = transaction.UserId; cmd.Parameters.Add("@DueAt", SqlDbType.DateTime2).Value = transaction.DueAt; var output = new SqlParameter("@TransactionID", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.Output }; cmd.Parameters.Add(output); cmd.ExecuteNonQuery(); id = (Guid)output.Value; } foreach (var item in transaction.Items) using (var cmd = conn.CreateCommand()) { cmd.Transaction = transactionScope; cmd.CommandType = CommandType.StoredProcedure; cmd.CommandText = "usp_AddTransactionEquipment"; cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = id; cmd.Parameters.Add("@EquipmentID", SqlDbType.UniqueIdentifier).Value = item.EquipmentId; cmd.Parameters.Add("@Quantity", SqlDbType.Int).Value = item.Quantity; cmd.Parameters.Add("@RentalFee", SqlDbType.Decimal).Value = item.RentalFee; cmd.Parameters.Add("@DepositFee", SqlDbType.Decimal).Value = item.DepositFee; cmd.ExecuteNonQuery(); } transactionScope.Commit(); return id; } catch { transactionScope.Rollback(); throw; } }
        }

        public Guid CreateRental(RentalTransactionDto transaction, PaymentDto payment)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            {
                conn.Open();
                using (var transactionScope = conn.BeginTransaction())
                {
                    try
                    {
                        Guid id;
                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = transactionScope;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "usp_CreateTransaction";
                            cmd.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier).Value = transaction.UserId;
                            cmd.Parameters.Add("@DueAt", SqlDbType.DateTime2).Value = transaction.DueAt;
                            var output = new SqlParameter("@TransactionID", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.Output };
                            cmd.Parameters.Add(output);
                            cmd.ExecuteNonQuery();
                            id = (Guid)output.Value;
                        }

                        foreach (var item in transaction.Items)
                        {
                            using (var cmd = conn.CreateCommand())
                            {
                                cmd.Transaction = transactionScope;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "usp_AddTransactionEquipment";
                                cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = id;
                                cmd.Parameters.Add("@EquipmentID", SqlDbType.UniqueIdentifier).Value = item.EquipmentId;
                                cmd.Parameters.Add("@Quantity", SqlDbType.Int).Value = item.Quantity;
                                cmd.Parameters.Add("@RentalFee", SqlDbType.Decimal).Value = item.RentalFee;
                                cmd.Parameters.Add("@DepositFee", SqlDbType.Decimal).Value = item.DepositFee;
                                cmd.ExecuteNonQuery();
                            }
                        }

                        using (var cmd = conn.CreateCommand())
                        {
                            cmd.Transaction = transactionScope;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "usp_CreatePayment";
                            cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = id;
                            cmd.Parameters.Add("@PaymentType", SqlDbType.NVarChar, 30).Value = payment.PaymentType;
                            cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = payment.Amount;
                            cmd.Parameters.Add("@PaymentMethod", SqlDbType.NVarChar, 30).Value = payment.PaymentMethod;
                            var output = new SqlParameter("@PaymentID", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.Output };
                            cmd.Parameters.Add(output);
                            cmd.ExecuteNonQuery();
                        }

                        transactionScope.Commit();
                        return id;
                    }
                    catch
                    {
                        transactionScope.Rollback();
                        throw;
                    }
                }
            }
        }
        public RentalTransactionDto GetById(Guid id) { using (var conn = DatabaseConnectionFactory.CreateConnection()) using (var cmd = CreateStoredProcCommand(conn, "usp_GetTransactionById")) { cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = id; conn.Open(); using (var reader = cmd.ExecuteReader()) { if (!reader.Read()) return null; var result = Map(reader); if (reader.NextResult()) while (reader.Read()) result.Items.Add(MapItem(reader)); return result; } } }
        public IEnumerable<RentalTransactionDto> GetActiveRentals() { var list = new List<RentalTransactionDto>(); using (var conn = DatabaseConnectionFactory.CreateConnection()) using (var cmd = CreateStoredProcCommand(conn, "usp_GetActiveRentals")) { conn.Open(); using (var reader = cmd.ExecuteReader()) while (reader.Read()) list.Add(Map(reader)); } return list; }
        public IEnumerable<RentalTransactionDto> GetTransactionLog() { var list = new List<RentalTransactionDto>(); using (var conn = DatabaseConnectionFactory.CreateConnection()) using (var cmd = CreateStoredProcCommand(conn, "usp_GetTransactionLog")) { conn.Open(); using (var reader = cmd.ExecuteReader()) while (reader.Read()) list.Add(Map(reader)); } return list; }
        public IEnumerable<RentalTransactionDto> GetByCustomer(Guid customerId) { var list = new List<RentalTransactionDto>(); using (var conn = DatabaseConnectionFactory.CreateConnection()) using (var cmd = CreateStoredProcCommand(conn, "usp_GetTransactionsByCustomer")) { cmd.Parameters.Add("@UserID", SqlDbType.UniqueIdentifier).Value = customerId; conn.Open(); using (var reader = cmd.ExecuteReader()) while (reader.Read()) list.Add(Map(reader)); return list; } }
        public void CompleteRental(Guid id, string returnConditionNotes) { using (var conn = DatabaseConnectionFactory.CreateConnection()) using (var cmd = CreateStoredProcCommand(conn, "usp_CompleteTransaction")) { cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = id; cmd.Parameters.Add("@ReturnConditionNotes", SqlDbType.NVarChar, 500).Value = (object)returnConditionNotes ?? DBNull.Value; conn.Open(); cmd.ExecuteNonQuery(); } }
        public bool ArchiveRental(Guid id) { using (var conn = DatabaseConnectionFactory.CreateConnection()) using (var cmd = CreateStoredProcCommand(conn, "usp_ArchiveTransaction")) { cmd.Parameters.Add("@TransactionID", SqlDbType.UniqueIdentifier).Value = id; conn.Open(); object result = cmd.ExecuteScalar(); return result != null && result != DBNull.Value && Convert.ToBoolean(result); } }
        private static RentalTransactionDto Map(IDataRecord r) => new RentalTransactionDto { TransactionId = r.GetGuid(r.GetOrdinal("TransactionID")), UserId = r.GetGuid(r.GetOrdinal("UserID")), FirstName = r.GetString(r.GetOrdinal("FirstName")), LastName = r.GetString(r.GetOrdinal("LastName")), CreatedAt = r.GetDateTime(r.GetOrdinal("CreatedAt")), DueAt = r.GetDateTime(r.GetOrdinal("DueAt")), Status = r.GetString(r.GetOrdinal("Status")), IsArchived = r.GetBoolean(r.GetOrdinal("IsArchived")), Receipt = r.IsDBNull(r.GetOrdinal("Receipt")) ? null : (byte[])r["Receipt"] };
        private static RentalItemDto MapItem(IDataRecord r) => new RentalItemDto { TransactionId = r.GetGuid(r.GetOrdinal("TransactionID")), EquipmentId = r.GetGuid(r.GetOrdinal("EquipmentID")), Model = r.GetString(r.GetOrdinal("Model")), Sku = r.GetString(r.GetOrdinal("SKU")), Category = r.GetString(r.GetOrdinal("Category")), EquipmentType = r.GetString(r.GetOrdinal("Type")), EquipmentStatus = r.GetString(r.GetOrdinal("Status")), Quantity = r.GetInt32(r.GetOrdinal("Quantity")), RentalFee = r.GetDecimal(r.GetOrdinal("RentalFee")), DepositFee = r.GetDecimal(r.GetOrdinal("DepositFee")) };
    }
}