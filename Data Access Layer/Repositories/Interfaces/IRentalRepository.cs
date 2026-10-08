using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IRentalRepository
    {
        Guid CreateRental(RentalTransactionDto transaction);
        Guid CreateRental(RentalTransactionDto transaction, PaymentDto payment);
        IEnumerable<RentalTransactionDto> GetActiveRentals();
        IEnumerable<RentalTransactionDto> GetTransactionLog();
        IEnumerable<RentalTransactionDto> GetByCustomer(Guid userId);
        void CompleteRental(Guid transactionId, string returnConditionNotes);
        bool ArchiveRental(Guid transactionId);
        RentalTransactionDto GetById(Guid transactionId);
    }
}
