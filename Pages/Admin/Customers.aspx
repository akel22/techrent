<%@ Page Title="Customers" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Customers.aspx.cs" Inherits="Techrent.Pages.Admin.Customers" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/Customers.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-2 mb-4">
        <div>
            <h1 class="h3 mb-1">Manage Customers</h1>
            <p class="text-muted mb-0">Review customer profiles and rental history</p>
        </div>
        <p class="text-muted small mb-0"><%: DateTime.Now.ToString("dddd, dd MMMM yyyy hh:mm tt") %></p>
    </div>

    <section class="card admin-card">
        <div class="card-body">
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-3">
                <div class="input-group customer-search">
                    <span class="input-group-text bg-white" aria-hidden="true">
                        <img src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" />
                    </span>
                    <input type="search" id="customerSearch" class="form-control" placeholder="e.g. Full Name, Email, Mobile Number" aria-label="Search customers" />
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-sm align-middle mb-0 customer-table">
                    <thead>
                        <tr>
                            <th scope="col">Customer ID</th>
                            <th scope="col">Full Name</th>
                            <th scope="col">Mobile Number</th>
                            <th scope="col">Email</th>
                            <th scope="col" class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="customerRows">
                        <asp:Repeater ID="CustomersRepeater" runat="server">
                            <ItemTemplate>
                                <tr data-customer-id="<%#: Eval("CustomerId") %>"
                                    data-first-name="<%#: Eval("FirstName") %>"
                                    data-last-name="<%#: Eval("LastName") %>"
                                    data-email="<%#: Eval("Email") %>"
                                    data-mobile-number="<%#: Eval("MobileNumber") %>"
                                    data-telephone-number="<%#: Eval("TelephoneNumber") %>"
                                    data-organization="<%#: Eval("Organization") %>"
                                    data-address="<%#: Eval("Address") %>"
                                    data-account-status="<%#: Eval("AccountStatus") %>">
                                    <td><%#: Eval("CustomerId") %></td>
                                    <td><%#: Eval("FullName") %></td>
                                    <td><%#: Eval("MobileNumber") %></td>
                                    <td><%#: Eval("Email") %></td>
                                    <td class="text-center text-nowrap">
                                        <button type="button" class="btn btn-danger btn-sm customer-remove-button" data-bs-toggle="modal" data-bs-target="#removeCustomerModal">Remove</button>
                                        <button type="button" class="btn btn-outline-secondary btn-sm customer-details-button" data-bs-toggle="modal" data-bs-target="#customerDetailsModal">Show Details</button>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <p id="customerEmptyMessage" class="text-muted text-center py-4 mb-0" hidden>No customers match your search.</p>
            <nav class="mt-4" aria-label="Customer pages">
                <ul class="pagination justify-content-center mb-0" id="customerPagination"></ul>
            </nav>
        </div>
    </section>

    <div class="modal fade" id="customerDetailsModal" tabindex="-1" aria-labelledby="customerDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="customerDetailsModalLabel">Edit Customer Details</h2>
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
                            <div class="customer-profile-placeholder me-4" aria-label="Customer profile image placeholder">Profile image</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer justify-content-between">
                    <a href="#" class="link-primary">View transaction history</a>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Go back</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="removeCustomerModal" tabindex="-1" aria-labelledby="removeCustomerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="removeCustomerModalLabel">Remove customer?</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger mb-3">
                        <p class="mb-2">The following data will also be deleted:</p>
                        <ul class="mb-0">
                            <li>All transactions for <strong id="removeCustomerId"></strong></li>
                            <li>Identification and profile information</li>
                        </ul>
                    </div>
                    <p class="text-danger small mb-0 text-center">Once deleted, this action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-bs-dismiss="modal">Delete Record</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/bootstrap.bundle.min.js") %>"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var rows = Array.prototype.slice.call(document.querySelectorAll('#customerRows tr'));
            var searchInput = document.getElementById('customerSearch');
            var pagination = document.getElementById('customerPagination');
            var emptyMessage = document.getElementById('customerEmptyMessage');
            var currentPage = 1;
            var pageSize = 8;
            var appliedQuery = '';

            function getFilteredRows() {
                return rows.filter(function (row) {
                    var searchableText = [row.dataset.customerId, row.dataset.firstName, row.dataset.lastName, row.dataset.email, row.dataset.mobileNumber]
                        .join(' ').toLowerCase();
                    return searchableText.indexOf(appliedQuery) !== -1;
                });
            }

            function renderTable() {
                var filteredRows = getFilteredRows();
                var pageCount = Math.ceil(filteredRows.length / pageSize);
                currentPage = Math.min(Math.max(currentPage, 1), Math.max(pageCount, 1));

                rows.forEach(function (row) { row.hidden = true; });
                filteredRows.slice((currentPage - 1) * pageSize, currentPage * pageSize).forEach(function (row) {
                    row.hidden = false;
                });

                emptyMessage.hidden = filteredRows.length !== 0;
                pagination.parentElement.hidden = filteredRows.length === 0;
                pagination.innerHTML = '';
                if (pageCount === 0) {
                    return;
                }

                addPageLink('Previous', currentPage - 1, currentPage === 1);
                for (var page = 1; page <= pageCount; page++) {
                    addPageLink(page, page, false, page === currentPage);
                }
                addPageLink('Next', currentPage + 1, currentPage === pageCount);
            }

            function addPageLink(label, page, disabled, active) {
                var item = document.createElement('li');
                item.className = 'page-item' + (disabled ? ' disabled' : '') + (active ? ' active' : '');
                var link = document.createElement('button');
                link.type = 'button';
                link.className = 'page-link';
                link.textContent = label;
                link.disabled = disabled;
                if (active) {
                    link.setAttribute('aria-current', 'page');
                }
                link.addEventListener('click', function () {
                    currentPage = page;
                    renderTable();
                });
                item.appendChild(link);
                pagination.appendChild(item);
            }

            searchInput.addEventListener('keydown', function (event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    appliedQuery = searchInput.value.trim().toLowerCase();
                    currentPage = 1;
                    renderTable();
                }
            });

            document.getElementById('customerDetailsModal').addEventListener('show.bs.modal', function (event) {
                var row = event.relatedTarget.closest('tr');
                document.getElementById('customerDetailId').textContent = row.dataset.customerId;
                document.getElementById('customerDetailFirstName').textContent = row.dataset.firstName;
                document.getElementById('customerDetailLastName').textContent = row.dataset.lastName;
                document.getElementById('customerDetailEmail').textContent = row.dataset.email;
                document.getElementById('customerDetailMobile').textContent = row.dataset.mobileNumber;
                document.getElementById('customerDetailTelephone').textContent = row.dataset.telephoneNumber;
                document.getElementById('customerDetailOrganization').textContent = row.dataset.organization;
                document.getElementById('customerDetailAddress').textContent = row.dataset.address;
                document.getElementById('customerDetailStatus').textContent = row.dataset.accountStatus;
            });

            document.getElementById('removeCustomerModal').addEventListener('show.bs.modal', function (event) {
                var row = event.relatedTarget.closest('tr');
                document.getElementById('removeCustomerId').textContent = row.dataset.customerId;
            });

            renderTable();
        });
    </script>
</asp:Content>
