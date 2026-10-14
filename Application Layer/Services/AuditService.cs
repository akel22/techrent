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

        public PagedAuditResult GetPage(int page, int pageSize, DateTime? dateFrom, DateTime? dateTo, string category, string query)
        {
            int total;
            var rows = _repo.QueryFiltered(page, pageSize, dateFrom, dateTo, category, query, out total);
            return new PagedAuditResult
            {
                Records = rows,
                TotalRows = total
            };
        }

        public sealed class PagedAuditResult
        {
            public IEnumerable<AuditRecordDto> Records { get; set; }
            public int TotalRows { get; set; }
        }
    }
}
