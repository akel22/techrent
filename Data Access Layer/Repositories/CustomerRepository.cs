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
        public Guid Create(CustomerDto c) { using (var cn=DatabaseConnectionFactory.CreateConnection()) using (var cm=CreateStoredProcCommand(cn,"usp_CreateCustomer")) { Add(cm,c); var p=new SqlParameter("@UserID",SqlDbType.UniqueIdentifier){Direction=ParameterDirection.Output}; cm.Parameters.Add(p); cn.Open(); cm.ExecuteNonQuery(); return (Guid)p.Value; } }
        public CustomerDto GetById(Guid id) => Get("usp_GetCustomerById","@UserID",id);
        public CustomerDto GetByEmail(string email) => Get("usp_GetCustomerByEmail","@Email",email);
        public IEnumerable<CustomerDto> Search(string key) { var a=new List<CustomerDto>(); using(var cn=DatabaseConnectionFactory.CreateConnection()) using(var cm=CreateStoredProcCommand(cn,"usp_SearchCustomers")) { cm.Parameters.AddWithValue("@Keyword",(object)key??DBNull.Value); cn.Open(); using(var r=cm.ExecuteReader()) while(r.Read()) a.Add(Map(r)); } return a; }
        public void Update(CustomerDto c) { using(var cn=DatabaseConnectionFactory.CreateConnection()) using(var cm=CreateStoredProcCommand(cn,"usp_UpdateCustomer")) { cm.Parameters.Add("@UserID",SqlDbType.UniqueIdentifier).Value=c.UserId; Add(cm,c); cn.Open(); cm.ExecuteNonQuery(); } }
        private static void Add(SqlCommand cm,CustomerDto c) { cm.Parameters.AddWithValue("@FirstName",c.FirstName??(object)DBNull.Value); cm.Parameters.AddWithValue("@LastName",c.LastName??(object)DBNull.Value); cm.Parameters.AddWithValue("@Occupation",c.Occupation??(object)DBNull.Value); cm.Parameters.AddWithValue("@Email",c.Email??(object)DBNull.Value); cm.Parameters.AddWithValue("@MobileNumber",c.MobileNumber??(object)DBNull.Value); cm.Parameters.AddWithValue("@OrganizationAddress",c.OrganizationAddress??(object)DBNull.Value); cm.Parameters.Add("@IdentificationCard",SqlDbType.VarBinary,-1).Value=(object)c.IdentificationCard??DBNull.Value; }
        private CustomerDto Get(string p,string n,object v) { using(var cn=DatabaseConnectionFactory.CreateConnection()) using(var cm=CreateStoredProcCommand(cn,p)) { cm.Parameters.AddWithValue(n,v??DBNull.Value); cn.Open(); using(var r=cm.ExecuteReader()) return r.Read()?Map(r):null; } }
        private static CustomerDto Map(IDataRecord r) => new CustomerDto { CustomerId=r.GetGuid(r.GetOrdinal("CustomerID")),FirstName=r.GetString(r.GetOrdinal("FirstName")),LastName=r.GetString(r.GetOrdinal("LastName")),Occupation=r.GetString(r.GetOrdinal("Occupation")),Email=r.GetString(r.GetOrdinal("Email")),MobileNumber=r.IsDBNull(r.GetOrdinal("MobileNumber"))?null:r.GetString(r.GetOrdinal("MobileNumber")),OrganizationAddress=r.IsDBNull(r.GetOrdinal("OrganizationAddress"))?null:r.GetString(r.GetOrdinal("OrganizationAddress")),IdentificationCard=r.IsDBNull(r.GetOrdinal("IdentificationCard"))?null:(byte[])r["IdentificationCard"],CreatedAt=r.GetDateTime(r.GetOrdinal("CreatedAt")) };
    }
}