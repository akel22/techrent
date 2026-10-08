<%@ Page Title="Sign in" Language="C#" AutoEventWireup="true" CodeBehind="Signin.aspx.cs" Inherits="Techrent.Signin" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Sign in - TECHRENT</title>
    <link href="<%: ResolveUrl("~/Content/bootstrap.min.css") %>" rel="stylesheet" />
    <link href="<%: ResolveUrl("~/Content/Site.css") %>" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="signinForm" runat="server" class="min-vh-100 d-flex align-items-center justify-content-center p-3">
        <div class="row justify-content-center w-100">
            <div class="col-12 col-sm-10 col-md-7 col-lg-5 col-xl-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <h1 class="h4 mb-1">TECH<span class ="text text-danger">RENT</span></h1>
                        </div>

                    <div class="mb-3">
                        <asp:Label ID="UsernameLabel" runat="server" AssociatedControlID="UsernameTextBox" CssClass="form-label">Email</asp:Label>
                        <asp:TextBox ID="UsernameTextBox" runat="server" CssClass="form-control w-100" MaxLength="32" placeholder="Enter your email" autocomplete="username" style="max-width: none;"></asp:TextBox>
                    </div>

                    <div class="mb-4">
                        <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="PasswordTextBox" CssClass="form-label">Password</asp:Label>
                        <asp:TextBox ID="PasswordTextBox" runat="server" CssClass="form-control w-100" TextMode="Password" MaxLength="128" placeholder="Enter your password" autocomplete="current-password" style="max-width: none;"></asp:TextBox>
                    </div>

                    <asp:Label ID="SignInErrorLabel" runat="server" CssClass="text-danger small d-block mb-3" Visible="false" />
                      
                        <div class="d-flex justify-content-center">
                            <asp:Button ID="SignInButton" runat="server" Text="Sign in" CssClass="btn btn-dark w-100" OnClick="SignInButton_Click" />
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
