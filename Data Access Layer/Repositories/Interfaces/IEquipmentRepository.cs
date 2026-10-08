using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IEquipmentRepository
    {
        Guid Create(EquipmentDto equipment);
        void Update(EquipmentDto equipment);
        EquipmentDto GetById(Guid equipmentId);
        IEnumerable<EquipmentDto> Search(string keyword);
    }
}
