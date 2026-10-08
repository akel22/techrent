<%@ Page Title="Active Transactions" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="ActiveTransactions.aspx.cs" Inherits="Techrent.Pages.RentalStaff.ActiveTransactions" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.ActiveTransactions.css?v=5") %>" rel="stylesheet" />
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
                </div>
                <div class="table-responsive">
                    <table class="table align-middle mb-0 rental-staff-active-table">
                        <caption class="visually-hidden">Ongoing rental transactions</caption>
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
                             <asp:Repeater ID="ActiveTransactionsRepeater" runat="server">
                                <ItemTemplate>
                                    <tr data-transaction-row data-transaction-code="<%#: Eval("TransactionId") %>" data-customer-name="<%#: Eval("CustomerName") %>" data-customer-id="<%#: Eval("CustomerId") %>" data-due-date="<%#: Eval("DueDate") %>">
                                        <th scope="row"><span class="d-block"><%#: Eval("TransactionId") %></span></th>
                                        <td><span class="d-block"><%#: Eval("CustomerName") %></span><span class="small text-muted"><%#: Eval("CustomerId") %></span></td>
                                        <td><%#: Eval("DueDate") %></td>
                                        <td><span class="transaction-status" data-transaction-status><%#: Eval("Status") %></span></td>
                                         <td class="text-md-end"><button type="button" class="btn btn-outline-secondary btn-sm mark-done-button" data-mark-done>Mark as done</button></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <p class="small text-muted mt-3 mb-0 text-center">Completed transactions are saved to the database.</p>
            </div>
        </div>
    </section>

    <div class="modal fade" id="markDoneModal" tabindex="-1" aria-labelledby="markDoneModalLabel" aria-hidden="true">
        <asp:HiddenField ID="SelectedTransactionIdHidden" runat="server" ClientIDMode="Static" />
        <asp:HiddenField ID="ReturnConditionNotesHidden" runat="server" ClientIDMode="Static" />
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="markDoneModalLabel">Complete transaction</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-3 alert alert-warning">Review the transaction details before marking the rental as done.</p>
                    <div class="row g-4 align-items-start">
                        <dl class="col-lg-5 row mb-0 rental-transaction-details">
                            <dt class="col-sm-5 col-lg-12">Transaction</dt>
                            <dd class="col-sm-7 col-lg-12" data-modal-transaction></dd>
                            <dt class="col-sm-5 col-lg-12">Customer</dt>
                            <dd class="col-sm-7 col-lg-12" data-modal-customer></dd>
                            <dt class="col-sm-5 col-lg-12">Customer ID</dt>
                            <dd class="col-sm-7 col-lg-12" data-modal-customer-id></dd>
                            <dt class="col-sm-5 col-lg-12">Due date</dt>
                            <dd class="col-sm-7 col-lg-12" data-modal-due-date></dd>
                            <dt class="col-sm-5 col-lg-12">Current status</dt>
                            <dd class="col-sm-7 col-lg-12" data-modal-status>Ongoing</dd>
                        </dl>
                        <div class="col-lg-7">
                            <div class="card border rental-return-audit-card h-100">
                        <div class="card-body p-3">
                            <div class="mb-3">
                                <h3 class="h6 mb-1">Return condition audit</h3>
                                <p class="small text-muted mb-0">Record the overall condition of the equipment being returned.</p>
                            </div>
                            <div class="rental-return-equipment-summary mb-3">
                                <span class="small text-muted d-block">Equipment</span>
                                <span class="fw-semibold">Rental equipment set</span>
                                <span class="small text-muted d-block">Serial details recorded in the transaction</span>
                            </div>
                            <div>
                                <label for="returnConditionNotes" class="form-label">Condition notes <span class="text-muted fw-normal">(optional)</span></label>
                                <textarea id="returnConditionNotes" class="form-control" rows="3" maxlength="500" placeholder="Describe any damage, missing items, or other observations." aria-describedby="returnConditionHelp returnConditionCount"></textarea>
                                <div class="d-flex justify-content-between gap-3 mt-2">
                                    <span id="returnConditionHelp" class="form-text">Maximum 500 characters</span>
                                    <span id="returnConditionCount" class="form-text" aria-live="polite">0 / 500</span>
                                </div>
                            </div>
                        </div>
                    </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="CompleteTransactionButton" runat="server" Text="Mark as done" CssClass="btn btn-success" OnClick="CompleteTransactionButton_Click" UseSubmitBehavior="false" data-confirm-mark-done="true" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/rentalstaff/ActiveTransactions.js?v=4") %>"></script>
</asp:Content>
