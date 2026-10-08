using System;

namespace Techrent.ApplicationLayer.Services
{
    public static class AuditWorkflow
    {
        public static void Success(AuditService auditService, string category, string eventType, string recordType, Guid? recordId, string description)
        {
            var actor = AuthenticatedUserContext.Current;
            if (actor == null)
            {
                return;
            }

            TryInsert(auditService, AuditEventFactory.Success(actor.UserId, actor.ActorName, category, eventType, recordType, recordId, description));
        }

        public static void Failure(AuditService auditService, string category, string eventType, string recordType, Guid? recordId, string description, Exception exception)
        {
            var actor = AuthenticatedUserContext.Current;
            if (actor == null)
            {
                return;
            }

            TryInsert(auditService, AuditEventFactory.Failure(actor.UserId, actor.ActorName, category, eventType, recordType, recordId, description, exception));
        }

        private static void TryInsert(AuditService auditService, DataAccessLayer.DTOs.AuditRecordDto record)
        {
            try
            {
                auditService.Insert(record);
            }
            catch
            {
            }
        }
    }
}
