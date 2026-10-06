using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class RentalService
    {
        private readonly IRentalRepository _repo;

        public RentalService(IRentalRepository repo)
        {
            _repo = repo;
        }

        public int CreateRental(RentalTransactionDto tx) => _repo.CreateRental(tx);

        public IEnumerable<RentalTransactionDto> GetActiveRentals() => _repo.GetActiveRentals();

        public void CompleteRental(int rentalId) => _repo.CompleteRental(rentalId);

        public RentalTransactionDto GetById(int rentalId) => _repo.GetById(rentalId);
    }
}
