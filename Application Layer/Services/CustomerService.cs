using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class CustomerService
    {
        private readonly ICustomerRepository _repo;

        public CustomerService(ICustomerRepository repo)
        {
            _repo = repo;
        }

        public CustomerDto GetCustomerById(int id) => _repo.GetById(id);

        public CustomerDto GetCustomerByCode(string code) => _repo.GetByCode(code);

        public int RegisterCustomer(CustomerDto customer) => _repo.Create(customer);

        public void UpdateCustomer(CustomerDto customer) => _repo.Update(customer);

        public IEnumerable<CustomerDto> Search(string keyword) => _repo.Search(keyword);
    }
}
