using System;
using System.Linq;
using Techrent.ApplicationLayer.Services;

namespace Techrent.Pages.RentalStaff
{
    public partial class Equipment : System.Web.UI.Page
    {
        protected string CustomerIdQuery
        {
            get { return Server.HtmlEncode(Request.QueryString["customerId"] ?? string.Empty); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EquipmentRepeater.DataSource = ServiceFactory.CreateEquipmentService().Search(null)
                    .Where(equipment => string.Equals(equipment.Status, "Available", StringComparison.OrdinalIgnoreCase) && equipment.Stock > 0)
                    .Select(equipment => new EquipmentRow
                    {
                        EquipmentId = equipment.EquipmentId,
                        Category = equipment.Category,
                        Type = equipment.Type,
                        Model = equipment.Model,
                        Sku = equipment.Sku,
                         Stock = equipment.Stock,
                         BaseRentalFee = equipment.BaseRentalFee,
                         SecurityDeposit = equipment.SecurityDeposit
                    }).ToList();
                EquipmentRepeater.DataBind();
            }
        }

        public sealed class EquipmentRow
        {
            public Guid EquipmentId { get; set; }
            public string Category { get; set; }
            public string Type { get; set; }
            public string Model { get; set; }
            public string Sku { get; set; }
            public int Stock { get; set; }
            public decimal BaseRentalFee { get; set; }
            public decimal SecurityDeposit { get; set; }
            public string SearchText { get { return string.Join(" ", Category, Type, Model, Sku); } }
        }
    }
}
