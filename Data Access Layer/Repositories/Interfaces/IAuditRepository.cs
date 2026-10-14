using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.DataAccessLayer.Repositories.Interfaces
{
    public interface IAuditRepository
    {
        Guid Insert(AuditRecordDto record);
        IEnumerable<AuditRecordDto> QueryRecent(int maxRows);
        IEnumerable<AuditRecordDto> QueryFiltered(int page, int pageSize, DateTime? dateFrom, DateTime? dateTo, string category, string query, out int totalRows);
    }
}
