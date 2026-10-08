using System;
using System.Collections.Generic;
using System.Linq;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class RentalService
    {
        private readonly IRentalRepository _repo;
        private readonly AuditService _auditService;

        public RentalService(IRentalRepository repo, AuditService auditService)
        {
            _repo = repo;
            _auditService = auditService;
        }

        public Guid CreateRental(RentalTransactionDto tx)
        {
            try
            {
                var transactionId = _repo.CreateRental(tx);
                AuditWorkflow.Success(_auditService, AuditEventFactory.RentalCategory, "RentalCreated", "Transaction", transactionId, "A rental transaction was created.");
                return transactionId;
            }
            catch (Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.RentalCategory, "RentalCreated", "Transaction", null, "A rental creation attempt failed.", ex);
                throw;
            }
        }

        public Guid CreateRental(RentalTransactionDto tx, PaymentDto payment)
        {
            try
            {
                var transactionId = _repo.CreateRental(tx, payment);
                AuditWorkflow.Success(_auditService, AuditEventFactory.RentalCategory, "RentalCreated", "Transaction", transactionId, "A rental transaction and initial payment were created.");
                return transactionId;
            }
            catch (Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.RentalCategory, "RentalCreated", "Transaction", null, "A rental creation attempt failed.", ex);
                throw;
            }
        }

        public IEnumerable<RentalTransactionDto> GetActiveRentals() => _repo.GetActiveRentals();

        public IEnumerable<RentalTransactionDto> GetTransactionLog() => _repo.GetTransactionLog();

        public IEnumerable<RentalTransactionDto> GetByCustomer(Guid userId) => _repo.GetByCustomer(userId);

        public void CompleteRental(Guid rentalId, string returnConditionNotes)
        {
            CompleteRental(rentalId, returnConditionNotes, Enumerable.Empty<AdditionalChargeDto>());
        }

        public void CompleteRental(Guid rentalId, string returnConditionNotes, IEnumerable<AdditionalChargeDto> additionalCharges)
        {
            var notes = string.IsNullOrWhiteSpace(returnConditionNotes) ? null : returnConditionNotes.Trim();
            if (notes != null && notes.Length > 500)
            {
                throw new ArgumentException("Return condition notes cannot exceed 500 characters.", nameof(returnConditionNotes));
            }

            var charges = (additionalCharges ?? Enumerable.Empty<AdditionalChargeDto>()).ToList();
            foreach (var charge in charges)
            {
                if (charge == null)
                {
                    throw new ArgumentException("Additional charges cannot contain empty entries.", nameof(additionalCharges));
                }

                if (charge.PaymentType != "LateFee" && charge.PaymentType != "DamageCharge")
                {
                    throw new ArgumentException("Additional charges must be LateFee or DamageCharge.", nameof(additionalCharges));
                }

                if (charge.PaymentMethod != "Cash" && charge.PaymentMethod != "GCash")
                {
                    throw new ArgumentException("Additional charges must use Cash or GCash.", nameof(additionalCharges));
                }

                if (charge.Amount < 0 || charge.Amount > 9999999999999999.99m || decimal.Round(charge.Amount, 2) != charge.Amount)
                {
                    throw new ArgumentException("Additional charge amounts must be non-negative values with up to two decimal places.", nameof(additionalCharges));
                }
            }

            try
            {
                _repo.CompleteRental(rentalId, notes, charges);
                AuditWorkflow.Success(_auditService, AuditEventFactory.RentalCategory, "RentalCompleted", "Transaction", rentalId, "A rental transaction was completed.");
            }
            catch (Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.RentalCategory, "RentalCompleted", "Transaction", rentalId, "A rental completion attempt failed.", ex);
                throw;
            }
        }

        public bool ArchiveRental(Guid rentalId)
        {
            try
            {
                var archived = _repo.ArchiveRental(rentalId);
                if (archived)
                {
                    AuditWorkflow.Success(_auditService, AuditEventFactory.RentalCategory, "RentalArchived", "Transaction", rentalId, "A rental transaction was archived.");
                }
                else
                {
                    AuditWorkflow.Failure(_auditService, AuditEventFactory.RentalCategory, "RentalArchived", "Transaction", rentalId, "A rental archive attempt did not change the transaction.", null);
                }

                return archived;
            }
            catch (Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.RentalCategory, "RentalArchived", "Transaction", rentalId, "A rental archive attempt failed.", ex);
                throw;
            }
        }

        public RentalTransactionDto GetById(Guid rentalId) => _repo.GetById(rentalId);
    }
}
