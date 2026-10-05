<%@ Page Title="Select Equipment" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="Equipment.aspx.cs" Inherits="Techrent.Pages.RentalStaff.Equipment" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.Equipment.css?v=1") %>" rel="stylesheet" />
</asp:Content>
<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-equipment" aria-labelledby="equipmentHeading">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 2 of 2</p>
                <h1 id="equipmentHeading" class="h3 mb-2">Choose equipment</h1>
                <p class="text-muted mb-0">Add equipment for this rental transaction.</p>
            </div>
            <a class="btn btn-outline-secondary" href="<%: GetRouteUrl("RentalStaffNew", null) %>">Change customer</a></div>
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
                                    <option value="laptop">Laptops</option>
                                    <option value="projector">Projectors</option>
                                    <option value="monitor">Monitors</option>
                                    <option value="accessory">Accessories</option>
                                </select></div>
                        </div>
                        <div id="equipmentList" class="row g-3">
                            <div class="col-sm-6 col-lg-4 equipment-item" data-equipment-search="samsung-001 laptop" data-category="laptop">
                                <article class="card h-100 rental-staff-equipment-card">
                                    <div class="rental-staff-equipment-visual rental-staff-equipment-visual-laptop">LAPTOP</div>
                                    <div class="card-body">
                                        <p class="small text-muted mb-1">Laptop</p>
                                        <h2 class="h6">SAMSUNG-001</h2>
                                        <p class="equipment-type equipment-type-standard">Type: Standard</p>
                                        <p class="small text-muted">Standard laptop for office work.</p>
                                        <button type="button" class="btn btn-success btn-sm equipment-add-button" data-equipment-id="SAMSUNG-001" data-equipment-name="SAMSUNG-001" data-equipment-rate="1500" data-equipment-rental-fee="1500" data-equipment-security-deposit="3000" data-equipment-stock="3">Add</button><span class="small text-muted ms-2">3 available</span></div>
                                </article>
                            </div>
                            <div class="col-sm-6 col-lg-4 equipment-item" data-equipment-search="projector-001 projector" data-category="projector">
                                <article class="card h-100 rental-staff-equipment-card">
                                    <div class="rental-staff-equipment-visual rental-staff-equipment-visual-projector">PROJECTOR</div>
                                    <div class="card-body">
                                        <p class="small text-muted mb-1">Projector</p>
                                        <h2 class="h6">PROJECTOR-001</h2>
                                        <p class="equipment-type equipment-type-standard">Type: Standard</p>
                                        <p class="small text-muted">Portable presentation projector.</p>
                                        <button type="button" class="btn btn-success btn-sm equipment-add-button" data-equipment-id="PROJECTOR-001" data-equipment-name="PROJECTOR-001" data-equipment-rate="1500" data-equipment-rental-fee="1500" data-equipment-security-deposit="3000" data-equipment-stock="4">Add</button><span class="small text-muted ms-2">4 available</span></div>
                                </article>
                            </div>
                            <div class="col-sm-6 col-lg-4 equipment-item" data-equipment-search="dell-u2723qe monitor" data-category="monitor">
                                <article class="card h-100 rental-staff-equipment-card">
                                    <div class="rental-staff-equipment-visual rental-staff-equipment-visual-monitor">MONITOR</div>
                                    <div class="card-body">
                                        <p class="small text-muted mb-1">Monitor</p>
                                        <h2 class="h6">DELL-U2723QE</h2>
                                        <p class="equipment-type equipment-type-professional">Type: Professional</p>
                                        <p class="small text-muted">27-inch USB-C monitor.</p>
                                        <button type="button" class="btn btn-success btn-sm equipment-add-button" data-equipment-id="DELL-U2723QE" data-equipment-name="DELL-U2723QE" data-equipment-rate="1200" data-equipment-rental-fee="1200" data-equipment-security-deposit="2400" data-equipment-stock="5">Add</button><span class="small text-muted ms-2">5 available</span></div>
                                </article>
                            </div>
                            <div class="col-sm-6 col-lg-4 equipment-item" data-equipment-search="macbook-pro-m3 laptop" data-category="laptop">
                                <article class="card h-100 rental-staff-equipment-card">
                                    <div class="rental-staff-equipment-visual rental-staff-equipment-visual-laptop">LAPTOP</div>
                                    <div class="card-body">
                                        <p class="small text-muted mb-1">Laptop</p>
                                        <h2 class="h6">MACBOOK-PRO-M3</h2>
                                        <p class="equipment-type equipment-type-professional">Type: Professional</p>
                                        <p class="small text-muted">Professional creative-work laptop.</p>
                                        <button type="button" class="btn btn-success btn-sm equipment-add-button" data-equipment-id="MACBOOK-PRO-M3" data-equipment-name="MACBOOK-PRO-M3" data-equipment-rate="2200" data-equipment-rental-fee="2200" data-equipment-security-deposit="4400" data-equipment-stock="2">Add</button><span class="small text-muted ms-2">2 available</span></div>
                                </article>
                            </div>
                            <div class="col-sm-6 col-lg-4 equipment-item" data-equipment-search="epson-4k-pro projector" data-category="projector">
                                <article class="card h-100 rental-staff-equipment-card">
                                    <div class="rental-staff-equipment-visual rental-staff-equipment-visual-projector">PROJECTOR</div>
                                    <div class="card-body">
                                        <p class="small text-muted mb-1">Projector</p>
                                        <h2 class="h6">EPSON-4K-PRO</h2>
                                        <p class="equipment-type equipment-type-professional">Type: Professional</p>
                                        <p class="small text-muted">High-resolution room projector.</p>
                                        <button type="button" class="btn btn-success btn-sm equipment-add-button" data-equipment-id="EPSON-4K-PRO" data-equipment-name="EPSON-4K-PRO" data-equipment-rate="2400" data-equipment-rental-fee="2400" data-equipment-security-deposit="4800" data-equipment-stock="3">Add</button><span class="small text-muted ms-2">3 available</span></div>
                                </article>
                            </div>
                            <div class="col-sm-6 col-lg-4 equipment-item" data-equipment-search="usb-c hub accessory" data-category="accessory">
                                <article class="card h-100 rental-staff-equipment-card">
                                    <div class="rental-staff-equipment-visual rental-staff-equipment-visual-accessory">ACCESSORY</div>
                                    <div class="card-body">
                                        <p class="small text-muted mb-1">Accessory</p>
                                        <h2 class="h6">USB-C-HUB</h2>
                                        <p class="equipment-type equipment-type-obsolete">Type: Obsolete</p>
                                        <p class="small text-muted">Multi-port laptop hub.</p>
                                        <button type="button" class="btn btn-success btn-sm equipment-add-button" data-equipment-id="USB-C-HUB" data-equipment-name="USB-C-HUB" data-equipment-rate="350" data-equipment-rental-fee="350" data-equipment-security-deposit="700" data-equipment-stock="6">Add</button><span class="small text-muted ms-2">6 available</span></div>
                                </article>
                            </div>
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
                                <p class="small text-muted">Customer selection is presentation-only</p>
                            </div>
                        </div>
                        <hr />
                        <div id="summaryItems" aria-live="polite">
                            <p id="summaryEmpty" class="text-muted small">No equipment added yet.</p>
                        </div>
                        <div class="d-flex justify-content-between mt-4 pt-3 border-top"><span class="fw-semibold">Estimated total</span><strong id="summaryTotal">&#8369;0.00</strong></div>
                        <p class="text-muted small mt-2">Static sample rates for interface demonstration only.</p>
                        <button type="button" id="continueButton" class="btn btn-success w-100 mt-3" data-next-url="<%: GetRouteUrl("RentalStaffSerialAssignment", null) %>" disabled>Continue</button></div>
                </aside>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/Equipment.js?v=2") %>"></script>
</asp:Content>
