<%@ Page Title="Assign Serial Numbers" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="SerialAssignment.aspx.cs" Inherits="Techrent.Pages.RentalStaff.SerialAssignment" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.SerialAssignment.css?v=4") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-serial-assignment" aria-labelledby="serialAssignmentHeading">
        <div class="d-flex flex-wrap justify-content-between align-items-end gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 3 of 4</p>
                <h1 id="serialAssignmentHeading" class="h3 mb-2">Assign serial numbers</h1>
                <p class="text-muted mb-0">Select an available serial number for every unit in this rental.</p>
            </div>
        </div>

 

        <form id="serialAssignmentForm" class="card border-0 shadow-sm serial-assignment-form">
            <div class="card-body p-3 p-md-4">
                <div class="serial-assignment-group">
                    <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
                        <div>
                            <h2 class="h5 mb-1">SAMSUNG-001</h2>
                            <p class="small text-muted mb-0">Laptop · Required quantity: 2 units</p>
                        </div>
                    </div>
                    <div class="serial-assignment-rows">
                        <div class="serial-assignment-row" data-assignment-row ="">
                            <span class="assignment-unit-number">1</span>
                            <label class="visually-hidden" for="samsungSerial1">Serial number for SAMSUNG-001 unit 1</label>
                            <select id="samsungSerial1" class="form-select serial-select" data-equipment="samsung" required>
                                <option value="">Select available serial number</option>
                                <option value="SN-SAM-2026-001">SN-SAM-2026-001</option>
                                <option value="SN-SAM-2026-002">SN-SAM-2026-002</option>
                            </select>
                            <div class="invalid-feedback">Select a serial number.</div>
                        </div>
                        <div class="serial-assignment-row" data-assignment-row="">
                            <span class="assignment-unit-number">2</span>
                            <label class="visually-hidden" for="samsungSerial2">Serial number for SAMSUNG-001 unit 2</label>
                            <select id="samsungSerial2" class="form-select serial-select" data-equipment="samsung" required>
                                <option value="">Select available serial number</option>
                                <option value="SN-SAM-2026-001">SN-SAM-2026-001</option>
                                <option value="SN-SAM-2026-002">SN-SAM-2026-002</option>
                            </select>
                            <div class="invalid-feedback">Select a serial number.</div>
                        </div>
                    </div>
                </div>

                <div class="serial-assignment-group">
                    <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
                        <div>
                            <h2 class="h5 mb-1">PROJECTOR-001</h2>
                            <p class="small text-muted mb-0">Projector · Required quantity: 1 unit</p>
                        </div>
                    </div>
                    <div class="serial-assignment-rows">
                        <div class="serial-assignment-row" data-assignment-row>
                            <span class="assignment-unit-number">1</span>
                            <label class="visually-hidden" for="projectorSerial1">Serial number for PROJECTOR-001 unit 1</label>
                            <select id="projectorSerial1" class="form-select serial-select" data-equipment="projector" required>
                                <option value="">Select available serial number</option>
                                <option value="SN-PRJ-881">SN-PRJ-881</option>
                            </select>
                            <div class="invalid-feedback">Select a serial number.</div>
                        </div>
                    </div>
                </div>

                <div class="serial-assignment-group">
                    <div class="d-flex flex-wrap justify-content-between align-items-start gap-2 mb-3">
                        <div>
                            <h2 class="h5 mb-1">HDMI-CABLE-10M</h2>
                            <p class="small text-muted mb-0">Accessory · Required quantity: 1 unit</p>
                        </div>
                    </div>
                    <div class="serial-assignment-rows">
                        <div class="serial-assignment-row" data-assignment-row>
                            <span class="assignment-unit-number">1</span>
                            <label class="visually-hidden" for="cableSerial1">Serial number for HDMI-CABLE-10M unit 1</label>
                            <select id="cableSerial1" class="form-select serial-select" data-equipment="cable" required>
                                <option value="">Select available serial number</option>
                                <option value="SN-HDMI-2026-014">SN-HDMI-2026-014</option>
                            </select>
                            <div class="invalid-feedback">Select a serial number.</div>
                        </div>
                    </div>
                </div>

                <div class="border-top pt-3 mt-4">
                    <button type="submit" id="finalizeAssignmentButton" class="btn btn-success w-100" data-next-url='<%: GetRouteUrl("RentalStaffReview", null) %>'>Confirm assignment and continue</button>
                    <p id="finalizeAssignmentMessage" class="small text-muted text-center mt-2 mb-0">All units must have a serial number before continuing.</p>
                </div>
            </div>
        </form>
    </section>
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/RentalStaff/SerialAssignment.js?v=1") %>"></script>
</asp:Content>
