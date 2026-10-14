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

        public static AuditRecordDto Success(
            System.Guid actorId,
            string actorName,
            string category,
            string eventType,
            string description)
        {
            return new AuditRecordDto
            {
                UserId = actorId,
                UserLogged = Limit(actorName, 100),
                Category = Limit(category, 30),
                EventType = Limit(eventType, 60),
                Description = description
            };
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
