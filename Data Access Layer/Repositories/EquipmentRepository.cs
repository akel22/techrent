using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;
namespace Techrent.DataAccessLayer.Repositories
{
    public class EquipmentRepository : SqlRepositoryBase, IEquipmentRepository
    {
        public Guid Create(EquipmentDto equipment)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_CreateEquipment"))
            {
                cmd.Parameters.AddWithValue("@Category", equipment.Category ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Type", equipment.Type ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Status", equipment.Status ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Model", equipment.Model ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@SKU", equipment.Sku ?? (object)DBNull.Value);
                cmd.Parameters.Add("@Image", SqlDbType.VarBinary, -1).Value = equipment.Image ?? (object)DBNull.Value;
                cmd.Parameters.Add("@Stock", SqlDbType.Int).Value = equipment.Stock;
                cmd.Parameters.Add("@BaseRentalFee", SqlDbType.Decimal).Value = equipment.BaseRentalFee;
                cmd.Parameters.Add("@SecurityDeposit", SqlDbType.Decimal).Value = equipment.SecurityDeposit;
                var output = new SqlParameter("@EquipmentID", SqlDbType.UniqueIdentifier) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(output);
                conn.Open();
                cmd.ExecuteNonQuery();
                return (Guid)output.Value;
            }
        }

        public void Update(EquipmentDto equipment)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_UpdateEquipment"))
            {
                cmd.Parameters.Add("@EquipmentID", SqlDbType.UniqueIdentifier).Value = equipment.EquipmentId;
                cmd.Parameters.AddWithValue("@Type", equipment.Type);
                cmd.Parameters.AddWithValue("@Status", equipment.Status);
                cmd.Parameters.Add("@Stock", SqlDbType.Int).Value = equipment.Stock;
                cmd.Parameters.Add("@BaseRentalFee", SqlDbType.Decimal).Value = equipment.BaseRentalFee;
                cmd.Parameters.Add("@SecurityDeposit", SqlDbType.Decimal).Value = equipment.SecurityDeposit;
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public bool Delete(Guid equipmentId)
        {
            using (var connection = DatabaseConnectionFactory.CreateConnection())
            using (var command = CreateStoredProcCommand(connection, "usp_DeleteEquipment"))
            {
                command.Parameters.Add("@EquipmentID", SqlDbType.UniqueIdentifier).Value = equipmentId;
                connection.Open();
                return Convert.ToBoolean(command.ExecuteScalar());
            }
        }

        public EquipmentDto GetById(Guid id) { var result = Query("usp_GetEquipmentById", "@EquipmentID", id); return result.Count == 0 ? null : result[0]; }
        public IEnumerable<EquipmentDto> Search(string keyword) => Query("usp_SearchEquipment", "@Keyword", keyword);
        private List<EquipmentDto> Query(string procedure, string parameter, object value)
        {
            var list = new List<EquipmentDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection()) using (var cmd = CreateStoredProcCommand(conn, procedure))
            { cmd.Parameters.AddWithValue(parameter, value ?? (object)DBNull.Value); conn.Open(); using (var r = cmd.ExecuteReader()) while (r.Read()) list.Add(new EquipmentDto { EquipmentId = r.GetGuid(r.GetOrdinal("EquipmentID")), Category = r.GetString(r.GetOrdinal("Category")), Type = r.GetString(r.GetOrdinal("Type")), Status = r.GetString(r.GetOrdinal("Status")), Model = r.GetString(r.GetOrdinal("Model")), Sku = r.GetString(r.GetOrdinal("SKU")), Image = r.IsDBNull(r.GetOrdinal("Image")) ? null : (byte[])r["Image"], Stock = r.GetInt32(r.GetOrdinal("Stock")), BaseRentalFee = r.GetDecimal(r.GetOrdinal("BaseRentalFee")), SecurityDeposit = r.GetDecimal(r.GetOrdinal("SecurityDeposit")), CreatedAt = r.GetDateTime(r.GetOrdinal("CreatedAt")) }); }
            return list;
        }
    }
}