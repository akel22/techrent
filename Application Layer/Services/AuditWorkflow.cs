using System;

namespace Techrent.ApplicationLayer.Services
{
    public static class AuditWorkflow
    {
        public static void Success(AuditService auditService, string category, string eventType, string description)
        {
            var actor = AuthenticatedUserContext.Current;
            if (actor == null)
            {
                return;
            }

            TryInsert(auditService, AuditEventFactory.Success(actor.UserId, actor.ActorName, category, eventType, description));
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
