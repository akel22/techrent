<%@ Page Title="New Rental" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="New.aspx.cs" Inherits="Techrent.Pages.RentalStaff.New" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.New.css?v=2") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-new" aria-labelledby="newTransactionHeading">
        <div class="d-flex flex-wrap align-items-end justify-content-between gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 1 of 4</p>
                <h1 id="newTransactionHeading" class="h3 mb-2">Select a customer</h1>
                <p class="text-muted mb-0">Choose the customer for this rental transaction.</p>
            </div>
            <a class="btn btn-outline-secondary" href="<%: GetRouteUrl("RentalStaff", null) %>"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Cancel</a>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-3 p-md-4">
                <div class="d-flex justify-content-start mb-3">
                    <a class="btn btn-primary" href="<%: GetRouteUrl("RentalStaffRegisterCustomer", null) %>">Register new customer</a>
                </div>
                <div class="row align-items-end g-3 mb-4">
                    <div class="col-md-8 col-lg-6">
                        <label for="customerSearch" class="form-label">Search customers</label>
                        <div class="rental-staff-search-wrapper">
                            <img class="rental-staff-search-icon" src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" aria-hidden="true" />
                            <input id="customerSearch" class="form-control" type="search" placeholder="Search by customer ID, name, or contact" autocomplete="off" />
                        </div>
                    </div>
                    <div class="col-md-4 col-lg-6 text-md-end">
                        <span id="customerCount" class="text-muted small" aria-live="polite"><%: CustomerCount %> customers</span>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table align-middle rental-staff-customer-table">
                        <caption class="visually-hidden">Available customers for the new transaction</caption>
                        <thead>
                            <tr>
                                <th scope="col">Customer</th>
                                <th scope="col">Contact</th>
                                <th scope="col" class="text-md-end">Action</th>
                            </tr>
                        </thead>
                        <tbody id="customerList">
                            <asp:Repeater ID="CustomerRepeater" runat="server">
                                <ItemTemplate>
                                    <tr data-customer-search="<%#: Eval("SearchText") %>" data-customer-id="<%#: Eval("CustomerId") %>" data-first-name="<%#: Eval("FirstName") %>" data-last-name="<%#: Eval("LastName") %>" data-email="<%#: Eval("Email") %>" data-mobile-number="<%#: Eval("MobileNumber") %>" data-telephone-number="" data-occupation="<%#: Eval("Occupation") %>" data-organization-address="<%#: Eval("OrganizationAddress") %>" data-account-status="<%#: Eval("AccountStatus") %>" data-image="<%#: Eval("ImageData") %>">
                                        <th scope="row">
                                            <span class="d-block fw-semibold"><%#: Eval("FullName") %></span>
                                            <span class="small text-muted"><%#: Eval("CustomerId") %></span>
                                        </th>
                                        <td>
                                            <span class="d-block"><%#: Eval("Email") %></span>
                                            <span class="small text-muted"><%#: Eval("MobileNumber") %></span>
                                        </td>
                                        <td class="text-md-end">
                                            <button type="button" class="btn btn-outline-secondary btn-sm customer-details-button" data-bs-toggle="modal" data-bs-target="#customerDetailsModal">View details</button>
                                            <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>?customerId=<%#: Eval("CustomerId") %>">Select customer</a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
                <p id="noCustomersMessage" class="text-muted text-center py-4 mb-0 d-none">No customers match your search.</p>
            </div>
        </div>
    </section>

    <div class="modal fade" id="customerDetailsModal" tabindex="-1" aria-labelledby="customerDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="customerDetailsModalLabel">Customer details</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-4">
                        <div class="col-md-7">
                            <dl class="row mb-0 customer-details-list">
                                <dt class="col-sm-5">Customer ID</dt>
                                <dd class="col-sm-7" id="customerDetailId"></dd>
                                <dt class="col-sm-5">First Name</dt>
                                <dd class="col-sm-7" id="customerDetailFirstName"></dd>
                                <dt class="col-sm-5">Last Name</dt>
                                <dd class="col-sm-7" id="customerDetailLastName"></dd>
                                <dt class="col-sm-5">Email</dt>
                                <dd class="col-sm-7" id="customerDetailEmail"></dd>
                                <dt class="col-sm-5">Mobile Number</dt>
                                <dd class="col-sm-7" id="customerDetailMobile"></dd>
                                <dt class="col-sm-5">Occupation</dt>
                                <dd class="col-sm-7" id="customerDetailOccupation"></dd>
                                <dt class="col-sm-5">Organization Address</dt>
                                <dd class="col-sm-7" id="customerDetailAddress"></dd>
                                <dt class="col-sm-5">Account Status</dt>
                                <dd class="col-sm-7" id="customerDetailStatus"></dd>
                            </dl>
                        </div>
                        <div class="col-md-5">
                            <div class="customer-profile-placeholder border-0 shadow-sm" aria-label="Customer identification card">
                                <span id="customerProfileImagePlaceholder">Identification card unavailable</span>
                                <img id="customerProfileImage" class="customer-profile-image d-none" alt="Customer identification card" />
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <div>
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Go back</button>
                        <a id="customerDetailSelectButton" class="btn btn-success" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/New.js?v=1") %>"></script>
</asp:Content>
