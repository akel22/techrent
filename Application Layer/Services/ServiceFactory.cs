using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.Repositories;
using Techrent.DataAccessLayer.Repositories.Interfaces;

namespace Techrent.ApplicationLayer.Services
{
    // Simple factory to create service instances without an external DI container.
    public static class ServiceFactory
    {
        public static CustomerService CreateCustomerService()
        {
            ICustomerRepository repo = new CustomerRepository();
            return new CustomerService(repo);
        }

        public static EquipmentService CreateEquipmentService()
        {
            IEquipmentRepository repo = new EquipmentRepository();
            return new EquipmentService(repo);
        }

        public static RentalService CreateRentalService()
        {
            IRentalRepository repo = new RentalRepository();
            return new RentalService(repo);
        }

        public static AuditService CreateAuditService()
        {
            IAuditRepository repo = new AuditRepository();
            return new AuditService(repo);
        }
    }
}
