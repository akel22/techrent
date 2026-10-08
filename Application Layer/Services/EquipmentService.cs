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
            try
            {
                var equipmentId = _repo.Create(equipment);
                AuditWorkflow.Success(_auditService, AuditEventFactory.InventoryCategory, "EquipmentCreated", "Equipment", equipmentId, "Equipment inventory was created.");
                return equipmentId;
            }
            catch (System.Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.InventoryCategory, "EquipmentCreated", "Equipment", null, "An equipment creation attempt failed.", ex);
                throw;
            }
        }

        public void Update(EquipmentDto equipment)
        {
            try
            {
                _repo.Update(equipment);
                AuditWorkflow.Success(_auditService, AuditEventFactory.InventoryCategory, "EquipmentUpdated", "Equipment", equipment.EquipmentId, "Equipment inventory was updated.");
            }
            catch (System.Exception ex)
            {
                AuditWorkflow.Failure(_auditService, AuditEventFactory.InventoryCategory, "EquipmentUpdated", "Equipment", equipment.EquipmentId, "An equipment update attempt failed.", ex);
                throw;
            }
        }

        public IEnumerable<EquipmentDto> Search(string keyword) => _repo.Search(keyword);

    }
}
