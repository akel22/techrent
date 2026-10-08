<%@ Page Title="Transactions" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Transactions.aspx.cs" Inherits="Techrent.Pages.Admin.Transactions" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/Transactions.css?v=2") %>" rel="stylesheet" />
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
                <asp:Label ID="ArchiveMessage" runat="server" CssClass="alert alert-warning d-block" Visible="false" />
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-3">
                <div class="d-flex align-items-center gap-2 transaction-sort-controls">
                    <label for="transactionSort" class="form-label mb-0 text-nowrap">Sort by</label>
                    <select id="transactionSort" class="form-select form-select-sm transaction-sort-select" aria-label="Sort by created date">
                        <option value="latest" selected>Latest date</option>
                        <option value="earliest">Earliest date</option>
                    </select>
                    <label for="transactionStatus" class="form-label mb-0 text-nowrap ms-2">Status</label>
                    <select id="transactionStatus" class="form-select form-select-sm transaction-status-select" aria-label="Filter by transaction status">
                        <option value="all" selected>All</option>
                        <option value="Ongoing">Ongoing</option>
                        <option value="Late">Late</option>
                        <option value="Overdue">Overdue</option>
                        <option value="Done">Done</option>
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
                        <asp:Repeater ID="TransactionsRepeater" runat="server" OnItemCommand="TransactionsRepeater_ItemCommand">
                            <ItemTemplate>
                                <tr data-detail-payload="<%#: Eval("DetailPayload") %>">
                                    <td><%#: Eval("TransactionId") %></td>
                                    <td><%#: Eval("CustomerId") %></td>
                                    <td><%#: Eval("CreatedAt") %></td>
                                    <td><%#: Eval("DueAt") %></td>
                                    <td><span class="transaction-status <%#: Eval("StatusClass") %>"><%#: Eval("Status") %></span></td>
                                    <td class="text-center text-nowrap">
                                        <asp:LinkButton ID="ArchiveButton" runat="server" CommandName="Archive" CommandArgument='<%# Eval("TransactionId") %>' CssClass="btn btn-secondary btn-sm archive-transaction-button" Enabled='<%# Eval("Status").ToString() == "Done" %>'>Archive</asp:LinkButton>
                                        <button type="button" class="btn btn-outline-primary btn-sm transaction-view-button" data-bs-toggle="modal" data-bs-target="#transactionDetailsModal">View receipt</button>
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

    <div class="modal fade" id="archiveConfirmationModal" tabindex="-1" aria-labelledby="archiveConfirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="archiveConfirmationModalLabel">Archive transaction</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p class="mb-0">Are you sure you want to archive transaction <strong data-archive-transaction></strong>? It will be hidden from the transaction log.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" data-confirm-archive>Yes, archive</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="transactionDetailsModal" tabindex="-1" aria-labelledby="transactionDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 class="modal-title h5" id="transactionDetailsModalLabel">Rental Receipt</h2>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="transactionModalBody">
                    <section class="transaction-modal-page" aria-labelledby="transactionReceiptHeading">
                    <div id="transactionPrintContent">
                    <div class="transaction-receipt">
                        <div class="transaction-receipt-contact text-center mb-4">
                            <h3 class="h5 mb-1">TECH<span class="text-danger">RENT</span></h3>
                            <p class="small mb-0">Quezon City | (02) 8123-4567 | techrent@example.com</p>
                        </div>
                        <div class="transaction-receipt-header d-flex flex-column flex-sm-row justify-content-between gap-3 mb-4">
                            <div>
                            <h3 class="h4 mb-1" id="transactionReceiptHeading">Official Receipt</h3>
                                <p class="small text-muted mb-0">Transaction record and rental charges</p>
                            </div>
                            <dl class="small mb-0 text-sm-end">
                                <dt>Receipt number</dt>
                                <dd class="mb-0 fw-semibold" id="transactionDetailReceiptNumber"></dd>
                            </dl>
                        </div>

                        <section class="transaction-detail-section" aria-labelledby="customerInformationHeading">
                            <h3 class="h6 transaction-detail-heading" id="customerInformationHeading">Customer information</h3>
                            <dl class="transaction-detail-list">
                                <div class="transaction-detail-field"><dt>Customer name</dt><dd id="transactionDetailCustomerName"></dd></div>
                                <div class="transaction-detail-field"><dt>Customer ID</dt><dd id="transactionDetailCustomer"></dd></div>
                                <div class="transaction-detail-field"><dt>Email</dt><dd id="transactionDetailCustomerEmail"></dd></div>
                                <div class="transaction-detail-field"><dt>Mobile</dt><dd id="transactionDetailCustomerMobile"></dd></div>
                            </dl>
                        </section>

                        <section class="transaction-detail-section" aria-labelledby="rentalDatesHeading">
                            <h3 class="h6 transaction-detail-heading" id="rentalDatesHeading">Rental dates</h3>
                            <dl class="transaction-detail-list">
                                <div class="transaction-detail-field"><dt>Rental start date</dt><dd id="transactionDetailRentalStart"></dd></div>
                                <div class="transaction-detail-field"><dt>Return date</dt><dd id="transactionDetailExpiration"></dd></div>
                            </dl>
                        </section>

                        <section class="transaction-detail-section" aria-labelledby="equipmentHeading">
                            <h3 class="h6 transaction-detail-heading" id="equipmentHeading">Assigned rental units</h3>
                            <div class="table-responsive">
                                <table class="table table-sm align-middle mb-0 transaction-receipt-table">
                                    <caption class="visually-hidden">Equipment and charges for this transaction</caption>
                                    <thead>
                                        <tr><th scope="col">Equipment</th><th scope="col">Serial number</th><th scope="col" class="text-end">Rental fee</th><th scope="col" class="text-end">Deposit</th></tr>
                                    </thead>
                                    <tbody id="transactionEquipmentDetails"></tbody>
                                </table>
                            </div>
                        </section>

                        <section class="transaction-detail-section" aria-labelledby="preRentalHeading">
                            <h3 class="h6 transaction-detail-heading" id="preRentalHeading">Pre-rental details</h3>
                            <p class="small text-muted mb-2">Inspection entries shown from the transaction audit log.</p>
                            <div id="transactionPreRentalDetails"></div>
                        </section>

                        <div class="transaction-receipt-footer-row">
                            <section class="transaction-detail-section transaction-receipt-signature-section" aria-labelledby="transactionSignatureHeading">
                                <div class="transaction-receipt-signature-line" aria-hidden="true"></div>
                                <p class="small text-muted mb-0">Signature</p>
                            </section>

                            <section class="transaction-financial-summary" aria-labelledby="financialSummaryHeading">
                                <h3 class="h6 transaction-detail-heading" id="financialSummaryHeading">Charge summary</h3>
                                <dl class="row small mb-0 transaction-receipt-summary">
                                    <dt class="col-8">Rental fee</dt>
                                    <dd class="col-4 text-end" id="transactionDetailRentalFee"></dd>
                                    <dt class="col-8">Security deposit</dt>
                                    <dd class="col-4 text-end" id="transactionDetailSecurityDeposit"></dd>
                                    <dt class="col-8">Amount paid</dt>
                                    <dd class="col-4 text-end" id="transactionDetailPaidAmount"></dd>
                                    <dt class="col-8">Change</dt>
                                    <dd class="col-4 text-end" id="transactionDetailChange"></dd>
                                    <dt class="col-8 transaction-total-label">Total</dt>
                                    <dd class="col-4 text-end transaction-total" id="transactionDetailTotal"></dd>
                                </dl>
                            </section>
                        </div>
                    </div>
                </div>
                </div>
                </section>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary ms-auto" id="printTransactionButton">Save receipt as PDF</button>
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
            var statusSelect = document.getElementById('transactionStatus');
            var currentPage = 1;
            var pageSize = 8;
            var appliedQuery = '';
            var archiveModalElement = document.getElementById('archiveConfirmationModal');
            var archiveModal = new bootstrap.Modal(archiveModalElement);
            var selectedArchiveButton;
            var allowArchiveSubmit = false;

            document.querySelectorAll('.archive-transaction-button:not([disabled])').forEach(function (button) {
                button.addEventListener('click', function (event) {
                    if (allowArchiveSubmit) {
                        allowArchiveSubmit = false;
                        return;
                    }

                    event.preventDefault();
                    selectedArchiveButton = button;
                    var row = button.closest('tr');
                    archiveModalElement.querySelector('[data-archive-transaction]').textContent = row.cells[0].textContent.trim();
                    archiveModal.show();
                });
            });

            archiveModalElement.querySelector('[data-confirm-archive]').addEventListener('click', function () {
                if (!selectedArchiveButton) {
                    return;
                }

                allowArchiveSubmit = true;
                archiveModal.hide();
                selectedArchiveButton.click();
            });

            function setDetailText(id, value) {
                document.getElementById(id).textContent = value === null || value === undefined || value === '' ? '—' : value;
            }

            function populateTransactionModal(transaction) {
                var detail = transaction || {};
                setDetailText('transactionDetailReceiptNumber', detail.ReceiptNumber);
                setDetailText('transactionDetailCustomerName', detail.CustomerName);
                setDetailText('transactionDetailCustomer', detail.CustomerId);
                setDetailText('transactionDetailCustomerEmail', detail.CustomerEmail);
                setDetailText('transactionDetailCustomerMobile', detail.CustomerMobile);
                setDetailText('transactionDetailRentalStart', detail.RentalStartDate);
                setDetailText('transactionDetailExpiration', detail.ReturnDate);
                setDetailText('transactionDetailRentalFee', detail.RentalFee);
                setDetailText('transactionDetailSecurityDeposit', detail.SecurityDeposit);
                setDetailText('transactionDetailPaidAmount', detail.PaidAmount);
                setDetailText('transactionDetailChange', detail.Change);
                setDetailText('transactionDetailTotal', detail.Total);

                var equipmentDetails = document.getElementById('transactionEquipmentDetails');
                equipmentDetails.innerHTML = '';
                (detail.Equipment || []).forEach(function (equipment) {
                    var row = document.createElement('tr');
                    var equipmentCell = document.createElement('th');
                    equipmentCell.scope = 'row';
                    equipmentCell.textContent = equipment.Name || '—';
                    row.appendChild(equipmentCell);

                    var serialCell = document.createElement('td');
                    serialCell.textContent = equipment.SerialNumber || '—';
                    row.appendChild(serialCell);

                    var rentalFeeCell = document.createElement('td');
                    rentalFeeCell.className = 'text-end';
                    rentalFeeCell.textContent = equipment.Rate || '—';
                    row.appendChild(rentalFeeCell);

                    var depositCell = document.createElement('td');
                    depositCell.className = 'text-end';
                    depositCell.textContent = equipment.Deposit || '—';
                    row.appendChild(depositCell);

                    equipmentDetails.appendChild(row);
                });

                var preRentalDetails = document.getElementById('transactionPreRentalDetails');
                preRentalDetails.innerHTML = '';
                var auditors = [];
                (detail.PreRentalDetails || []).forEach(function (preRentalDetail) {
                    if (preRentalDetail.RecordedBy && auditors.indexOf(preRentalDetail.RecordedBy) === -1) {
                        auditors.push(preRentalDetail.RecordedBy);
                    }
                });
                var preRentalAuditor = document.createElement('p');
                preRentalAuditor.className = 'small text-muted mb-2 transaction-pre-rental-auditor';
                preRentalAuditor.textContent = auditors.length ? 'Recorded by ' + auditors.join(', ') : 'Recorded by --';
                preRentalDetails.appendChild(preRentalAuditor);

                var preRentalParagraph = document.createElement('p');
                preRentalParagraph.className = 'small mb-0';
                preRentalParagraph.textContent = (detail.PreRentalDetails || []).length
                    ? detail.PreRentalDetails.map(function (preRentalDetail) {
                        return preRentalDetail.EquipmentSerialNumber + ': ' + preRentalDetail.Issue;
                    }).join(' ')
                    : 'No pre-rental details recorded.';
                preRentalDetails.appendChild(preRentalParagraph);
            }

            function printTransactionDetails() {
                var printWindow = window.open('', '_blank', 'width=900,height=700');
                if (!printWindow) {
                    return;
                }

                var bootstrapStylesheet = '<%: ResolveUrl("~/Content/bootstrap.min.css") %>';
                var transactionStylesheet = '<%: ResolveUrl("~/css/admin/Transactions.css") %>';
                printWindow.document.write('<!doctype html><html lang="en"><head><meta charset="utf-8"><title>Rental receipt</title><link rel="stylesheet" href="' + bootstrapStylesheet + '"><link rel="stylesheet" href="' + transactionStylesheet + '"></head><body class="transaction-print-page"><main class="container py-4">' + document.getElementById('transactionPrintContent').innerHTML + '</main></body></html>');
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
                    var matchesSearch = row.textContent.toLowerCase().indexOf(appliedQuery) !== -1;
                    var status = row.querySelector('.transaction-status');
                    var matchesStatus = statusSelect.value === 'all' ||
                        (status && status.textContent.trim() === statusSelect.value);
                    return matchesSearch && matchesStatus;
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

            statusSelect.addEventListener('change', function () {
                currentPage = 1;
                renderTable();
            });

            renderTable();
        });
    </script>
</asp:Content>
