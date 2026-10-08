using System;
using System.Web;
using System.Web.Security;

namespace Techrent.ApplicationLayer.Services
{
    public sealed class AuthenticatedUserContext
    {
        private const string ContextItemKey = "Techrent.AuthenticatedUserContext";

        private AuthenticatedUserContext(Guid userId, string actorName, string role)
        {
            UserId = userId;
            ActorName = actorName;
            Role = role;
        }

        public Guid UserId { get; private set; }
        public string ActorName { get; private set; }
        public string Role { get; private set; }

        public bool IsAdmin
        {
            get { return string.Equals(Role, "Admin", StringComparison.OrdinalIgnoreCase); }
        }

        public bool IsRentalStaff
        {
            get { return string.Equals(Role, "RentalStaff", StringComparison.OrdinalIgnoreCase); }
        }

        public static AuthenticatedUserContext Current
        {
            get
            {
                var context = HttpContext.Current;
                var validatedContext = context == null ? null : context.Items[ContextItemKey] as AuthenticatedUserContext;
                if (validatedContext != null)
                {
                    return validatedContext;
                }
                return null;
            }
        }

        public static bool TryReadTicket(FormsAuthenticationTicket ticket, out Guid userId, out string role)
        {
            userId = Guid.Empty;
            role = null;
            if (ticket == null)
            {
                return false;
            }

            var values = (ticket.UserData ?? string.Empty).Split('|');
            if (values.Length != 2 || !Guid.TryParse(values[0], out userId) || string.IsNullOrWhiteSpace(values[1]))
            {
                userId = Guid.Empty;
                return false;
            }

            role = values[1];
            return true;
        }

        public static void SetCurrent(AuthenticatedUserContext user)
        {
            var context = HttpContext.Current;
            if (context != null)
            {
                context.Items[ContextItemKey] = user;
            }
        }

        public static AuthenticatedUserContext Create(Guid userId, string actorName, string role)
        {
            return new AuthenticatedUserContext(userId, actorName, role);
        }
    }
}
