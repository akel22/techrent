<%@ Page Title="Audit Logs" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AuditLogs.aspx.cs" Inherits="Techrent.Pages.Admin.AuditLogs" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/AuditLogs.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-2 mb-4">
        <div>
            <h1 class="h3 mb-1">System Audit History</h1>
            <p class="text-muted mb-0">Review administrator and staff activity</p>
        </div>
        <p class="text-muted small mb-0"><%: DateTime.Now.ToString("dddd, dd MMMM yyyy hh:mm tt") %></p>
    </div>

    <section class="card admin-card">
        <div class="card-body">
            <div class="row g-3 align-items-end mb-4">
                <div class="col-12 col-sm-6 col-lg-2">
                    <label for="auditDateFrom" class="form-label">Date From</label>
                    <input type="date" id="auditDateFrom" class="form-control" />
                </div>
                <div class="col-12 col-sm-6 col-lg-2">
                    <label for="auditDateTo" class="form-label">Date To</label>
                    <input type="date" id="auditDateTo" class="form-control" />
                </div>
                <div class="col-12 col-sm-6 col-lg-2">
                    <label for="auditCategory" class="form-label">All Categories</label>
                    <select id="auditCategory" class="form-select">
                        <option value="">All Categories</option>
                        <option value="Account">Account</option>
                        <option value="Customer">Customer</option>
                        <option value="Inventory">Inventory</option>
                        <option value="Rental">Rental</option>
                    </select>
                </div>
                <div class="col-12 col-sm-6 col-lg-2">
                    <button type="button" id="applyAuditFilters" class="btn btn-primary w-100">Apply Filters</button>
                </div>
                <div class="col-12 col-lg-4">
                    <label for="auditSearch" class="form-label">Search audit logs</label>
                    <div class="input-group audit-search">
                        <span class="input-group-text bg-white" aria-hidden="true">
                            <img src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" />
                        </span>
                        <input type="search" id="auditSearch" class="form-control" placeholder="e.g. Role, Action by, Event" aria-label="Search audit logs" />
                    </div>
                </div>
            </div>

            <div id="auditFilterError" class="alert alert-danger py-2" role="alert" hidden></div>
            <div class="table-responsive">
                <table class="table table-sm align-middle mb-0 audit-table">
                    <thead>
                        <tr>
                            <th scope="col">Log ID</th>
                            <th scope="col">Action by</th>
                            <th scope="col">Role</th>
                            <th scope="col">Timestamp</th>
                            <th scope="col">Action</th>
                        </tr>
                    </thead>
                    <tbody id="auditRows">
                        <asp:Repeater ID="AuditLogsRepeater" runat="server">
                            <ItemTemplate>
                                <tr data-category="<%#: Eval("Category") %>" data-date="<%#: Eval("DateKey") %>" data-description="<%#: Eval("Description") %>" data-target="<%#: Eval("Target") %>" data-ip-address="<%#: Eval("IpAddress") %>">
                                    <td><%#: Eval("LogId") %></td>
                                    <td><%#: Eval("ActionBy") %></td>
                                    <td><%#: Eval("Role") %></td>
                                    <td><%#: Eval("Timestamp") %></td>
                                    <td><button type="button" class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#auditDetailsModal">Show Details</button></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <p id="auditEmptyMessage" class="text-muted text-center py-4 mb-0" hidden>No audit logs match these filters.</p>
            <nav class="mt-4" aria-label="Audit log pages">
                <ul class="pagination justify-content-center mb-0" id="auditPagination"></ul>
            </nav>
        </div>
    </section>

    <div class="modal fade" id="auditDetailsModal" tabindex="-1" aria-labelledby="auditDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="auditDetailsModalLabel">Audit Log Details</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <dl class="row mb-0">
                        <dt class="col-sm-4">Log ID</dt>
                        <dd class="col-sm-8" id="auditDetailLogId"></dd>
                        <dt class="col-sm-4">Action by</dt>
                        <dd class="col-sm-8" id="auditDetailActionBy"></dd>
                        <dt class="col-sm-4">Role</dt>
                        <dd class="col-sm-8" id="auditDetailRole"></dd>
                        <dt class="col-sm-4">Category</dt>
                        <dd class="col-sm-8" id="auditDetailCategory"></dd>
                        <dt class="col-sm-4">Timestamp</dt>
                        <dd class="col-sm-8" id="auditDetailTimestamp"></dd>
                        <dt class="col-sm-4">Event</dt>
                        <dd class="col-sm-8" id="auditDetailDescription"></dd>
                        <dt class="col-sm-4">Affected record</dt>
                        <dd class="col-sm-8" id="auditDetailTarget"></dd>
                        <dt class="col-sm-4">IP address</dt>
                        <dd class="col-sm-8" id="auditDetailIpAddress"></dd>
                    </dl>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/bootstrap.bundle.min.js") %>"></script>
    <script>
        document.getElementById('auditDetailsModal').addEventListener('show.bs.modal', function (event) {

            var row = event.relatedTarget.closest('tr');
            document.getElementById('auditDetailLogId').textContent = row.cells[0].textContent;
            document.getElementById('auditDetailActionBy').textContent = row.cells[1].textContent;
            document.getElementById('auditDetailRole').textContent = row.cells[2].textContent;
            document.getElementById('auditDetailTimestamp').textContent = row.cells[3].textContent;
            document.getElementById('auditDetailCategory').textContent = row.dataset.category;
            document.getElementById('auditDetailDescription').textContent = row.dataset.description;
            document.getElementById('auditDetailTarget').textContent = row.dataset.target;
            document.getElementById('auditDetailIpAddress').textContent = row.dataset.ipAddress;
        });

        document.addEventListener('DOMContentLoaded', function () {
            var rows = Array.prototype.slice.call(document.querySelectorAll('#auditRows tr'));
            var dateFromInput = document.getElementById('auditDateFrom');
            var dateToInput = document.getElementById('auditDateTo');
            var categorySelect = document.getElementById('auditCategory');
            var searchInput = document.getElementById('auditSearch');
            var applyButton = document.getElementById('applyAuditFilters');
            var errorMessage = document.getElementById('auditFilterError');
            var emptyMessage = document.getElementById('auditEmptyMessage');
            var pagination = document.getElementById('auditPagination');
            var currentPage = 1;
            var pageSize = 8;
            var appliedQuery = '';
            var filters = { dateFrom: '', dateTo: '', category: '', query: '' };

            function applyFilters() {
                var dateFrom = dateFromInput.value;
                var dateTo = dateToInput.value;

                if (dateFrom && dateTo && dateFrom > dateTo) {
                    errorMessage.textContent = 'Date From must be on or before Date To.';
                    errorMessage.hidden = false;
                    dateFromInput.focus();
                    return;
                }

                errorMessage.textContent = '';
                errorMessage.hidden = true;
                filters = {
                    dateFrom: dateFrom,
                    dateTo: dateTo,
                    category: categorySelect.value,
                    query: appliedQuery
                };
                currentPage = 1;
                renderTable();
            }

            function getFilteredRows() {
                return rows.filter(function (row) {
                    var date = row.dataset.date;
                    var matchesDateFrom = !filters.dateFrom || date >= filters.dateFrom;
                    var matchesDateTo = !filters.dateTo || date <= filters.dateTo;
                    var matchesCategory = !filters.category || row.dataset.category === filters.category;
                    var searchableText = [row.textContent, row.dataset.category, row.dataset.description, row.dataset.target]
                        .join(' ').toLowerCase();
                    return matchesDateFrom && matchesDateTo && matchesCategory && searchableText.indexOf(filters.query) !== -1;
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

            applyButton.addEventListener('click', applyFilters);
            searchInput.addEventListener('keydown', function (event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    appliedQuery = searchInput.value.trim().toLowerCase();
                    applyFilters();
                }
            });
            applyFilters();
        });
    </script>
</asp:Content>
