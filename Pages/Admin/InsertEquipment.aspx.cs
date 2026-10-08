using System;
using System.Globalization;
using Techrent.ApplicationLayer.Services;
using Techrent.DataAccessLayer.DTOs;

namespace Techrent.Pages.Admin
{
    public partial class InsertEquipment : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void SaveEquipmentButton_ServerClick(object sender, EventArgs e)
        {
            int stock;
            decimal baseRentalFee;
            decimal securityDeposit;
            if (!int.TryParse(equipmentStock.Value, out stock) || stock < 0 ||
                !decimal.TryParse(equipmentBaseRentalFee.Value, NumberStyles.Number, CultureInfo.InvariantCulture, out baseRentalFee) || baseRentalFee < 0 ||
                !decimal.TryParse(equipmentSecurityDeposit.Value, NumberStyles.Number, CultureInfo.InvariantCulture, out securityDeposit) || securityDeposit < 0 ||
                string.IsNullOrWhiteSpace(equipmentCategory.Value) ||
                string.IsNullOrWhiteSpace(equipmentType.Value) ||
                string.IsNullOrWhiteSpace(equipmentStatus.Value) ||
                string.IsNullOrWhiteSpace(equipmentModel.Value) ||
                string.IsNullOrWhiteSpace(equipmentSku.Value))
            {
                ShowMessage("Complete all equipment fields with valid values.", false);
                return;
            }

            byte[] image = null;
            if (equipmentImage.PostedFile != null && equipmentImage.PostedFile.ContentLength > 0)
            {
                image = new byte[equipmentImage.PostedFile.ContentLength];
                equipmentImage.PostedFile.InputStream.Read(image, 0, image.Length);
            }

            try
            {
                ServiceFactory.CreateEquipmentService().Create(new EquipmentDto
                {
                    Category = equipmentCategory.Value,
                    Type = equipmentType.Value,
                    Status = equipmentStatus.Value,
                    Model = equipmentModel.Value.Trim(),
                    Sku = equipmentSku.Value.Trim(),
                    Stock = stock,
                    BaseRentalFee = baseRentalFee,
                    SecurityDeposit = securityDeposit,
                    Image = image
                });
                ShowMessage("Equipment saved successfully.", true);
            }
            catch (Exception ex)
            {
                ShowMessage(ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool success)
        {
            equipmentFormAlert.InnerText = message;
            equipmentFormAlert.Attributes["class"] = success
                ? "alert alert-success"
                : "alert alert-danger";
        }
    }
}
