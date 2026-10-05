<%@ Page Title="Review Rental Details" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="Review.aspx.cs" Inherits="Techrent.Pages.RentalStaff.Review" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.Review.css?v=1") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-review" aria-labelledby="reviewHeading">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 4 of 4</p>
                <h1 id="reviewHeading" class="h3 mb-2">Review rental details</h1>
                <p class="text-muted mb-0">Confirm the customer, assigned equipment, and pre-rental notes before completing the draft.</p>
            </div>
            <span class="badge text-bg-light border">Transaction draft</span>
        </div>

        <div id="reviewConfirmation" class="alert alert-success d-none" role="status" aria-live="polite">
            Rental details reviewed. This presentation-only draft is ready for the next workflow.
        </div>

        <div class="row g-4">
            <div class="col-12 col-xl-8">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body p-3 p-md-4">
                        <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                            <div>
                                <p class="text-uppercase text-muted small fw-semibold mb-1">Customer</p>
                                <h2 class="h5 mb-1">Maria Santos</h2>
                                <p class="small text-muted mb-0">CUS-1001</p>
                            </div>
                            <span class="badge text-bg-success">Selected</span>
                        </div>
                        <div class="row g-3 small">
                            <div class="col-md-6"><span class="d-block text-muted">Email</span><span>maria.santos@example.com</span></div>
                            <div class="col-md-6"><span class="d-block text-muted">Mobile</span><span>+63 917 123 4567</span></div>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body p-3 p-md-4">
                        <div class="mb-3">
                            <p class="text-uppercase text-muted small fw-semibold mb-1">Equipment</p>
                            <h2 class="h5 mb-0">Assigned rental units</h2>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0 rental-staff-review-table">
                                <caption class="visually-hidden">Equipment and serial numbers for this rental</caption>
                                <thead>
                                    <tr><th scope="col">Equipment</th><th scope="col">Serial number</th><th scope="col" class="text-end">Rental fee</th><th scope="col" class="text-end">Deposit</th></tr>
                                </thead>
                                <tbody>
                                    <tr><th scope="row"><span class="d-block">SAMSUNG-001</span><span class="small text-muted">Laptop · 2 units</span></th><td><span class="d-block small">SN-SAM-2026-001</span><span class="d-block small">SN-SAM-2026-002</span></td><td class="text-end">&#8369;3,000.00</td><td class="text-end">&#8369;6,000.00</td></tr>
                                    <tr><th scope="row"><span class="d-block">PROJECTOR-001</span><span class="small text-muted">Projector · 1 unit</span></th><td class="small">SN-PRJ-881</td><td class="text-end">&#8369;1,500.00</td><td class="text-end">&#8369;3,000.00</td></tr>
                                    <tr><th scope="row"><span class="d-block">HDMI-CABLE-10M</span><span class="small text-muted">Accessory · 1 unit</span></th><td class="small">SN-HDMI-2026-014</td><td class="text-end">&#8369;0.00</td><td class="text-end">&#8369;0.00</td></tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm">
                    <div class="card-body p-3 p-md-4">
                        <div class="mb-3">
                            <label for="preRentalAuditLog" class="text-uppercase text-muted small fw-semibold mb-1">Pre-rental audit log</label>
                            <p class="text-muted small mb-0">Record visible condition notes or other details observed before release.</p>
                        </div>
                        <textarea id="preRentalAuditLog" class="form-control" rows="5" maxlength="500" placeholder="Type pre-rental details or leave blank if there are no notes." aria-describedby="auditLogHelp auditLogCount"></textarea>
                        <div class="d-flex justify-content-between gap-3 mt-2">
                            <span id="auditLogHelp" class="form-text">Optional · Maximum 500 characters</span>
                            <span id="auditLogCount" class="form-text" aria-live="polite">0 / 500</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-12 col-xl-4">
                <aside class="card border-0 shadow-sm rental-staff-review-summary" aria-labelledby="summaryHeading">
                    <div class="card-body p-3 p-md-4">
                        <p class="text-uppercase text-muted small fw-semibold mb-1">Financial summary</p>
                        <h2 id="summaryHeading" class="h5 mb-4">Estimated charges</h2>
                        <div class="d-flex justify-content-between gap-3 mb-3"><span>Rental fees</span><strong>&#8369;4,500.00</strong></div>
                        <div class="d-flex justify-content-between gap-3 mb-3"><span>Security deposit</span><strong>&#8369;9,000.00</strong></div>
                        <div class="d-flex justify-content-between gap-3 border-top pt-3"><span class="fw-semibold">Estimated total</span><strong class="fs-5">&#8369;13,500.00</strong></div>
                        <p class="text-muted small mt-3 mb-0">Static sample amounts for interface demonstration only.</p>
                        <button type="button" id="confirmReviewButton" class="btn btn-success w-100 mt-4">Confirm rental details</button>
                        <a class="btn btn-outline-secondary w-100 mt-2" href="<%: GetRouteUrl("RentalStaffSerialAssignment", null) %>">Back to serial assignment</a>
                    </div>
                </aside>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/Review.js?v=1") %>"></script>
</asp:Content>
