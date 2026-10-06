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
        public EquipmentDto GetById(int equipmentId)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetEquipmentById"))
            {
                cmd.Parameters.AddWithValue("@EquipmentId", equipmentId);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        return new EquipmentDto
                        {
                            EquipmentId = rdr.GetInt32(rdr.GetOrdinal("EquipmentId")),
                            Name = rdr.GetString(rdr.GetOrdinal("Name")),
                            Category = rdr.IsDBNull(rdr.GetOrdinal("Category")) ? null : rdr.GetString(rdr.GetOrdinal("Category")),
                            RentalRate = rdr.GetDecimal(rdr.GetOrdinal("RentalRate")),
                            AvailableQuantity = rdr.GetInt32(rdr.GetOrdinal("AvailableQuantity"))
                        };
                    }
                }
            }

            return null;
        }

        public IEnumerable<EquipmentDto> Search(string keyword)
        {
            var list = new List<EquipmentDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_SearchEquipment"))
            {
                cmd.Parameters.AddWithValue("@Keyword", keyword ?? (object)DBNull.Value);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        list.Add(new EquipmentDto
                        {
                            EquipmentId = rdr.GetInt32(rdr.GetOrdinal("EquipmentId")),
                            Name = rdr.GetString(rdr.GetOrdinal("Name")),
                            Category = rdr.IsDBNull(rdr.GetOrdinal("Category")) ? null : rdr.GetString(rdr.GetOrdinal("Category")),
                            RentalRate = rdr.GetDecimal(rdr.GetOrdinal("RentalRate")),
                            AvailableQuantity = rdr.GetInt32(rdr.GetOrdinal("AvailableQuantity"))
                        });
                    }
                }
            }

            return list;
        }

        public bool IsSerialAvailable(string serialNumber)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_IsSerialAvailable"))
            {
                cmd.Parameters.AddWithValue("@SerialNumber", serialNumber ?? (object)DBNull.Value);
                var outParam = new SqlParameter("@IsAvailable", SqlDbType.Bit) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outParam);
                conn.Open();
                cmd.ExecuteNonQuery();
                return Convert.ToBoolean(outParam.Value);
            }
        }
    }
}
