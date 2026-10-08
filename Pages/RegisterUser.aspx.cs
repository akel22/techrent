using System;
using System.Data.SqlClient;
using Techrent.ApplicationLayer.Services;

namespace Techrent
{
    public partial class RegisterUser : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RegistrationMessageLabel.Visible = false;
            }
        }

        protected void RegisterButton_Click(object sender, EventArgs e)
        {
            RegistrationMessageLabel.Visible = true;
            RegistrationMessageLabel.CssClass = "text-danger small d-block mb-3";

            if (!string.Equals(PasswordTextBox.Text, ConfirmPasswordTextBox.Text, StringComparison.Ordinal))
            {
                RegistrationMessageLabel.Text = "The passwords do not match.";
                return;
            }

            try
            {
                var service = ServiceFactory.CreateAuthenticatedUserRegistrationService();
                service.Register(FirstNameTextBox.Text, LastNameTextBox.Text, EmailTextBox.Text, RoleDropDown.SelectedValue, PasswordTextBox.Text);
                RegistrationMessageLabel.CssClass = "text-success small d-block mb-3";
                RegistrationMessageLabel.Text = "User registered. You can now sign in.";
                RegisterButton.Enabled = false;
            }
            catch (SqlException ex) when (ex.Number == 2601 || ex.Number == 2627)
            {
                RegistrationMessageLabel.Text = "That email address is already registered.";
            }
            catch (Exception ex)
            {
                RegistrationMessageLabel.Text = ex.Message.Contains("Only an authenticated administrator")
                    ? ex.Message
                    : "The user could not be registered.";
            }
        }
    }
}
