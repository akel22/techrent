<%@ Page Title="Select Equipment" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="Equipment.aspx.cs" Inherits="Techrent.Pages.RentalStaff.Equipment" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.Equipment.css?v=1") %>" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-equipment" aria-labelledby="equipmentHeading">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 2 of 3</p>
                <h1 id="equipmentHeading" class="h3 mb-2">Choose equipment</h1>
                <p class="text-muted mb-0">Add equipment for this rental transaction.</p>
            </div>
            <a class="btn btn-outline-secondary" href="<%: GetRouteUrl("RentalStaffNew", null) %>"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Go back to customer selection</a></div>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-3 p-md-4">
                <div class="mb-3">
                    <h2 class="h5 mb-1">Rental dates</h2>
                        <p class="text-muted small mb-0">Choose when the equipment will be released and returned. Rental fees are billed by the hour, with partial hours rounded up.</p>
                </div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="rentalStartDate" class="form-label">Rental start date and time</label>
                        <input id="rentalStartDate" class="form-control" type="datetime-local" required aria-describedby="rentalDateHelp rentalDateValidation" />
                    </div>
                    <div class="col-md-6">
                        <label for="rentalEndDate" class="form-label">Return date and time</label>
                        <input id="rentalEndDate" class="form-control" type="datetime-local" required aria-describedby="rentalDateHelp rentalDateValidation" />
                    </div>
                </div>
                <p id="rentalDateHelp" class="form-text mb-0">The return date and time must be after the rental start date and time.</p>
                <div id="rentalDateValidation" class="invalid-feedback d-none" role="alert" aria-live="polite"></div>
            </div>
        </div>
        <div class="row g-4">
            <div class="col-12 col-xl-8">
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <div class="row g-3 mb-4">
                            <div class="col-md-7">
                                <label for="equipmentSearch" class="form-label">Search equipment</label>
                                <div class="rental-staff-search-wrapper">
                                    <img class="rental-staff-search-icon" src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" aria-hidden="true" />
                                    <input id="equipmentSearch" class="form-control" type="search" placeholder="Search by model or category" />
                                </div>
                            </div>
                            <div class="col-md-5">
                                <label for="equipmentCategory" class="form-label">Category</label><select id="equipmentCategory" class="form-select"><option value="all">All equipment</option>
                                    <option value="Laptop">Laptop</option>
                                    <option value="Desktop">Desktop</option>
                                    <option value="Monitor">Monitor</option>
                                    <option value="Projector">Projector</option>
                                    <option value="Peripheral">Peripheral</option>
                                    <option value="Other">Other</option>
                                </select></div>
                        </div>
                        <div id="equipmentList" class="row g-3">
                            <asp:Repeater ID="EquipmentRepeater" runat="server">
                                <ItemTemplate>
                                    <div class="col-sm-6 col-lg-4 equipment-item" data-equipment-search="<%#: Eval("SearchText") %>" data-category="<%#: Eval("Category") %>">
                                        <article class="card h-100 rental-staff-equipment-card">
                                            <div class="rental-staff-equipment-visual"><%#: Eval("Category") %></div>
                                            <div class="card-body">
                                                <p class="small text-muted mb-1"><%#: Eval("Category") %></p>
                                                <h2 class="h6"><%#: Eval("Model") %></h2>
                                                <p>Type: <%#: Eval("Type") %></p>
                                                <p class="small text-muted">SKU: <%#: Eval("Sku") %></p>
                                                 <button type="button" class="btn btn-success btn-sm equipment-add-button" data-equipment-id="<%#: Eval("EquipmentId") %>" data-equipment-name="<%#: Eval("Model") %>" data-equipment-category="<%#: Eval("Category") %>" data-equipment-sku="<%#: Eval("Sku") %>" data-equipment-stock="<%#: Eval("Stock") %>" data-equipment-rate="<%#: Eval("BaseRentalFee", "{0:0.00}") %>" data-equipment-rental-fee="<%#: Eval("BaseRentalFee", "{0:0.00}") %>" data-equipment-security-deposit="<%#: Eval("SecurityDeposit", "{0:0.00}") %>"><img src="<%: ResolveUrl("~/assets/svg/add.svg") %>" alt="" width="16" height="16" aria-hidden="true" />Add</button><span class="small text-muted ms-2"><%#: Eval("Stock") %> available</span>
                                            </div>
                                        </article>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <p id="noEquipmentMessage" class="text-muted text-center d-none">No equipment matches your filters.</p>
                    </div>
                </div>
            </div>
            <div class="col-12 col-xl-4">
                <aside class="card border-0 shadow-sm rental-staff-summary" aria-labelledby="summaryHeading">
                    <div class="card-body">
                        <div class="d-flex justify-content-between">
                            <div>
                                <p class="text-uppercase text-muted small fw-semibold mb-1">Transaction</p>
                                <h2 id="summaryHeading" class="h5">Transaction summary</h2>
                                 <p class="small text-muted">Selected equipment is checked again when the rental is saved.</p>
                            </div>
                        </div>
                        <hr />
                        <div id="summaryItems" aria-live="polite">
                            <p id="summaryEmpty" class="text-muted small">No equipment added yet.</p>
                        </div>
                        <div class="d-flex justify-content-between mt-4 pt-3 border-top"><span class="fw-semibold">Estimated total</span><strong id="summaryTotal">&#8369;0.00</strong></div>
                         <p class="text-muted small mt-2">Rental and deposit rates are stored with the transaction.</p>
                         <button type="button" id="continueButton" class="btn btn-success w-100 mt-3" data-next-url="<%: GetRouteUrl("RentalStaffReview", null) %>?customerId=<%: CustomerIdQuery %>" disabled>Continue</button></div>
                </aside>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/Equipment.js?v=5") %>"></script>
</asp:Content>
