using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class AuditRecordDto
    {
        public Guid LogId { get; set; }
        public Guid UserId { get; set; }
        public string UserLogged { get; set; }
        public string UserRole { get; set; }
        public DateTime LoggedAt { get; set; }
        public string Category { get; set; }
        public string EventType { get; set; }
        public string Description { get; set; }
    }
}
