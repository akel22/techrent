using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class PaymentService
    {
        private readonly IPaymentRepository _repo;

        public PaymentService(IPaymentRepository repo)
        {
            _repo = repo;
        }

        public Guid Create(PaymentDto payment)
        {
            return _repo.Create(payment);
        }

        public IEnumerable<PaymentDto> GetByTransaction(Guid transactionId) => _repo.GetByTransaction(transactionId);

        public IEnumerable<PaymentDto> GetActivity() => _repo.GetActivity();

        public PagedResult<PaymentDto> GetActivityPaged(int pageNumber, int pageSize, string searchTerm, string sortDirection)
        {
            int total;
            var items = _repo.GetActivityPaged(pageNumber, pageSize, searchTerm, sortDirection, out total);
            return new PagedResult<PaymentDto>
            {
                Items = items,
                TotalCount = total
            };
        }
    }
}