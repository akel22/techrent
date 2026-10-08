<%@ Page Title="Review Rental Details" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="Review.aspx.cs" Inherits="Techrent.Pages.RentalStaff.Review" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.Review.css?v=4") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-review" aria-labelledby="reviewHeading">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 3 of 3</p>
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
                                <h2 class="h5 mb-1"><%: CustomerName %></h2>
                                <p class="small text-muted mb-0"><%: CustomerId %></p>
                            </div>
                        </div>
                        <div class="row g-3 small mb-3">
                            <div class="col-md-6"><span class="d-block text-muted">Email</span><span><%: CustomerEmail %></span></div>
                            <div class="col-md-6"><span class="d-block text-muted">Mobile</span><span><%: CustomerMobile %></span></div>
                        </div>

                        <hr />

                        <dl class="row g-3 mb-0 small rental-staff-review-dates">
                            <div class="col-md-6">
                                <dt class="text-muted fw-normal">Rental start date</dt>
                                <dd id="reviewRentalStartDate" class="mb-0 fw-semibold">Not provided</dd>
                            </div>
                            <div class="col-md-6">
                                <dt class="text-muted fw-normal">Return date</dt>
                                <dd id="reviewRentalReturnDate" class="mb-0 fw-semibold">Not provided</dd>
                            </div>
                        </dl>
                    </div>
                </div>

                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-body p-3 p-md-4">
                        <div class="mb-3">
                            <p class="text-uppercase text-muted small fw-semibold mb-1">Equipment</p>
                            <h2 class="h5 mb-0">Assigned rental units</h2>
                            <p><span class ="text-muted">rental fee and security deposit are displayed per total units</span></p>
                        </div>
                        <div class="table-responsive">
                            <table class="table align-middle mb-0 rental-staff-review-table">
                                <caption class="visually-hidden">Equipment and charges for this rental</caption>
                                <thead>
                                    <tr><th scope="col">Equipment</th><th scope="col" class="text-end">Rental fee</th><th scope="col" class="text-end">Security Deposit</th></tr>
                                </thead>
                                <tbody id="reviewEquipmentRows"></tbody>
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
                         <div class="d-flex justify-content-between gap-3 mb-3"><span>Rental fees</span><strong id="reviewRentalFees">₱0.00</strong></div>
                         <div class="d-flex justify-content-between gap-3 mb-3"><span>Security deposit</span><strong id="reviewSecurityDeposit">₱0.00</strong></div>
                         <div class="d-flex justify-content-between gap-3 border-top pt-3"><span class="fw-semibold">Estimated total</span><strong id="reviewTotal" class="fs-5">₱0.00</strong></div>
                        <div class="mt-4">
                            <label for="paymentAmount" class="form-label fw-semibold">Amount paid</label>
                            <div class="input-group">
                                <span class="input-group-text">&#8369;</span>
                             <input type="number" id="paymentAmount" class="form-control" min="0" step="0.01" inputmode="decimal" placeholder="0.00" required aria-describedby="paymentAmountHelp paymentAmountError" />
                            </div>
                            <div id="paymentAmountHelp" class="form-text">Enter the amount received from the customer.</div>
                            <div id="paymentAmountError" class="invalid-feedback">Payment must be at least &#8369;13,500.00.</div>
                        </div>
                         <p class="text-muted small mt-3 mb-0">Charges are calculated from the selected equipment and stored transaction rates.</p>
                        <button type="button" id="confirmReviewButton" class="btn btn-success w-100 mt-4">Confirm rental details</button>
                        <a class="btn btn-outline-secondary w-100 mt-2" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>?customerId=<%: CustomerId %>"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Back to equipment selection</a>
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
                            <p class="small mb-0">Quezon City | (02) 8123-4567 | techrent@example.com</p>
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
                                <div class="rental-receipt-field"><dt>Customer name</dt><dd><%: CustomerName %></dd></div>
                                <div class="rental-receipt-field"><dt>Customer ID</dt><dd><%: CustomerId %></dd></div>
                                <div class="rental-receipt-field"><dt>Email</dt><dd><%: CustomerEmail %></dd></div>
                                <div class="rental-receipt-field"><dt>Mobile</dt><dd><%: CustomerMobile %></dd></div>
                            </dl>
                        </section>

                        <section class="rental-receipt-section" aria-labelledby="rentalReceiptDatesHeading">
                            <h3 class="h6 rental-receipt-heading" id="rentalReceiptDatesHeading">Rental dates</h3>
                            <dl class="rental-receipt-list">
                                <div class="rental-receipt-field"><dt>Rental start date</dt><dd id="rentalReceiptStartDate">Not provided</dd></div>
                                <div class="rental-receipt-field"><dt>Return date</dt><dd id="rentalReceiptReturnDate">Not provided</dd></div>
                            </dl>
                        </section>

                        <section class="rental-receipt-section" aria-labelledby="rentalReceiptEquipmentHeading">
                            <h3 class="h6 rental-receipt-heading" id="rentalReceiptEquipmentHeading">Assigned rental units</h3>
                            <div class="table-responsive">
                                <table class="table table-sm align-middle mb-0 rental-receipt-table">
                                    <thead>
                                        <tr><th scope="col">Equipment</th><th scope="col" class="text-end">Rental fee</th><th scope="col" class="text-end">Deposit</th></tr>
                                    </thead>
                                     <tbody id="rentalReceiptEquipmentRows">
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
                                     <dd id="rentalReceiptRentalFees" class="col-4 text-end">₱0.00</dd>
                                    <dt class="col-8">Security deposit</dt>
                                     <dd id="rentalReceiptSecurityDeposit" class="col-4 text-end">₱0.00</dd>
                                    <dt class="col-8">Amount paid</dt>
                                    <dd id="rentalReceiptAmountPaid" class="col-4 text-end">&#8369;0.00</dd>
                                    <dt class="col-8">Change</dt>
                                    <dd id="rentalReceiptChange" class="col-4 text-end">&#8369;0.00</dd>
                                    <dt class="col-8 rental-receipt-total-label">Estimated total</dt>
                                     <dd id="rentalReceiptTotal" class="col-4 text-end rental-receipt-total">₱0.00</dd>
                                </dl>
                            </section>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-block">
                    <div class="d-flex flex-column flex-md-row justify-content-end align-items-md-center gap-3">
                        <button type="button" class="btn btn-primary" id="printRentalReceiptButton">Save receipt as PDF</button>
                        <button type="submit" runat="server" id="saveRentalButton" onserverclick="SaveRentalButton_ServerClick" class="btn btn-success">Confirm and save rental</button>

                    </div>
                    <input type="hidden" id="selectedEquipmentJson" runat="server" ClientIDMode="Static" />
                    <input type="hidden" id="rentalStartDateValue" runat="server" ClientIDMode="Static" />
                    <input type="hidden" id="rentalReturnDateValue" runat="server" ClientIDMode="Static" />
                    <input type="hidden" id="paymentAmountValue" runat="server" ClientIDMode="Static" />
                    <div id="saveRentalMessage" runat="server" class="alert alert-info mt-3 mb-0" visible="false"></div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/Review.js?v=3") %>"></script>
</asp:Content>
