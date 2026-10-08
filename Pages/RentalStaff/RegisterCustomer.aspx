<%@ Page Title="Register Customer" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="RegisterCustomer.aspx.cs" Inherits="Techrent.Pages.RentalStaff.RegisterCustomer" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RegisterCustomer.css?v=1") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-register" aria-labelledby="registerCustomerHeading">
        <div class="d-flex flex-wrap align-items-end justify-content-between gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Customer registration</p>
                <h1 id="registerCustomerHeading" class="h3 mb-2">Register a new customer</h1>
                <p class="text-muted mb-0">Enter the customer details and attach an identification photo.</p>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-body p-3 p-md-4">
                <div id="registrationAlert" runat="server" ClientIDMode="Static" class="alert alert-success d-none" role="status">Customer registered successfully.</div>
                <div id="customerRegistrationForm" role="form" novalidate>
                    <div class="row g-4">
                        <div class="col-lg-7">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label" for="firstName">First name <span class="text-danger" aria-hidden="true">*</span></label>
                                    <input id="firstName" runat="server" class="form-control" type="text" required maxlength="24" autocomplete="given-name" />
                                    <div class="invalid-feedback">Enter the customer's first name.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="lastName">Last name <span class="text-danger" aria-hidden="true">*</span></label>
                                    <input id="lastName" runat="server" class="form-control" type="text" required maxlength="24" autocomplete="family-name" />
                                    <div class="invalid-feedback">Enter the customer's last name.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="occupation">Occupation</label>
                                    <select id="occupation" runat="server" class="form-select" autocomplete="organization-title">
                                        <option value="Student">Student</option>
                                        <option value="Employed">Employed</option>
                                        <option value="Unemployed">Unemployed</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label" for="email">Email <span class="text-danger" aria-hidden="true">*</span></label>
                                    <input id="email" runat="server" class="form-control" type="email" required maxlength="32" autocomplete="email" />
                                    <div class="invalid-feedback">Enter a valid email address.</div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label" for="mobileNumber">Mobile number <span class="text-danger" aria-hidden="true">*</span></label>
                                    <div class="input-group">
                                        <span class="input-group-text">+63</span>
                                         <input id="mobileNumber" runat="server" ClientIDMode="Static" class="form-control" type="tel" inputmode="numeric" pattern="[0-9]+" required maxlength="10" autocomplete="tel-national" aria-describedby="mobileHelp" />
                                        <div class="invalid-feedback">Enter digits only for the mobile number.</div>
                                    </div>
                                    <div id="mobileHelp" class="form-text">Use digits only after the +63 prefix. Spaces are not allowed.</div>
                                </div>
                                <div class="col-12">
                                    <label class="form-label" for="organizationAddress">Organization address <span class="text-danger" aria-hidden="true">*</span></label>
                                    <textarea id="organizationAddress" runat="server" class="form-control" rows="4" required maxlength="300" autocomplete="street-address"></textarea>
                                    <div class="invalid-feedback">Enter the organization address.</div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <div class="photo-upload-panel">
                                <label class="form-label" for="customerPhoto">Identification photo</label>
                                <div class="photo-card" id="photoCard">
                                    <span id="photoPlaceholder">No attached photo</span>
                                    <img id="photoPreview" class="photo-preview d-none" alt="Customer identification photo preview" />
                                </div>
                                 <input id="customerPhoto" runat="server" ClientIDMode="Static" class="form-control mt-3" type="file" accept=".jpg,.png,.heic" aria-describedby="photoHelp" />
                                <div id="photoHelp" class="form-text">Accepted formats: JPG, PNG, and HEIC. HEIC preview depends on browser support.</div>
                                <div id="photoError" class="invalid-feedback d-block" hidden>Select a JPG, PNG, or HEIC image.</div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex flex-wrap justify-content-end gap-2 mt-4 pt-3 border-top">
                         <a class="btn btn-outline-secondary" href="<%: GetRouteUrl("RentalStaffNew", null) %>"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Back to customers</a>
                         <button id="registerButton" runat="server" class="btn btn-success" type="submit" onserverclick="RegisterButton_ServerClick">Register customer</button>
                    </div>
                </form>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/rentalstaff/RegisterCustomer.js?v=1") %>"></script>
</asp:Content>
