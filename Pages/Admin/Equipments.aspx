<%@ Page Title="Inventory" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Equipments.aspx.cs" Inherits="Techrent.Pages.Admin.Equipments" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/Inventory.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-2 mb-4">
        <div>
            <h1 class="h3 mb-1">Equipment inventory</h1>
            <p class="text-muted mb-0">Review equipment availability and rental details</p>
        </div>
        <p class="text-muted small mb-0"><%: DateTime.Now.ToString("dddd, dd MMMM yyyy hh:mm tt") %></p>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-12 col-md-4">
            <section class="card admin-card h-100">
                <div class="card-body">
                    <p class="text-muted small mb-2">Available equipment</p>
                    <p class="h3 mb-0">60</p>
                </div>
            </section>
        </div>
        <div class="col-12 col-md-4">
            <section class="card admin-card h-100">
                <div class="card-body">
                    <p class="text-muted small mb-2">Maintenance</p>
                    <p class="h3 mb-0">4</p>
                </div>
            </section>
        </div>
        <div class="col-12 col-md-4">
            <section class="card admin-card h-100">
                <div class="card-body">
                    <p class="text-muted small mb-2">Total inventory</p>
                    <p class="h3 mb-0">64</p>
                </div>
            </section>
        </div>
    </div>

    <section class="card admin-card">
        <div class="card-body">
            <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3 mb-3">
                <div class="d-flex align-items-center gap-2 inventory-sort-controls">
                    <label for="inventorySort" class="form-label mb-0 text-nowrap">Sort by</label>
                    <select id="inventorySort" class="form-select form-select-sm inventory-sort-select" aria-label="Sort inventory">
                        <option value="all">All equipments</option>
                        <option value="category">Category</option>
                        <option value="status">Status</option>
                        <option value="type">Type</option>
                    </select>
                </div>
                <div class="input-group inventory-search">
                    <span class="input-group-text bg-white" aria-hidden="true">
                        <img src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" />
                    </span>
                    <input type="search" id="inventorySearch" class="form-control" placeholder="Search equipment, model, or type" aria-label="Search inventory" />
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-sm align-middle mb-0 inventory-table">
                    <thead>
                        <tr>
                            <th scope="col">Equipment ID</th>
                            <th scope="col">Category</th>
                            <th scope="col">Model</th>
                            <th scope="col">Type</th>
                            <th scope="col">Status</th>
                            <th scope="col">Quantity</th>
                            <th scope="col" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody id="inventoryRows">
                        <asp:Repeater ID="InventoryRepeater" runat="server">
                            <ItemTemplate>
                                <tr data-category="<%#: Eval("Category") %>" data-status="<%#: Eval("Status") %>" data-type="<%#: Eval("Type") %>">
                                    <td><%#: Eval("EquipmentId") %></td>
                                    <td><%#: Eval("Category") %></td>
                                    <td><%#: Eval("Model") %></td>
                                    <td><%#: Eval("Type") %></td>
                                    <td><span class="inventory-status <%#: Eval("StatusClass") %>"><%#: Eval("Status") %></span></td>
                                    <td><%#: Eval("Quantity") %></td>
                                    <td class="text-center text-nowrap">
                                        <button type="button" class="btn btn-outline-primary btn-sm inventory-details-button" data-bs-toggle="modal" data-bs-target="#inventoryDetailsModal" data-equipment-id="<%#: Eval("EquipmentId") %>" data-serial-number="<%#: Eval("SerialNumber") %>" data-model="<%#: Eval("Model") %>" data-category="<%#: Eval("Category") %>" data-type="<%#: Eval("Type") %>" data-status="<%#: Eval("Status") %>" data-quantity="<%#: Eval("Quantity") %>" data-rental-rate="<%#: Eval("RentalRate") %>" data-deposit="<%#: Eval("Deposit") %>" data-date-added="<%#: Eval("DateAdded") %>">Show Details</button>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <p id="inventoryEmptyMessage" class="text-muted text-center py-4 mb-0" hidden>No equipment matches this search.</p>
            <nav class="mt-4" aria-label="Inventory pages">
                <ul class="pagination justify-content-center mb-0" id="inventoryPagination"></ul>
            </nav>
        </div>
    </section>

    <div class="modal fade" id="inventoryDetailsModal" tabindex="-1" aria-labelledby="inventoryDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="inventoryDetailsModalLabel">Equipment details</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-7">
                            <dl class="row mb-0 inventory-details-list">
                                <dt class="col-sm-5">Equipment ID</dt>
                                <dd class="col-sm-7" id="inventoryDetailEquipmentId"></dd>
                                <dt class="col-sm-5">Serial number</dt>
                                <dd class="col-sm-7" id="inventoryDetailSerialNumber"></dd>
                                <dt class="col-sm-5">Model</dt>
                                <dd class="col-sm-7" id="inventoryDetailModel"></dd>
                                <dt class="col-sm-5">Category</dt>
                                <dd class="col-sm-7" id="inventoryDetailCategory"></dd>
                                <dt class="col-sm-5">Type</dt>
                                <dd class="col-sm-7" id="inventoryDetailTypeValue"></dd>
                                <dt class="col-sm-5">Date added</dt>
                                <dd class="col-sm-7" id="inventoryDetailDateAdded"></dd>
                            </dl>
                        </div>
                        <div class="col-md-5">
                            <div class="inventory-image-placeholder" aria-label="Equipment image placeholder">Item image</div>
                        </div>
                    </div>
                    <hr />
                    <div class="row g-3">
                        <div class="col-sm-4">
                            <label for="inventoryDetailStatus" class="form-label">Equipment status</label>
                            <select id="inventoryDetailStatus" class="form-select">
                                <option>Available</option>
                                <option>In Maintenance</option>
                                <option>Rented</option>
                            </select>
                        </div>
                        <div class="col-sm-4">
                            <label for="inventoryDetailQuantity" class="form-label">Quantity</label>
                            <input type="number" id="inventoryDetailQuantity" class="form-control" min="0" />
                        </div>
                        <div class="col-sm-4">
                            <label for="inventoryDetailType" class="form-label">Equipment type</label>
                            <input type="text" id="inventoryDetailType" class="form-control" />
                        </div>
                    </div>
                    <div class="row g-3 mt-1">
                        <div class="col-sm-6">
                            <label for="inventoryDetailRentalRate" class="form-label">Base rental fee/hour</label>
                            <input type="text" id="inventoryDetailRentalRate" class="form-control" />
                        </div>
                        <div class="col-sm-6">
                            <label for="inventoryDetailDeposit" class="form-label">Security deposit/hour</label>
                            <input type="text" id="inventoryDetailDeposit" class="form-control" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Go back</button>
                    <button type="button" class="btn btn-primary" id="saveInventoryDetails">Save changes</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var rows = Array.prototype.slice.call(document.querySelectorAll('#inventoryRows tr'));
            var searchInput = document.getElementById('inventorySearch');
            var sortSelect = document.getElementById('inventorySort');
            var pagination = document.getElementById('inventoryPagination');
            var emptyMessage = document.getElementById('inventoryEmptyMessage');
            var currentPage = 1;
            var pageSize = 8;

            function getFilteredRows() {
                var query = searchInput.value.trim().toLowerCase();
                var sortKey = sortSelect.value;

                return rows.filter(function (row) {
                    return row.textContent.toLowerCase().indexOf(query) !== -1;
                }).sort(function (first, second) {
                    if (sortKey === 'all') {
                        return rows.indexOf(first) - rows.indexOf(second);
                    }
                    var firstValue = (first.dataset[sortKey] || '').toLowerCase();
                    var secondValue = (second.dataset[sortKey] || '').toLowerCase();
                    return firstValue.localeCompare(secondValue) || rows.indexOf(first) - rows.indexOf(second);
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
                pagination.innerHTML = '';
                addPageLink('Previous', currentPage - 1, currentPage === 1 || pageCount === 0);
                for (var page = 1; page <= pageCount; page++) {
                    addPageLink(page, page, false, page === currentPage);
                }
                addPageLink('Next', currentPage + 1, currentPage === pageCount || pageCount === 0);
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

            function setText(id, value) {
                document.getElementById(id).textContent = value || '';
            }

            document.querySelectorAll('.inventory-details-button').forEach(function (button) {
                button.addEventListener('click', function () {
                    setText('inventoryDetailEquipmentId', button.dataset.equipmentId);
                    setText('inventoryDetailSerialNumber', button.dataset.serialNumber);
                    setText('inventoryDetailModel', button.dataset.model);
                    setText('inventoryDetailCategory', button.dataset.category);
                    setText('inventoryDetailTypeValue', button.dataset.type);
                    setText('inventoryDetailDateAdded', button.dataset.dateAdded);
                    document.getElementById('inventoryDetailStatus').value = button.dataset.status;
                    document.getElementById('inventoryDetailQuantity').value = button.dataset.quantity;
                    document.getElementById('inventoryDetailType').value = button.dataset.type;
                    document.getElementById('inventoryDetailRentalRate').value = button.dataset.rentalRate;
                    document.getElementById('inventoryDetailDeposit').value = button.dataset.deposit;
                });
            });

            searchInput.addEventListener('input', function () {
                currentPage = 1;
                renderTable();
            });
            sortSelect.addEventListener('change', function () {
                currentPage = 1;
                renderTable();
            });
            renderTable();
        });
    </script>
</asp:Content>
