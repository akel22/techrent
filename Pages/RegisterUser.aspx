<%@ Page Title="Register user" Language="C#" AutoEventWireup="true" CodeBehind="RegisterUser.aspx.cs" Inherits="Techrent.RegisterUser" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Register user - TECHRENT</title>
    <link href="<%: ResolveUrl("~/Content/bootstrap.min.css") %>" rel="stylesheet" />
    <link href="<%: ResolveUrl("~/Content/Site.css") %>" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="registrationForm" runat="server" class="min-vh-100 d-flex align-items-center justify-content-center p-3">
        <div class="col-12 col-sm-10 col-md-7 col-lg-5 col-xl-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body p-4">
                    <h1 class="h4 mb-4">Register authenticated user</h1>
                    <asp:Label ID="RegistrationMessageLabel" runat="server" CssClass="small d-block mb-3" />
                    <div class="mb-3">
                        <asp:Label ID="FirstNameLabel" runat="server" AssociatedControlID="FirstNameTextBox" CssClass="form-label">First name</asp:Label>
                        <asp:TextBox ID="FirstNameTextBox" runat="server" CssClass="form-control" MaxLength="24" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="LastNameLabel" runat="server" AssociatedControlID="LastNameTextBox" CssClass="form-label">Last name</asp:Label>
                        <asp:TextBox ID="LastNameTextBox" runat="server" CssClass="form-control" MaxLength="24" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="EmailTextBox" CssClass="form-label">Email</asp:Label>
                        <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" TextMode="Email" MaxLength="32" />
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="RoleLabel" runat="server" AssociatedControlID="RoleDropDown" CssClass="form-label">Role</asp:Label>
                        <asp:DropDownList ID="RoleDropDown" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Rental Staff" Value="RentalStaff" />
                            <asp:ListItem Text="Administrator" Value="Admin" />
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="PasswordTextBox" CssClass="form-label">Password</asp:Label>
                        <asp:TextBox ID="PasswordTextBox" runat="server" CssClass="form-control" TextMode="Password" MaxLength="128" />
                    </div>
                    <div class="mb-4">
                        <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPasswordTextBox" CssClass="form-label">Confirm password</asp:Label>
                        <asp:TextBox ID="ConfirmPasswordTextBox" runat="server" CssClass="form-control" TextMode="Password" MaxLength="128" />
                    </div>
                    <asp:Button ID="RegisterButton" runat="server" Text="Register user" CssClass="btn btn-dark w-100" OnClick="RegisterButton_Click" />
                    <a class="btn btn-link w-100 mt-2" href="<%: ResolveUrl("~/signin") %>">Back to sign in</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
