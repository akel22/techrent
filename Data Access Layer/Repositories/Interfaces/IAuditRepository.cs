using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IAuditRepository
    {
        Guid Insert(AuditRecordDto record);
        IEnumerable<AuditRecordDto> QueryRecent(int maxRows);
    }
}
