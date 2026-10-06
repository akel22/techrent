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
                    <button type="button" class="btn-close" id="customerDetailsCloseButton" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-4">
                        <div class="col-md-7">
                            <dl class="row mb-0 customer-details-list">
                                <dt class="col-sm-5">Customer ID</dt>
                                <dd class="col-sm-7" id="customerDetailId"></dd>
                                <dt class="col-sm-5">First Name</dt>
                                <dd class="col-sm-7"><input type="text" class="form-control form-control-sm" id="customerDetailFirstName" aria-label="First Name" /></dd>
                                <dt class="col-sm-5">Last Name</dt>
                                <dd class="col-sm-7"><input type="text" class="form-control form-control-sm" id="customerDetailLastName" aria-label="Last Name" /></dd>
                                <dt class="col-sm-5">Email</dt>
                                <dd class="col-sm-7"><input type="email" class="form-control form-control-sm" id="customerDetailEmail" aria-label="Email" /></dd>
                                <dt class="col-sm-5">Mobile Number</dt>
                                <dd class="col-sm-7"><input type="tel" class="form-control form-control-sm" id="customerDetailMobile" aria-label="Mobile Number" /></dd>
                                <dt class="col-sm-5">Telephone Number</dt>
                                <dd class="col-sm-7"><input type="tel" class="form-control form-control-sm" id="customerDetailTelephone" aria-label="Telephone Number" /></dd>
                                <dt class="col-sm-5">Organization</dt>
                                <dd class="col-sm-7"><input type="text" class="form-control form-control-sm" id="customerDetailOrganization" aria-label="Organization" /></dd>
                                <dt class="col-sm-5">Organization Address</dt>
                                <dd class="col-sm-7"><input type="text" class="form-control form-control-sm" id="customerDetailAddress" aria-label="Organization Address" /></dd>
                                <dt class="col-sm-5">Account Status</dt>
                                <dd class="col-sm-7">
                                    <select class="form-select form-select-sm" id="customerDetailStatus" aria-label="Account Status">
                                        <option value="Active">Active</option>
                                        <option value="Inactive">Inactive</option>
                                    </select>
                                </dd>
                            </dl>
                        </div>
                        <div class="col-md-5">
                            <div class="customer-profile-placeholder me-4" aria-label="Customer profile image placeholder">Profile image</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer flex-column align-items-stretch gap-3">
                    <div class="alert alert-warning mb-0" role="alert">Make sure this customer does not have an active transaction to avoid conflict</div>
                    <div class="d-flex justify-content-between align-items-center">
                        <button type="button" class="btn btn-link p-0" id="customerTransactionHistoryButton">View transaction history</button>
                        <div class="d-flex gap-2">
                            <button type="button" class="btn btn-primary" id="customerSaveChangesButton">Save Changes</button>
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Go back</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="customerTransactionHistoryModal" tabindex="-1" aria-labelledby="customerTransactionHistoryModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <h2 class="modal-title h5 mb-1" id="customerTransactionHistoryModalLabel">Transaction History</h2>
                        <p class="text-muted small mb-0" id="customerTransactionHistoryCustomer"></p>
                    </div>
                    <button type="button" class="btn-close" id="customerTransactionHistoryCloseButton" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="table-responsive">
                        <table class="table table-sm align-middle mb-0 customer-transaction-history-table">
                            <thead>
                                <tr>
                                    <th scope="col">Transaction ID</th>
                                    <th scope="col">Created At</th>
                                    <th scope="col">Due At</th>
                                    <th scope="col">Status</th>
                                </tr>
                            </thead>
                            <tbody id="customerTransactionHistoryRows"></tbody>
                        </table>
                    </div>
                    <p id="customerTransactionHistoryEmptyMessage" class="text-muted text-center py-4 mb-0" hidden>No transactions found for this customer.</p>
                    <nav class="mt-4" aria-label="Customer transaction history pages">
                        <ul class="pagination justify-content-center mb-0" id="customerTransactionHistoryPagination"></ul>
                    </nav>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" id="customerTransactionHistoryBackButton"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Go back</button>
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
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal"><img src="<%: ResolveUrl("~/assets/svg/back.svg") %>" alt="" aria-hidden="true" width="16" height="16" class="me-1" />Cancel</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/bootstrap.bundle.min.js") %>"></script>
    <script>
        window.customerTransactionHistory = <%= TransactionHistoryJson %>;

        document.addEventListener('DOMContentLoaded', function () {
            var rows = Array.prototype.slice.call(document.querySelectorAll('#customerRows tr'));
            var searchInput = document.getElementById('customerSearch');
            var pagination = document.getElementById('customerPagination');
            var emptyMessage = document.getElementById('customerEmptyMessage');
            var currentPage = 1;
            var pageSize = 8;
            var appliedQuery = '';
            var selectedCustomer = null;
            var historyCurrentPage = 1;
            var historyPageSize = 5;
            var transactionHistory = window.customerTransactionHistory || [];
            var historyRows = document.getElementById('customerTransactionHistoryRows');
            var historyPagination = document.getElementById('customerTransactionHistoryPagination');
            var historyEmptyMessage = document.getElementById('customerTransactionHistoryEmptyMessage');
            var customerDetailsModalElement = document.getElementById('customerDetailsModal');
            var customerTransactionHistoryModalElement = document.getElementById('customerTransactionHistoryModal');
            var customerDetailsModal = bootstrap.Modal.getOrCreateInstance(customerDetailsModalElement);
            var customerTransactionHistoryModal = bootstrap.Modal.getOrCreateInstance(customerTransactionHistoryModalElement);

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

            function addHistoryPageLink(label, page, disabled, active) {
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
                    historyCurrentPage = page;
                    renderTransactionHistory();
                });
                item.appendChild(link);
                historyPagination.appendChild(item);
            }

            function renderTransactionHistory() {
                var customerTransactions = transactionHistory.filter(function (transaction) {
                    return transaction.CustomerId === selectedCustomer.customerId;
                });
                var pageCount = Math.ceil(customerTransactions.length / historyPageSize);
                historyCurrentPage = Math.min(Math.max(historyCurrentPage, 1), Math.max(pageCount, 1));
                historyRows.innerHTML = '';
                customerTransactions.slice((historyCurrentPage - 1) * historyPageSize, historyCurrentPage * historyPageSize).forEach(function (transaction) {
                    var row = document.createElement('tr');
                    [transaction.TransactionId, transaction.CreatedAt, transaction.DueAt, transaction.Status].forEach(function (value) {
                        var cell = document.createElement('td');
                        cell.textContent = value || '—';
                        row.appendChild(cell);
                    });
                    historyRows.appendChild(row);
                });

                historyEmptyMessage.hidden = customerTransactions.length !== 0;
                historyPagination.parentElement.hidden = customerTransactions.length === 0;
                historyPagination.innerHTML = '';
                if (pageCount === 0) {
                    return;
                }

                addHistoryPageLink('Previous', historyCurrentPage - 1, historyCurrentPage === 1);
                for (var page = 1; page <= pageCount; page++) {
                    addHistoryPageLink(page, page, false, page === historyCurrentPage);
                }
                addHistoryPageLink('Next', historyCurrentPage + 1, historyCurrentPage === pageCount);
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
                if (!event.relatedTarget) {
                    return;
                }

                var row = event.relatedTarget.closest('tr');
                selectedCustomer = {
                    customerId: row.dataset.customerId,
                    fullName: row.dataset.firstName + ' ' + row.dataset.lastName,
                    row: row
                };
                document.getElementById('customerDetailId').textContent = row.dataset.customerId;
                document.getElementById('customerDetailFirstName').value = row.dataset.firstName;
                document.getElementById('customerDetailLastName').value = row.dataset.lastName;
                document.getElementById('customerDetailEmail').value = row.dataset.email;
                document.getElementById('customerDetailMobile').value = row.dataset.mobileNumber;
                document.getElementById('customerDetailTelephone').value = row.dataset.telephoneNumber;
                document.getElementById('customerDetailOrganization').value = row.dataset.organization;
                document.getElementById('customerDetailAddress').value = row.dataset.address;
                document.getElementById('customerDetailStatus').value = row.dataset.accountStatus;
            });

            document.getElementById('customerTransactionHistoryButton').addEventListener('click', function () {
                customerDetailsModalElement.addEventListener('hidden.bs.modal', function () {
                    customerTransactionHistoryModal.show();
                }, { once: true });
                customerDetailsModal.hide();
            });

            document.getElementById('customerTransactionHistoryModal').addEventListener('show.bs.modal', function () {
                if (!selectedCustomer) {
                    return;
                }

                historyCurrentPage = 1;
                document.getElementById('customerTransactionHistoryCustomer').textContent = selectedCustomer.customerId + ' — ' + selectedCustomer.fullName;
                renderTransactionHistory();
            });

            document.getElementById('customerTransactionHistoryBackButton').addEventListener('click', function () {
                customerTransactionHistoryModalElement.addEventListener('hidden.bs.modal', function () {
                    if (selectedCustomer) {
                        customerDetailsModal.show();
                    }
                }, { once: true });
                customerTransactionHistoryModal.hide();
            });

            document.getElementById('customerSaveChangesButton').addEventListener('click', function () {
                if (!selectedCustomer) {
                    return;
                }

                var row = selectedCustomer.row;
                var firstName = document.getElementById('customerDetailFirstName').value.trim();
                var lastName = document.getElementById('customerDetailLastName').value.trim();
                var email = document.getElementById('customerDetailEmail').value.trim();
                var mobileNumber = document.getElementById('customerDetailMobile').value.trim();
                var telephoneNumber = document.getElementById('customerDetailTelephone').value.trim();
                var organization = document.getElementById('customerDetailOrganization').value.trim();
                var address = document.getElementById('customerDetailAddress').value.trim();
                var accountStatus = document.getElementById('customerDetailStatus').value;

                row.dataset.firstName = firstName;
                row.dataset.lastName = lastName;
                row.dataset.email = email;
                row.dataset.mobileNumber = mobileNumber;
                row.dataset.telephoneNumber = telephoneNumber;
                row.dataset.organization = organization;
                row.dataset.address = address;
                row.dataset.accountStatus = accountStatus;
                row.cells[1].textContent = firstName + ' ' + lastName;
                row.cells[2].textContent = mobileNumber;
                row.cells[3].textContent = email;
                selectedCustomer.fullName = firstName + ' ' + lastName;
            });

            document.getElementById('removeCustomerModal').addEventListener('show.bs.modal', function (event) {
                var row = event.relatedTarget.closest('tr');
                document.getElementById('removeCustomerId').textContent = row.dataset.customerId;
            });

            renderTable();
        });
    </script>
</asp:Content>
