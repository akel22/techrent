using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class CustomerService
    {
        private readonly ICustomerRepository _repo;
        private readonly AuditService _auditService;

        public CustomerService(ICustomerRepository repo, AuditService auditService)
        {
            _repo = repo;
            _auditService = auditService;
        }

        public CustomerDto GetCustomerById(Guid id) => _repo.GetById(id);

        public Guid RegisterCustomer(CustomerDto customer)
        {
            try
            {
                var customerId = _repo.Create(customer);
                AuditWorkflow.Success(_auditService, AuditEventFactory.CustomerCategory, "CustomerRegistered", "A customer account was registered.");
                return customerId;
            }
            catch
            {
                throw;
            }
        }

        public void UpdateCustomer(CustomerDto customer)
        {
            _repo.Update(customer);
        }

        public void DeleteCustomer(Guid customerId)
        {
            _repo.Delete(customerId);
            AuditWorkflow.Success(_auditService, AuditEventFactory.CustomerCategory, "RecordDeleted", "A customer record was deleted: " + customerId + ".");
        }

        public IEnumerable<CustomerDto> Search(string keyword) => _repo.Search(keyword);
    }
}
