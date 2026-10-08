using System;

namespace Techrent.DataAccessLayer.DTOs
{
    public class AdditionalChargeDto
    {
        public string PaymentType { get; set; }
        public decimal Amount { get; set; }
        public string PaymentMethod { get; set; }
    }
}
