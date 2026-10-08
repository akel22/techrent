using System;
using System.Collections.Generic;
using System.Linq;

namespace Techrent.Application.Services
{
    public static class DamageChargeCalculator
    {
        private static readonly IReadOnlyList<DamageChargeRule> Rules = new List<DamageChargeRule>
        {
            new DamageChargeRule("Obsolete", "Cosmetic damage", 0.10m, "Minor appearance issue that does not affect operation."),
            new DamageChargeRule("Obsolete", "Functional damage", 0.25m, "The equipment operates with a performance or feature issue."),
            new DamageChargeRule("Obsolete", "Beyond repair / lost", 0.50m, "The unit cannot be returned to service or was not returned."),
            new DamageChargeRule("Standard", "Cosmetic damage", 0.15m, "Minor appearance issue that does not affect operation."),
            new DamageChargeRule("Standard", "Functional damage", 0.40m, "The equipment operates with a performance or feature issue."),
            new DamageChargeRule("Standard", "Beyond repair / lost", 0.75m, "The unit cannot be returned to service or was not returned."),
            new DamageChargeRule("Professional", "Cosmetic damage", 0.20m, "Minor appearance issue that does not affect operation."),
            new DamageChargeRule("Professional", "Functional damage", 0.60m, "The equipment operates with a performance or feature issue."),
            new DamageChargeRule("Professional", "Beyond repair / lost", 1.00m, "The unit cannot be returned to service or was not returned.")
        };

        public static IReadOnlyList<DamageChargeRule> GetRules()
        {
            return Rules;
        }

        public static bool TryCalculate(string equipmentType, string damageCondition, decimal securityDeposit, out DamageChargeResult result)
        {
            result = null;

            if (securityDeposit < 0)
            {
                return false;
            }

            DamageChargeRule rule = Rules.FirstOrDefault(item =>
                string.Equals(item.EquipmentType, equipmentType, StringComparison.OrdinalIgnoreCase) &&
                string.Equals(item.DamageCondition, damageCondition, StringComparison.OrdinalIgnoreCase));

            if (rule == null)
            {
                return false;
            }

            result = new DamageChargeResult(
                rule.EquipmentType,
                rule.DamageCondition,
                rule.Percentage,
                securityDeposit,
                decimal.Round(securityDeposit * rule.Percentage, 2, MidpointRounding.AwayFromZero));
            return true;
        }
    }

    public sealed class DamageChargeRule
    {
        public DamageChargeRule(string equipmentType, string damageCondition, decimal percentage, string conditionDescription)
        {
            EquipmentType = equipmentType;
            DamageCondition = damageCondition;
            Percentage = percentage;
            ConditionDescription = conditionDescription;
        }

        public string EquipmentType { get; private set; }
        public string DamageCondition { get; private set; }
        public decimal Percentage { get; private set; }
        public string ConditionDescription { get; private set; }
        public string PercentageLabel { get { return Percentage.ToString("P0"); } }
    }

    public sealed class DamageChargeResult
    {
        public DamageChargeResult(string equipmentType, string damageCondition, decimal percentage, decimal securityDeposit, decimal charge)
        {
            EquipmentType = equipmentType;
            DamageCondition = damageCondition;
            Percentage = percentage;
            SecurityDeposit = securityDeposit;
            Charge = charge;
        }

        public string EquipmentType { get; private set; }
        public string DamageCondition { get; private set; }
        public decimal Percentage { get; private set; }
        public decimal SecurityDeposit { get; private set; }
        public decimal Charge { get; private set; }
    }
}
