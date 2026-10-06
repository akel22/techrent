<%@ Page Title="Active Transactions" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="ActiveTransactions.aspx.cs" Inherits="Techrent.Pages.RentalStaff.ActiveTransactions" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.ActiveTransactions.css?v=3") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-active-transactions" aria-labelledby="activeTransactionsHeading">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <h1 id="activeTransactionsHeading" class="h3 mb-2">Active transactions</h1>
                <p class="text-muted mb-0">Review ongoing rentals and mark them done when equipment is returned.</p>
            </div>
                <a class="btn btn-outline-secondary rental-staff-back-button" href="<%: GetRouteUrl("RentalStaff", null) %>">
                    <span class="rental-staff-back-icon" aria-hidden="true"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" width="16" height="16" /></span>Back to home</a>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-3 p-md-4">
                <div class="d-flex justify-content-between align-items-center gap-3 mb-3">
                    <h2 class="h5 mb-0">Ongoing rentals</h2>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0 rental-staff-active-table">
                        <caption class="visually-hidden">Active rental transactions</caption>
                        <thead>
                            <tr>
                                <th scope="col">Transaction</th>
                                <th scope="col">Customer</th>
                                <th scope="col">Due date</th>
                                <th scope="col" class="status-column-heading">Status</th>
                                <th scope="col" class="text-md-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr data-transaction-row>
                                <th scope="row"><span class="d-block">TRX-2026-001</span></th>
                                <td><span class="d-block">Maria Santos</span><span class="small text-muted">CUS-1001</span></td>
                                <td>18 May 2026</td>
                                <td><span class="transaction-status" data-transaction-status>Ongoing</span></td>
                                <td class="text-md-end"><button type="button" class="btn btn-success btn-sm mark-done-button" data-mark-done><span class="mark-done-icon" aria-hidden="true"><img src="<%: ResolveUrl("~/assets/svg/check.svg") %>" alt="" width="16" height="16" /></span>Mark as done</button></td>
                            </tr>
                            <tr data-transaction-row>
                                <th scope="row"><span class="d-block">TRX-2026-002</span></th>
                                <td><span class="d-block">John Dela Cruz</span><span class="small text-muted">CUS-1002</span></td>
                                <td>20 May 2026</td>
                                <td><span class="transaction-status" data-transaction-status>Ongoing</span></td>
                                <td class="text-md-end"><button type="button" class="btn btn-success btn-sm mark-done-button" data-mark-done>Mark as done</button></td>
                            </tr>
                            <tr data-transaction-row>
                                <th scope="row"><span class="d-block">TRX-2026-003</span></th>
                                <td><span class="d-block">Ana Reyes</span><span class="small text-muted">CUS-1003</span></td>
                                <td>22 May 2026</td>
                                <td><span class="transaction-status" data-transaction-status>Ongoing</span></td>
                                <td class="text-md-end"><button type="button" class="btn btn-success btn-sm mark-done-button" data-mark-done>Mark as done</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <p class="small text-muted mt-3 mb-0">Transaction updates are for this browser session only and are not saved to a database.</p>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/rentalstaff/ActiveTransactions.js?v=1") %>"></script>
</asp:Content>
