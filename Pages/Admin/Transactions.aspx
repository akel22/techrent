<%@ Page Title="Transactions" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="Techrent.Pages.Admin.Transactions" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/Transactions.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-1">Transaction logs</h1>
            <p class="text-muted mb-0">Review and manage rental transactions</p>
        </div>
        <p class="text-muted small mb-0"><%: DateTime.Now.ToString("dddd, dd MMMM yyyy hh:mm tt") %></p>
    </div>

    <section class="card admin-card">
        <div class="card-body">
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-3">
                <div class="d-flex align-items-center gap-2 transaction-sort-controls">
                    <label for="transactionSort" class="form-label mb-0 text-nowrap">Sort by</label>
                    <select id="transactionSort" class="form-select form-select-sm transaction-sort-select" aria-label="Sort by created date">
                        <option value="latest" selected>Latest date</option>
                        <option value="earliest">Earliest date</option>
                    </select>
                </div>
                <div class="input-group transaction-search">
                    <span class="input-group-text bg-white" aria-hidden="true">
                        <img src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" />
                    </span>
                    <input type="search" id="transactionSearch" class="form-control" placeholder="Search transaction, customer, date, or status" aria-label="Search transactions" />
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-sm align-middle mb-0 transaction-table">
                    <thead>
                        <tr>
                            <th scope="col">Transaction ID</th>
                            <th scope="col">Customer ID</th>
                            <th scope="col">CreatedAt</th>
                            <th scope="col">DueAt</th>
                            <th scope="col">Status</th>
                            <th scope="col" class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody id="transactionRows">
                        <asp:Repeater ID="TransactionsRepeater" runat="server">
                            <ItemTemplate>
                                <tr data-detail-payload="<%#: Eval("DetailPayload") %>">
                                    <td><%#: Eval("TransactionId") %></td>
                                    <td><%#: Eval("CustomerId") %></td>
                                    <td><%#: Eval("CreatedAt") %></td>
                                    <td><%#: Eval("DueAt") %></td>
                                    <td><span class="transaction-status <%#: Eval("StatusClass") %>"><%#: Eval("Status") %></span></td>
                                    <td class="text-center text-nowrap">
                                        <button type="button" class="btn btn-secondary btn-sm" disabled>Archive</button>
                                        <button type="button" class="btn btn-outline-primary btn-sm transaction-view-button" data-bs-toggle="modal" data-bs-target="#transactionDetailsModal">View</button>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

            <nav class="mt-4" aria-label="Transaction pages">
                <ul class="pagination justify-content-center mb-0" id="transactionPagination"></ul>
            </nav>
        </div>
    </section>

    <div class="modal fade" id="transactionDetailsModal" tabindex="-1" aria-labelledby="transactionDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="transactionDetailsModalLabel">Transaction Details</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="transactionPrintContent">
                    <div class="row g-4">
                        <div class="col-lg-8">
                            <section class="transaction-detail-section mb-3" aria-labelledby="transactionSummaryHeading">
                                <dl class="row mb-0 transaction-detail-list">
                                    <dt class="col-sm-4">Transaction ID</dt>
                                    <dd class="col-sm-8" id="transactionDetailId"></dd>
                                    <dt class="col-sm-4">Customer ID</dt>
                                    <dd class="col-sm-8" id="transactionDetailCustomer"></dd>
                                    <dt class="col-sm-4">Created date</dt>
                                    <dd class="col-sm-8" id="transactionDetailCreated"></dd>
                                    <dt class="col-sm-4">Expiration</dt>
                                    <dd class="col-sm-8" id="transactionDetailExpiration"></dd>
                                    <dt class="col-sm-4">Status</dt>
                                    <dd class="col-sm-8" id="transactionDetailStatus"></dd>
                                </dl>
                            </section>

                            <section class="transaction-detail-section mb-3" aria-labelledby="equipmentHeading">
                                <h3 class="h6 transaction-detail-heading" id="equipmentHeading">Rented equipment</h3>
                                <div id="transactionEquipmentDetails" class="transaction-detail-items"></div>
                            </section>

                            <section class="transaction-detail-section mb-0" aria-labelledby="preRentalHeading">
                                <h3 class="h6 transaction-detail-heading" id="preRentalHeading">Pre-rental details</h3>
                                <p class="small text-muted">Inspection entries shown from the transaction audit log.</p>
                                <div id="transactionPreRentalDetails" class="transaction-detail-items"></div>
                            </section>
                        </div>
                        <div class="col-lg-4">
                            <section class="receipt-placeholder-card" aria-labelledby="receiptHeading">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h3 class="h6 mb-0" id="receiptHeading">Receipt</h3>
                                    <span class="badge text-bg-light">Placeholder</span>
                                </div>
                                <div class="receipt-placeholder-body">
                                    <p class="small text-muted mb-2">Receipt preview will be connected to the rental record later.</p>
                                    <dl class="small mb-0">
                                        <dt>Receipt number</dt>
                                        <dd>To be generated</dd>
                                        <dt>Total</dt>
                                        <dd>To be calculated</dd>
                                    </dl>
                                </div>
                            </section>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="printTransactionButton">Print details</button>
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var rows = Array.prototype.slice.call(document.querySelectorAll('#transactionRows tr'));
            var searchInput = document.getElementById('transactionSearch');
            var pagination = document.getElementById('transactionPagination');
            var sortSelect = document.getElementById('transactionSort');
            var currentPage = 1;
            var pageSize = 8;
            var appliedQuery = '';

            function setDetailText(id, value) {
                document.getElementById(id).textContent = value || '—';
            }

            function createDetailItem(title, values) {
                var item = document.createElement('div');
                item.className = 'transaction-detail-item';

                var heading = document.createElement('h4');
                heading.className = 'small fw-semibold mb-2';
                heading.textContent = title;
                item.appendChild(heading);

                var details = document.createElement('dl');
                details.className = 'row small mb-0';
                values.forEach(function (value) {
                    var term = document.createElement('dt');
                    term.className = 'col-sm-5 text-muted';
                    term.textContent = value.label;
                    var description = document.createElement('dd');
                    description.className = 'col-sm-7';
                    description.textContent = value.text || '—';
                    details.appendChild(term);
                    details.appendChild(description);
                });
                item.appendChild(details);
                return item;
            }

            function populateTransactionModal(transaction) {
                setDetailText('transactionDetailId', transaction.TransactionId);
                setDetailText('transactionDetailCustomer', transaction.CustomerId);
                setDetailText('transactionDetailCreated', transaction.CreatedAt);
                setDetailText('transactionDetailExpiration', transaction.Expiration);

                var status = document.getElementById('transactionDetailStatus');
                status.textContent = transaction.Status || '—';
                status.className = 'col-sm-8 transaction-status ' + (transaction.StatusClass || '');

                var equipmentDetails = document.getElementById('transactionEquipmentDetails');
                equipmentDetails.innerHTML = '';
                transaction.Equipment.forEach(function (equipment) {
                    equipmentDetails.appendChild(createDetailItem(equipment.Name, [
                        { label: 'Serial number', text: equipment.SerialNumber },
                        { label: 'Rental rate', text: equipment.Rate },
                        { label: 'Security deposit', text: equipment.Deposit }
                    ]));
                });

                var preRentalDetails = document.getElementById('transactionPreRentalDetails');
                preRentalDetails.innerHTML = '';
                transaction.PreRentalDetails.forEach(function (detail) {
                    preRentalDetails.appendChild(createDetailItem(detail.EquipmentSerialNumber, [
                        { label: 'Inspection note', text: detail.Issue },
                        { label: 'Recorded by', text: detail.RecordedBy }
                    ]));
                });
            }

            function printTransactionDetails() {
                var printWindow = window.open('', '_blank', 'width=900,height=700');
                if (!printWindow) {
                    return;
                }

                var bootstrapStylesheet = '<%: ResolveUrl("~/Content/bootstrap.min.css") %>';
                var transactionStylesheet = '<%: ResolveUrl("~/css/admin/Transactions.css") %>';
                printWindow.document.write('<!doctype html><html lang="en"><head><meta charset="utf-8"><title>Transaction details</title><link rel="stylesheet" href="' + bootstrapStylesheet + '"><link rel="stylesheet" href="' + transactionStylesheet + '"></head><body class="transaction-print-page"><main class="container py-4"><h1 class="h4 mb-4">Transaction details</h1>' + document.getElementById('transactionPrintContent').innerHTML + '</main></body></html>');
                printWindow.document.close();
                printWindow.focus();
                setTimeout(function () {
                    printWindow.print();
                    printWindow.close();
                }, 250);
            }

            document.getElementById('transactionDetailsModal').addEventListener('show.bs.modal', function (event) {
                var row = event.relatedTarget.closest('tr');
                populateTransactionModal(JSON.parse(row.getAttribute('data-detail-payload')));
            });

            document.getElementById('printTransactionButton').addEventListener('click', printTransactionDetails);

            function getFilteredRows() {
                return rows.filter(function (row) {
                    return row.textContent.toLowerCase().indexOf(appliedQuery) !== -1;
                }).sort(function (first, second) {
                    var comparison = first.cells[2].textContent.localeCompare(second.cells[2].textContent);
                    return sortSelect.value === 'latest' ? -comparison : comparison;
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

                pagination.innerHTML = '';
                addPageLink('Previous', currentPage - 1, currentPage === 1);
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
                if (active) {
                    link.setAttribute('aria-current', 'page');
                }
                link.disabled = disabled;
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

            sortSelect.addEventListener('change', function () {
                currentPage = 1;
                renderTable();
            });

            renderTable();
        });
    </script>
</asp:Content>
