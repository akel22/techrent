using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.DataAccessLayer.Repositories
{
    public class CustomerRepository : SqlRepositoryBase, ICustomerRepository
    {
        public int Create(CustomerDto customer)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_CreateCustomer"))
            {
                cmd.Parameters.AddWithValue("@FullName", customer.FullName ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Mobile", customer.Mobile ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Email", customer.Email ?? (object)DBNull.Value);
                var outId = new SqlParameter("@CustomerId", SqlDbType.Int) { Direction = ParameterDirection.Output };
                cmd.Parameters.Add(outId);
                conn.Open();
                cmd.ExecuteNonQuery();
                return (int)outId.Value;
            }
        }

        public CustomerDto GetByCode(string customerCode)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetCustomerByCode"))
            {
                cmd.Parameters.AddWithValue("@CustomerCode", customerCode ?? (object)DBNull.Value);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        return new CustomerDto
                        {
                            CustomerId = rdr.GetInt32(rdr.GetOrdinal("CustomerId")),
                            CustomerCode = rdr.GetString(rdr.GetOrdinal("CustomerCode")),
                            FullName = rdr.GetString(rdr.GetOrdinal("FullName")),
                            Mobile = rdr.IsDBNull(rdr.GetOrdinal("Mobile")) ? null : rdr.GetString(rdr.GetOrdinal("Mobile")),
                            Email = rdr.IsDBNull(rdr.GetOrdinal("Email")) ? null : rdr.GetString(rdr.GetOrdinal("Email")),
                            CreatedAt = rdr.GetDateTime(rdr.GetOrdinal("CreatedAt"))
                        };
                    }
                }
            }

            return null;
        }

        public CustomerDto GetById(int customerId)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_GetCustomerById"))
            {
                cmd.Parameters.AddWithValue("@CustomerId", customerId);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        return new CustomerDto
                        {
                            CustomerId = rdr.GetInt32(rdr.GetOrdinal("CustomerId")),
                            CustomerCode = rdr.GetString(rdr.GetOrdinal("CustomerCode")),
                            FullName = rdr.GetString(rdr.GetOrdinal("FullName")),
                            Mobile = rdr.IsDBNull(rdr.GetOrdinal("Mobile")) ? null : rdr.GetString(rdr.GetOrdinal("Mobile")),
                            Email = rdr.IsDBNull(rdr.GetOrdinal("Email")) ? null : rdr.GetString(rdr.GetOrdinal("Email")),
                            CreatedAt = rdr.GetDateTime(rdr.GetOrdinal("CreatedAt"))
                        };
                    }
                }
            }

            return null;
        }

        public IEnumerable<CustomerDto> Search(string keyword)
        {
            var results = new List<CustomerDto>();
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_SearchCustomers"))
            {
                cmd.Parameters.AddWithValue("@Keyword", keyword ?? (object)DBNull.Value);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        results.Add(new CustomerDto
                        {
                            CustomerId = rdr.GetInt32(rdr.GetOrdinal("CustomerId")),
                            CustomerCode = rdr.GetString(rdr.GetOrdinal("CustomerCode")),
                            FullName = rdr.GetString(rdr.GetOrdinal("FullName")),
                            Mobile = rdr.IsDBNull(rdr.GetOrdinal("Mobile")) ? null : rdr.GetString(rdr.GetOrdinal("Mobile")),
                            Email = rdr.IsDBNull(rdr.GetOrdinal("Email")) ? null : rdr.GetString(rdr.GetOrdinal("Email")),
                            CreatedAt = rdr.GetDateTime(rdr.GetOrdinal("CreatedAt"))
                        });
                    }
                }
            }

            return results;
        }

        public void Update(CustomerDto customer)
        {
            using (var conn = DatabaseConnectionFactory.CreateConnection())
            using (var cmd = CreateStoredProcCommand(conn, "usp_UpdateCustomer"))
            {
                cmd.Parameters.AddWithValue("@CustomerId", customer.CustomerId);
                cmd.Parameters.AddWithValue("@FullName", customer.FullName ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Mobile", customer.Mobile ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@Email", customer.Email ?? (object)DBNull.Value);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
