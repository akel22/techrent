<%@ Page Title="Review Rental Details" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="Review.aspx.cs" Inherits="Techrent.Pages.RentalStaff.Review" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.Review.css?v=4") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-review" aria-labelledby="reviewHeading">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 4 of 4</p>
                <h1 id="reviewHeading" class="h3 mb-2">Review rental details</h1>
                <p class="text-muted mb-0">Confirm the customer, assigned equipment, and pre-rental notes before completing the draft.</p>
            </div>
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
                            <p><span class ="text-muted">rental fee and security deposit are displayed per unit</span></p>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0 rental-staff-review-table">
                                <caption class="visually-hidden">Equipment and serial numbers for this rental</caption>
                                <thead>
                                    <tr><th scope="col">Equipment</th><th scope="col">Serial number</th><th scope="col" class="text-end">Rental fee</th><th scope="col" class="text-end">Security Deposit</th></tr>
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
                        <a class="btn btn-outline-secondary w-100 mt-2" href="<%: GetRouteUrl("RentalStaffSerialAssignment", null) %>"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Back to serial assignment</a>
                    </div>
                </aside>
            </div>
        </div>
    </section>

    <div class="modal fade" id="rentalReceiptModal" tabindex="-1" aria-labelledby="rentalReceiptModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="rentalReceiptModalLabel">Rental Receipt</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="rentalReceiptPrintContent">
                    <div class="rental-receipt">
                        <div class="rental-receipt-contact text-center mb-4">
                            <h3 class="h5 mb-1">TECH<span class="text-danger">RENT</span></h3>
                            <p class="small mb-0">Quezon City · (02) 8123-4567 · techrent@example.com</p>
                        </div>
                        <div class="rental-receipt-header d-flex flex-column flex-sm-row justify-content-between gap-3 mb-4">
                            <div>
                                <h3 class="h4 mb-1">Official Receipt</h3>
                                <p class="small text-muted mb-0">Transaction record and rental charges</p>
                            </div>
                            <dl class="small mb-0 text-sm-end">
                                <dt>Receipt number</dt>
                                <dd class="mb-0 fw-semibold">RCPT-TR-022-2026</dd>
                            </dl>
                        </div>

                        <section class="rental-receipt-section" aria-labelledby="rentalReceiptCustomerHeading">
                            <h3 class="h6 rental-receipt-heading" id="rentalReceiptCustomerHeading">Customer information</h3>
                            <dl class="rental-receipt-list">
                                <div class="rental-receipt-field"><dt>Customer name</dt><dd>Maria Santos</dd></div>
                                <div class="rental-receipt-field"><dt>Customer ID</dt><dd>CUS-1001</dd></div>
                                <div class="rental-receipt-field"><dt>Email</dt><dd>maria.santos@example.com</dd></div>
                                <div class="rental-receipt-field"><dt>Mobile</dt><dd>+63 917 123 4567</dd></div>
                            </dl>
                        </section>

                        <section class="rental-receipt-section" aria-labelledby="rentalReceiptEquipmentHeading">
                            <h3 class="h6 rental-receipt-heading" id="rentalReceiptEquipmentHeading">Assigned rental units</h3>
                            <div class="table-responsive">
                                <table class="table table-sm align-middle mb-0 rental-receipt-table">
                                    <thead>
                                        <tr><th scope="col">Equipment</th><th scope="col">Serial number</th><th scope="col" class="text-end">Rental fee</th><th scope="col" class="text-end">Deposit</th></tr>
                                    </thead>
                                    <tbody>
                                        <tr><th scope="row">SAMSUNG-001</th><td><span class="d-block">SN-SAM-2026-001</span><span class="d-block">SN-SAM-2026-002</span></td><td class="text-end">&#8369;3,000.00</td><td class="text-end">&#8369;6,000.00</td></tr>
                                        <tr><th scope="row">PROJECTOR-001</th><td>SN-PRJ-881</td><td class="text-end">&#8369;1,500.00</td><td class="text-end">&#8369;3,000.00</td></tr>
                                        <tr><th scope="row">HDMI-CABLE-10M</th><td>SN-HDMI-2026-014</td><td class="text-end">&#8369;0.00</td><td class="text-end">&#8369;0.00</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </section>

                        <section class="rental-receipt-section" aria-labelledby="rentalReceiptAuditHeading">
                            <h3 class="h6 rental-receipt-heading" id="rentalReceiptAuditHeading">Pre-rental details</h3>
                            <p class="small text-muted mb-2">Recorded by Rental Staff</p>
                            <p id="rentalReceiptAuditLog" class="small mb-0">No pre-rental details recorded.</p>
                        </section>

                        <div class="rental-receipt-footer-row">
                            <section class="rental-receipt-section rental-receipt-signature-section" aria-labelledby="rentalReceiptSignatureHeading">
                                <div class="rental-receipt-signature-line" aria-hidden="true"></div>
                                <p class="small text-muted mb-0">Signature</p>
                            </section>

                            <section class="rental-receipt-financial-summary" aria-labelledby="rentalReceiptFinancialHeading">
                                <h3 class="h6 rental-receipt-heading" id="rentalReceiptFinancialHeading">Charge summary</h3>
                                <dl class="row small mb-0 rental-receipt-summary">
                                    <dt class="col-8">Rental fees</dt>
                                    <dd class="col-4 text-end">&#8369;4,500.00</dd>
                                    <dt class="col-8">Security deposit</dt>
                                    <dd class="col-4 text-end">&#8369;9,000.00</dd>
                                    <dt class="col-8 rental-receipt-total-label">Estimated total</dt>
                                    <dd class="col-4 text-end rental-receipt-total">&#8369;13,500.00</dd>
                                </dl>
                            </section>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-block">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                        <fieldset class="mb-0">
                            <legend class="small fw-semibold mb-2">Was the receipt saved as a PDF file?</legend>
                            <div class="d-flex gap-3" id="receiptSaveConfirmation">
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="receiptSaved" id="receiptSavedYes" value="yes" />
                                    <label class="form-check-label" for="receiptSavedYes">Yes</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="receiptSaved" id="receiptSavedNo" value="no" />
                                    <label class="form-check-label" for="receiptSavedNo">No</label>
                                </div>
                            </div>
                        </fieldset>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-primary" id="printRentalReceiptButton">Save receipt as PDF</button>
                            <button type="button" class="btn btn-outline-secondary" id="closeRentalReceiptButton" data-bs-dismiss="modal" disabled>Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/Review.js?v=2") %>"></script>
</asp:Content>
