using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class EquipmentService
    {
        private readonly IEquipmentRepository _repo;
        private readonly AuditService _auditService;

        public EquipmentService(IEquipmentRepository repo, AuditService auditService)
        {
            _repo = repo;
            _auditService = auditService;
        }

        public EquipmentDto GetById(System.Guid id) => _repo.GetById(id);

        public System.Guid Create(EquipmentDto equipment)
        {
            return _repo.Create(equipment);
        }

        public void Update(EquipmentDto equipment)
        {
            _repo.Update(equipment);
        }

        public bool Delete(System.Guid equipmentId)
        {
            var deleted = _repo.Delete(equipmentId);
            if (deleted)
            {
                AuditWorkflow.Success(_auditService, AuditEventFactory.InventoryCategory, "RecordDeleted", "An equipment record was deleted: " + equipmentId + ".");
            }

            return deleted;
        }

        public IEnumerable<EquipmentDto> Search(string keyword) => _repo.Search(keyword);

    }
}
