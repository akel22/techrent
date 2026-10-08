using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IPaymentRepository
    {
        Guid Create(PaymentDto payment);
        IEnumerable<PaymentDto> GetByTransaction(Guid transactionId);
        IEnumerable<PaymentDto> GetActivity();
        IEnumerable<PaymentDto> GetActivityPaged(int pageNumber, int pageSize, string searchTerm, string sortDirection, out int totalCount);
    }
}