using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IAuditRepository
    {
        void Insert(AuditRecordDto record);
        IEnumerable<AuditRecordDto> QueryRecent(int maxRows);
    }
}
