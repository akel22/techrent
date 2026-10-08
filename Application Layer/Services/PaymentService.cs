using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class PaymentService
    {
        private readonly IPaymentRepository _repo;
        private readonly AuditService _auditService;

        public PaymentService(IPaymentRepository repo, AuditService auditService)
        {
            _repo = repo;
            _auditService = auditService;
        }

        public Guid Create(PaymentDto payment)
        {
            try
            {
                var paymentId = _repo.Create(payment);
                AuditWorkflow.Success(_auditService, AuditEventFactory.PaymentCategory, "PaymentCreated", "Payment", paymentId, "A payment was recorded.");
                return paymentId;
            }
            catch (Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.PaymentCategory, "PaymentCreated", "Payment", payment.PaymentId == Guid.Empty ? (Guid?)null : payment.PaymentId, "A payment creation attempt failed.", ex);
                throw;
            }
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