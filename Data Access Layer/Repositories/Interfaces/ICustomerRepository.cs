using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface ICustomerRepository
    {
        CustomerDto GetById(Guid userId);
        CustomerDto GetByEmail(string email);
        Guid Create(CustomerDto customer);
        void Update(CustomerDto customer);
        IEnumerable<CustomerDto> Search(string keyword);
    }
}
