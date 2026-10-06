using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IEquipmentRepository
    {
        EquipmentDto GetById(int equipmentId);
        IEnumerable<EquipmentDto> Search(string keyword);
        bool IsSerialAvailable(string serialNumber);
    }
}
