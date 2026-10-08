using System;
using System.Collections.Generic;
using System.Linq;
using Techrent.Application.Services;

namespace Techrent.Pages.Admin
{
    public partial class DamageChargeGuidelines : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindRules();
            }
        }

        private void BindRules()
        {
            List<DamageChargeRule> rules = DamageChargeCalculator.GetRules().ToList();

            DamageChargeRulesRepeater.DataSource = rules
                .GroupBy(rule => rule.EquipmentType)
                .Select(group => new
                {
                    EquipmentType = group.Key,
                    CosmeticDamagePercentage = GetPercentage(group, "Cosmetic damage"),
                    FunctionalDamagePercentage = GetPercentage(group, "Functional damage"),
                    BeyondRepairPercentage = GetPercentage(group, "Beyond repair / lost")
                })
                .ToList();
            DamageChargeRulesRepeater.DataBind();

            ConditionRulesRepeater.DataSource = rules
                .GroupBy(rule => new { rule.DamageCondition, rule.ConditionDescription })
                .Select(group => group.Key)
                .ToList();
            ConditionRulesRepeater.DataBind();
        }

        private static string GetPercentage(IEnumerable<DamageChargeRule> rules, string damageCondition)
        {
            DamageChargeRule rule = rules.First(item => string.Equals(item.DamageCondition, damageCondition, StringComparison.OrdinalIgnoreCase));
            return rule.PercentageLabel;
        }
    }
}
