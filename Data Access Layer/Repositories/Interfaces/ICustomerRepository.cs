using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface ICustomerRepository
    {
        CustomerDto GetById(int customerId);
        CustomerDto GetByCode(string customerCode);
        int Create(CustomerDto customer);
        void Update(CustomerDto customer);
        IEnumerable<CustomerDto> Search(string keyword);
    }
}
