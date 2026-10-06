<%@ Page Title="New 
    on" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="New.aspx.cs" Inherits="Techrent.Pages.RentalStaff.New" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.New.css?v=1") %>" rel="stylesheet" />
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
                        <span id="customerCount" class="text-muted small" aria-live="polite">5 customers</span>
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
                            <tr data-customer-search="CUS-1001 maria santos maria.santos@example.com 09171234567" data-customer-id="CUS-1001" data-first-name="Maria" data-last-name="Santos" data-email="maria.santos@example.com" data-mobile-number="0917 123 4567" data-telephone-number="(02) 8123 4501" data-organization="Techrent Solutions" data-address="Makati City" data-account-status="Active">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Maria Santos</span>
                                    <span class="small text-muted">CUS-1001</span>
                                </th>
                                <td>
                                    <span class="d-block">maria.santos@example.com</span>
                                    <span class="small text-muted">0917 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <button type="button" class="btn btn-outline-secondary btn-sm customer-details-button" data-bs-toggle="modal" data-bs-target="#customerDetailsModal">View details</button>
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1002 john dela cruz john.delacruz@example.com 09181234567" data-customer-id="CUS-1002" data-first-name="John" data-last-name="Dela Cruz" data-email="john.delacruz@example.com" data-mobile-number="0918 123 4567" data-telephone-number="(02) 8123 4567" data-organization="Quezon City University" data-address="Novaliches, Quezon City" data-account-status="Active">
                                <th scope="row">
                                    <span class="d-block fw-semibold">John Dela Cruz</span>
                                    <span class="small text-muted">CUS-1002</span>
                                </th>
                                <td>
                                    <span class="d-block">john.delacruz@example.com</span>
                                    <span class="small text-muted">0918 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <button type="button" class="btn btn-outline-secondary btn-sm customer-details-button" data-bs-toggle="modal" data-bs-target="#customerDetailsModal">View details</button>
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1003 ana reyes ana.reyes@example.com 09191234567" data-customer-id="CUS-1003" data-first-name="Ana" data-last-name="Reyes" data-email="ana.reyes@example.com" data-mobile-number="0919 123 4567" data-telephone-number="(02) 8123 4588" data-organization="Reyes Family Clinic" data-address="Pasig City" data-account-status="Active">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Ana Reyes</span>
                                    <span class="small text-muted">CUS-1003</span>
                                </th>
                                <td>
                                    <span class="d-block">ana.reyes@example.com</span>
                                    <span class="small text-muted">0919 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <button type="button" class="btn btn-outline-secondary btn-sm customer-details-button" data-bs-toggle="modal" data-bs-target="#customerDetailsModal">View details</button>
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1004 carlos navarro carlos.navarro@example.com 09201234567" data-customer-id="CUS-1004" data-first-name="Carlos" data-last-name="Navarro" data-email="carlos.navarro@example.com" data-mobile-number="0920 123 4567" data-telephone-number="(02) 8123 4599" data-organization="Navarro Trading" data-address="Manila City" data-account-status="Active">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Carlos Navarro</span>
                                    <span class="small text-muted">CUS-1004</span>
                                </th>
                                <td>
                                    <span class="d-block">carlos.navarro@example.com</span>
                                    <span class="small text-muted">0920 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <button type="button" class="btn btn-outline-secondary btn-sm customer-details-button" data-bs-toggle="modal" data-bs-target="#customerDetailsModal">View details</button>
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1005 leah tan leah.tan@example.com 09211234567" data-customer-id="CUS-1005" data-first-name="Leah" data-last-name="Tan" data-email="leah.tan@example.com" data-mobile-number="0921 123 4567" data-telephone-number="(02) 8123 4510" data-organization="Tan Design Studio" data-address="Taguig City" data-account-status="Active">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Leah Tan</span>
                                    <span class="small text-muted">CUS-1005</span>
                                </th>
                                <td>
                                    <span class="d-block">leah.tan@example.com</span>
                                    <span class="small text-muted">0921 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <button type="button" class="btn btn-outline-secondary btn-sm customer-details-button" data-bs-toggle="modal" data-bs-target="#customerDetailsModal">View details</button>
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
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
                                <dt class="col-sm-5">Telephone Number</dt>
                                <dd class="col-sm-7" id="customerDetailTelephone"></dd>
                                <dt class="col-sm-5">Organization</dt>
                                <dd class="col-sm-7" id="customerDetailOrganization"></dd>
                                <dt class="col-sm-5">Organization Address</dt>
                                <dd class="col-sm-7" id="customerDetailAddress"></dd>
                                <dt class="col-sm-5">Account Status</dt>
                                <dd class="col-sm-7" id="customerDetailStatus"></dd>
                            </dl>
                        </div>
                        <div class="col-md-5">
                            <div class="customer-profile-placeholder" role="img" aria-label="Profile image placeholder">Profile image</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <div>
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Go back</button>
                        <a class="btn btn-success" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/New.js?v=1") %>"></script>
</asp:Content>
