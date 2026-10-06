using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IRentalRepository
    {
        int CreateRental(RentalTransactionDto transaction);
        IEnumerable<RentalTransactionDto> GetActiveRentals();
        void CompleteRental(int rentalTransactionId);
        RentalTransactionDto GetById(int rentalTransactionId);
    }
}
