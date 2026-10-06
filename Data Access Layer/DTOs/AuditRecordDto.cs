using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class AuditRecordDto
    {
        public int AuditId { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public string PerformedBy { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
