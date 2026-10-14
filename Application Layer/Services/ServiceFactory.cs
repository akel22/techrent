using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.Repositories;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    // Simple factory to create service instances without an external DI container.
    public static class ServiceFactory
    {
        public static AuthenticationService CreateAuthenticationService()
        {
            IAuthenticationRepository repo = new AuthenticationRepository();
            IAuditRepository auditRepo = new AuditRepository();
            return new AuthenticationService(repo, auditRepo);
        }

        public static AuthenticatedUserRegistrationService CreateAuthenticatedUserRegistrationService()
        {
            return new AuthenticatedUserRegistrationService(new AuthenticationRepository());
        }

        public static CustomerService CreateCustomerService()
        {
            ICustomerRepository repo = new CustomerRepository();
            return new CustomerService(repo, CreateAuditService());
        }

        public static EquipmentService CreateEquipmentService()
        {
            IEquipmentRepository repo = new EquipmentRepository();
            return new EquipmentService(repo, CreateAuditService());
        }

        public static RentalService CreateRentalService()
        {
            IRentalRepository repo = new RentalRepository();
            return new RentalService(repo, CreateAuditService());
        }

        public static AuditService CreateAuditService()
        {
            IAuditRepository repo = new AuditRepository();
            return new AuditService(repo);
        }

        public static PaymentService CreatePaymentService()
        {
            IPaymentRepository repo = new PaymentRepository();
            return new PaymentService(repo);
        }
    }
}
