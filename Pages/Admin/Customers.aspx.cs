using System;
using System.Collections.Generic;
using System.Web.UI;

namespace Techrent.Pages.Admin
{
    public partial class Customers : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CustomersRepeater.DataSource = GetSampleCustomers();
                CustomersRepeater.DataBind();
            }
        }

        private static List<CustomerRow> GetSampleCustomers()
        {
            return new List<CustomerRow>
            {
                new CustomerRow { CustomerId = "CUSTOMER-001", FirstName = "John", LastName = "Doe", Email = "johndoe@example.com", MobileNumber = "09112223456", TelephoneNumber = "(02) 8123 4567", Organization = "Quezon City University", Address = "Novaliches, Quezon City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-002", FirstName = "Jane", LastName = "Santos", Email = "janesantos@example.com", MobileNumber = "09123334567", TelephoneNumber = "(02) 8234 5678", Organization = "Northstar Media", Address = "Makati City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-003", FirstName = "Miguel", LastName = "Reyes", Email = "miguelreyes@example.com", MobileNumber = "09134445678", TelephoneNumber = "(02) 8345 6789", Organization = "Vertex Design Studio", Address = "Pasig City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-004", FirstName = "Angela", LastName = "Cruz", Email = "angelacruz@example.com", MobileNumber = "09145556789", TelephoneNumber = "(02) 8456 7890", Organization = "Crescent Events", Address = "Manila City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-005", FirstName = "Daniel", LastName = "Garcia", Email = "danielgarcia@example.com", MobileNumber = "09156667890", TelephoneNumber = "(02) 8567 8901", Organization = "Garcia and Partners", Address = "Mandaluyong City", AccountStatus = "Inactive" },
                new CustomerRow { CustomerId = "CUSTOMER-006", FirstName = "Sofia", LastName = "Mendoza", Email = "sofiamendoza@example.com", MobileNumber = "09167778901", TelephoneNumber = "(02) 8678 9012", Organization = "Brightline Learning", Address = "Marikina City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-007", FirstName = "Robert", LastName = "Lim", Email = "robertlim@example.com", MobileNumber = "09178889012", TelephoneNumber = "(02) 8789 0123", Organization = "Pacific Trade Co.", Address = "Taguig City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-008", FirstName = "Carla", LastName = "Navarro", Email = "carlanavarro@example.com", MobileNumber = "09189990123", TelephoneNumber = "(02) 8890 1234", Organization = "Navarro Consulting", Address = "Caloocan City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-009", FirstName = "Anthony", LastName = "Aquino", Email = "anthonyaquino@example.com", MobileNumber = "09190001234", TelephoneNumber = "(02) 8901 2345", Organization = "Apex Solutions", Address = "Pasay City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-010", FirstName = "Beatrice", LastName = "Flores", Email = "beatriceflores@example.com", MobileNumber = "09101112345", TelephoneNumber = "(02) 8012 3456", Organization = "Flores Healthcare", Address = "Paranaque City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-011", FirstName = "Carlos", LastName = "Villanueva", Email = "carlosvillanueva@example.com", MobileNumber = "09112233445", TelephoneNumber = "(02) 8123 5678", Organization = "Villanueva Construction", Address = "Las Pinas City", AccountStatus = "Inactive" },
                new CustomerRow { CustomerId = "CUSTOMER-012", FirstName = "Diana", LastName = "Castillo", Email = "dianacastillo@example.com", MobileNumber = "09123344556", TelephoneNumber = "(02) 8234 6789", Organization = "Castillo Legal Services", Address = "San Juan City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-013", FirstName = "Edward", LastName = "Ramos", Email = "edwardramos@example.com", MobileNumber = "09134455667", TelephoneNumber = "(02) 8345 7890", Organization = "Ramos Logistics", Address = "Valenzuela City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-014", FirstName = "Faith", LastName = "Torres", Email = "faithtorres@example.com", MobileNumber = "09145566778", TelephoneNumber = "(02) 8456 8901", Organization = "Torres Marketing", Address = "Muntinlupa City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-015", FirstName = "Gabriel", LastName = "Perez", Email = "gabrielperez@example.com", MobileNumber = "09156677889", TelephoneNumber = "(02) 8567 9012", Organization = "Perez Retail Group", Address = "Bacoor City", AccountStatus = "Active" },
                new CustomerRow { CustomerId = "CUSTOMER-016", FirstName = "Hannah", LastName = "Bautista", Email = "hannahbautista@example.com", MobileNumber = "09167788990", TelephoneNumber = "(02) 8678 0123", Organization = "Bautista Creative House", Address = "Antipolo City", AccountStatus = "Active" }
            };
        }

        public sealed class CustomerRow
        {
            public string CustomerId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string FullName { get { return FirstName + " " + LastName; } }
            public string Email { get; set; }
            public string MobileNumber { get; set; }
            public string TelephoneNumber { get; set; }
            public string Organization { get; set; }
            public string Address { get; set; }
            public string AccountStatus { get; set; }
        }
    }
}
