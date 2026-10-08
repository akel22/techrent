using System;
using System.Web;
using System.Web.Security;
using Techrent.ApplicationLayer.Services;

namespace Techrent
{
    public partial class Signin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void SignInButton_Click(object sender, EventArgs e)
        {
            SignInErrorLabel.Visible = false;

            var user = ServiceFactory.CreateAuthenticationService()
                .Authenticate(UsernameTextBox.Text, PasswordTextBox.Text);
            if (user == null)
            {
                SignInErrorLabel.Text = "The email or password is invalid.";
                SignInErrorLabel.Visible = true;
                return;
            }

            var ticket = new FormsAuthenticationTicket(
                2,
                user.Email,
                DateTime.Now,
                DateTime.Now.AddHours(8),
                false,
                user.UserId.ToString() + "|" + user.Role,
                FormsAuthentication.FormsCookiePath);
            var encryptedTicket = FormsAuthentication.Encrypt(ticket);
            Response.Cookies.Add(new System.Web.HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket));

            if (string.Equals(user.Role, "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect(ResolveUrl("~/dashboard"), false);
            }
            else if (string.Equals(user.Role, "RentalStaff", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect(ResolveUrl("~/"), false);
            }
            else
            {
                FormsAuthentication.SignOut();
                SignInErrorLabel.Text = "This account cannot access the staff application.";
                SignInErrorLabel.Visible = true;
            }

            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
