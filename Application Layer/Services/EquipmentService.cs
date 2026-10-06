using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class EquipmentService
    {
        private readonly IEquipmentRepository _repo;

        public EquipmentService(IEquipmentRepository repo)
        {
            _repo = repo;
        }

        public EquipmentDto GetById(int id) => _repo.GetById(id);

        public IEnumerable<EquipmentDto> Search(string keyword) => _repo.Search(keyword);

        public bool IsSerialAvailable(string serial) => _repo.IsSerialAvailable(serial);
    }
}
