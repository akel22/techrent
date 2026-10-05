<%@ Page Title="Rental Staff" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Techrent.Pages.RentalStaff.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.Home.css?v=2") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-home" aria-labelledby="welcomeHeading">
        <div class="rental-staff-home-card">
            <h1 id="welcomeHeading" class="h4 mb-0">Good day, Rental Staff</h1>
            <p class="mb-4">Welcome back! Ready to create your rentals?</p>
            <a class="btn btn-success rental-staff-transaction-button" href="<%: GetRouteUrl("RentalStaffNew", null) %>">Create new transaction <span aria-hidden="true">&#43;</span></a>
        </div>
    </section>
</asp:Content>
