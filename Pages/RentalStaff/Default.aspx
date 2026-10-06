<%@ Page Title="Rental Staff" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Techrent.Pages.RentalStaff.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.Home.css?v=2") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-home" aria-labelledby="welcomeHeading">
        <div class="rental-staff-home-card d-flex justify-content-center align-items-center flex-column">
            <h1 id="welcomeHeading" class="h4 mb-0">Good day, Rental Staff</h1>
            <p class="mb-4">Welcome back! Ready to create your rentals?</p>
            <div class="d-flex flex-column align-items-center gap-2">
                <a class="btn btn-success rental-staff-transaction-button" href="<%: GetRouteUrl("RentalStaffNew", null) %>">Create new transaction <span aria-hidden="true">&#43;</span></a>
                <a class="btn btn-outline-secondary rental-staff-transaction-button" href="<%: GetRouteUrl("RentalStaffActiveTransactions", null) %>">
                    <span class="rental-staff-view-icon" aria-hidden="true"><img src="<%: ResolveUrl("~/assets/svg/view.svg") %>" alt="" /></span>View active transactions</a>
            </div>
        </div>
    </section>
</asp:Content>
