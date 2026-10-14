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
                    <asp:Button ID="ApplyAuditFiltersButton" runat="server" CssClass="btn btn-primary w-100" Text="Apply Filters" OnClick="ApplyAuditFilters_Click" />
                </div>
                <div class="col-12 col-lg-4">
                    <label for="auditSearch" class="form-label">Search audit logs</label>
                    <div class="input-group audit-search">
                        <span class="input-group-text bg-white" aria-hidden="true">
                            <img src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" />
                        </span>
                        <asp:TextBox ID="AuditSearch" runat="server" CssClass="form-control" placeholder="e.g. Role, Action by, Event" />
                    </div>
                </div>
            </div>
            <div id="auditFilterError" runat="server" class="alert alert-danger py-2" role="alert" hidden></div>
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
                                <tr data-category="<%#: Eval("Category") %>" data-date="<%#: Eval("DateKey") %>" data-description="<%#: Eval("Description") %>">
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
            <p id="auditEmptyMessage" runat="server" class="text-muted text-center py-4 mb-0" hidden>No audit logs match these filters.</p>
            <nav class="mt-4" aria-label="Audit log pages">
                <ul class="pagination justify-content-center mb-0" id="auditPagination" runat="server"></ul>
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
                        <!-- Affected record and IP address are not available in the current audit contract -->
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
        });
    </script>
</asp:Content>
