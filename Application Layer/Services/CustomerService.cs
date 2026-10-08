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
                AuditWorkflow.Success(_auditService, AuditEventFactory.CustomerCategory, "CustomerRegistered", "Customer", customerId, "A customer account was registered.");
                return customerId;
            }
            catch (Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.CustomerCategory, "CustomerRegistered", "Customer", customer.CustomerId == Guid.Empty ? (Guid?)null : customer.CustomerId, "A customer registration attempt failed.", ex);
                throw;
            }
        }

        public void UpdateCustomer(CustomerDto customer)
        {
            try
            {
                _repo.Update(customer);
                AuditWorkflow.Success(_auditService, AuditEventFactory.CustomerCategory, "CustomerUpdated", "Customer", customer.CustomerId, "A customer account was updated.");
            }
            catch (Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.CustomerCategory, "CustomerUpdated", "Customer", customer.CustomerId, "A customer update attempt failed.", ex);
                throw;
            }
        }

        public IEnumerable<CustomerDto> Search(string keyword) => _repo.Search(keyword);
    }
}
