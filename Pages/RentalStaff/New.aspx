<%@ Page Title="New Transaction" Language="C#" MasterPageFile="~/Pages/RentalStaff/RentalStaff.Master" AutoEventWireup="true" CodeBehind="New.aspx.cs" Inherits="Techrent.Pages.RentalStaff.New" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/rentalstaff/RentalStaff.New.css?v=1") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <section class="rental-staff-new" aria-labelledby="newTransactionHeading">
        <div class="d-flex flex-wrap align-items-end justify-content-between gap-3 mb-4">
            <div>
                <p class="text-uppercase text-muted small fw-semibold mb-1">Step 1 of 2</p>
                <h1 id="newTransactionHeading" class="h3 mb-2">Select a customer</h1>
                <p class="text-muted mb-0">Choose the customer for this rental transaction.</p>
            </div>
            <a class="btn btn-outline-secondary" href="<%: GetRouteUrl("RentalStaff", null) %>">Cancel</a>
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
                            <tr data-customer-search="CUS-1001 maria santos maria.santos@example.com 09171234567">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Maria Santos</span>
                                    <span class="small text-muted">CUS-1001</span>
                                </th>
                                <td>
                                    <span class="d-block">maria.santos@example.com</span>
                                    <span class="small text-muted">0917 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1002 john dela cruz john.delacruz@example.com 09181234567">
                                <th scope="row">
                                    <span class="d-block fw-semibold">John Dela Cruz</span>
                                    <span class="small text-muted">CUS-1002</span>
                                </th>
                                <td>
                                    <span class="d-block">john.delacruz@example.com</span>
                                    <span class="small text-muted">0918 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1003 ana reyes ana.reyes@example.com 09191234567">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Ana Reyes</span>
                                    <span class="small text-muted">CUS-1003</span>
                                </th>
                                <td>
                                    <span class="d-block">ana.reyes@example.com</span>
                                    <span class="small text-muted">0919 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1004 carlos navarro carlos.navarro@example.com 09201234567">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Carlos Navarro</span>
                                    <span class="small text-muted">CUS-1004</span>
                                </th>
                                <td>
                                    <span class="d-block">carlos.navarro@example.com</span>
                                    <span class="small text-muted">0920 123 4567</span>
                                </td>
                                <td class="text-md-end">
                                    <a class="btn btn-success btn-sm" href="<%: GetRouteUrl("RentalStaffEquipment", null) %>">Select customer</a>
                                </td>
                            </tr>
                            <tr data-customer-search="CUS-1005 leah tan leah.tan@example.com 09211234567">
                                <th scope="row">
                                    <span class="d-block fw-semibold">Leah Tan</span>
                                    <span class="small text-muted">CUS-1005</span>
                                </th>
                                <td>
                                    <span class="d-block">leah.tan@example.com</span>
                                    <span class="small text-muted">0921 123 4567</span>
                                </td>
                                <td class="text-md-end">
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
</asp:Content>

<asp:Content ID="PageScriptsContent" ContentPlaceHolderID="PageScripts" runat="server">
    <script>
        (function () {
            var search = document.getElementById('customerSearch');
            var rows = Array.prototype.slice.call(document.querySelectorAll('#customerList tr'));
            var count = document.getElementById('customerCount');
            var emptyMessage = document.getElementById('noCustomersMessage');

            function filterCustomers() {
                var term = search.value.toLowerCase().trim();
                var visible = 0;

                rows.forEach(function (row) {
                    var matches = !term || row.getAttribute('data-customer-search').indexOf(term) !== -1;
                    row.classList.toggle('d-none', !matches);
                    if (matches) {
                        visible++;
                    }
                });

                count.textContent = visible + (visible === 1 ? ' customer' : ' customers');
                emptyMessage.classList.toggle('d-none', visible !== 0);
            }

            search.addEventListener('keydown', function (event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    filterCustomers();
                }
            });
        }());
    </script>
</asp:Content>
