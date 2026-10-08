using System;
using System.Collections.Generic;
using Techrent.DataAccessLayer.DTOs;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    public class AuditService
    {
        private readonly IAuditRepository _repo;

        public AuditService(IAuditRepository repo)
        {
            _repo = repo;
        }

        public Guid Insert(AuditRecordDto record) => _repo.Insert(record);

        public IEnumerable<AuditRecordDto> GetRecent(int maxRows) => _repo.QueryRecent(maxRows);
    }
}
