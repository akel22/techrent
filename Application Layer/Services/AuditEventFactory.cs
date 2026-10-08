using System;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.ApplicationLayer.Services
{
    public static class AuditEventFactory
    {
        public const string AccountCategory = "Account";
        public const string CustomerCategory = "Customer";
        public const string InventoryCategory = "Inventory";
        public const string RentalCategory = "Rental";
        public const string PaymentCategory = "Payment";

        public const string Succeeded = "Succeeded";
        public const string Failed = "Failed";

        public static AuditRecordDto Success(
            Guid actorId,
            string actorName,
            string category,
            string eventType,
            string affectedRecordType,
            Guid? affectedRecordId,
            string description)
        {
            return Create(
                actorId,
                actorName,
                category,
                eventType,
                Succeeded,
                affectedRecordType,
                affectedRecordId,
                description,
                null);
        }

        public static AuditRecordDto Failure(
            Guid actorId,
            string actorName,
            string category,
            string eventType,
            string affectedRecordType,
            Guid? affectedRecordId,
            string description,
            Exception exception)
        {
            return Create(
                actorId,
                actorName,
                category,
                eventType,
                Failed,
                affectedRecordType,
                affectedRecordId,
                description,
                SanitizeFailureDetail(exception));
        }

        private static AuditRecordDto Create(
            Guid actorId,
            string actorName,
            string category,
            string eventType,
            string outcome,
            string affectedRecordType,
            Guid? affectedRecordId,
            string description,
            string failureDetail)
        {
            return new AuditRecordDto
            {
                UserId = actorId,
                UserLogged = Limit(actorName, 100),
                Category = Limit(category, 30),
                EventType = Limit(eventType, 60),
                Outcome = Limit(outcome, 20),
                AffectedRecordType = Limit(affectedRecordType, 40),
                AffectedRecordId = affectedRecordId.HasValue ? affectedRecordId.Value.ToString() : null,
                Description = description,
                FailureDetail = failureDetail
            };
        }

        private static string SanitizeFailureDetail(Exception exception)
        {
            if (exception == null)
            {
                return null;
            }

            var detail = exception.GetBaseException().Message;
            return Limit(string.IsNullOrWhiteSpace(detail) ? "The operation failed." : detail, 1000);
        }

        private static string Limit(string value, int maxLength)
        {
            if (string.IsNullOrEmpty(value) || value.Length <= maxLength)
            {
                return value;
            }

            return value.Substring(0, maxLength);
        }
    }
}
