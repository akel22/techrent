<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Techrent.Pages.Admin.AdminDashboard" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/AdminDashboard.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex align-items-center justify-content-between mb-4">
        <div>
            <h1 class="h3 mb-1">Monthly revenue</h1>
            <p class="text-muted mb-0">Our IT equipment rental activity overview</p>
        </div>
        <div class="d-flex flex-column align-items-end">
        <p class="text-muted small mb-3"><%: DateTime.Now.ToString("dddd, dd MMMM yyyy hh:mm tt") %></p>

        <select id="dashboardPeriod" class="form-select admin-period-select" aria-label="Reporting period" onchange="window.location.search = '?period=' + this.value;">
            <option value="30" <%: SelectedPeriod == "30" ? "selected=\"selected\"" : "" %>>Last 30 days</option>
            <option value="60" <%: SelectedPeriod == "60" ? "selected=\"selected\"" : "" %>>Last 60 days</option>
            <option value="year" <%: SelectedPeriod == "year" ? "selected=\"selected\"" : "" %>>Yearly</option>
        </select>
       </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-6 col-xl-3">
            <section class="card h-100 admin-card">
                <div class="card-body">
                    <p class="text-muted small mb-2">Revenue</p>
                    <p class="h3 mb-5"><%: RevenueText %></p>
                    <p class="text-muted small mb-0">Recorded payments</p>
                </div>
            </section>
        </div>

        <div class="col-md-6 col-xl-3">
            <div class="d-flex flex-column gap-4">
                <section class="card  admin-card">
                    <div class="card-body">
                        <p class="text-muted small mb-2">Active rentals</p>
                        <p class="h3 mb-0"><%: ActiveRentalsText %></p>
                    </div>
                </section>
            </div>
        </div>

        <div class="col-xl-6">
            <section class="card h-100 admin-card">
                <div class="card-body">
                    <h2 class="h6 mb-3">Rental Activity</h2>
                    <div class="admin-doughnut-chart">
                        <canvas id="availabilityChart" aria-label="Equipment availability chart" role="img"></canvas>
                        <p id="rentalActivityEmptyState" class="text-muted text-center d-flex align-items-center justify-content-center h-100 mb-0 d-none">No rental activity for the selected data.</p>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-xl-7">
            <section class="card admin-card h-100">
                <div class="card-body">
                    <h2 class="h6 mb-3">Statistics</h2>
                    <div class="admin-line-chart">
                        <canvas id="revenueChart" aria-label="Revenue trend chart" role="img"></canvas>
                    </div>
                </div>
            </section>
        </div>
        <div class="col-xl-5">
            <section class="card admin-card h-100">
                <div class="card-body">
                    <h2 class="h6 mb-3">Equipment status</h2>
                    <div class="admin-equipment-status-chart">
                        <canvas id="equipmentStatusChart" aria-label="Equipment status chart showing available and maintenance totals" role="img"></canvas>
                    </div>
                </div>
            </section>
        </div>
    </div>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
    <script src="<%: ResolveUrl("~/Scripts/vendor/chart.umd.min.js") %>"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            new Chart(document.getElementById('revenueChart'), {
                type: 'line',
                data: {
                    labels: <%= RevenueChartLabels %>,
                    datasets: [{
                        data: <%= RevenueChartData %>,
                        borderColor: '#2C3E50',
                        backgroundColor: 'rgba(13, 110, 253, 0.08)',
                        borderWidth: 2,
                        fill: false,
                        tension: 0,
                        pointRadius: 3
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: { y: { beginAtZero: true, ticks: { callback: function (value) { return '\u20B1' + value.toLocaleString(); } } } }
                }
            });

            var activityCanvas = document.getElementById('availabilityChart');
            var activityData = <%= TransactionChartData %>;
            if (activityData.some(function (value) { return value > 0; })) {
                new Chart(activityCanvas, {
                    type: 'pie',
                    data: {
                        labels: ['Active Rentals', 'Successful Transactions', 'Late Transactions', 'Overdue Transactions'],
                        datasets: [{ data: activityData, backgroundColor: ['#0d6efd', '#28a745', '#ffc107', '#dc3545'], borderWidth: 0 }]
                    },
                    options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
                });
            } else {
                activityCanvas.classList.add('d-none');
                document.getElementById('rentalActivityEmptyState').classList.remove('d-none');
            }

            new Chart(document.getElementById('equipmentStatusChart'), {
                type: 'bar',
                data: {
                    labels: ['Available', 'Maintenance'],
                    datasets: [{
                        label: 'Equipment units',
                        data: <%= EquipmentChartData %>,
                        backgroundColor: ['#28a745', '#ffc107'],
                        borderWidth: 0,
                        barThickness: 28
                    }]
                },
                options: {
                    indexAxis: 'y',
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                        tooltip: { callbacks: { label: function (context) { return context.raw + ' equipment units'; } } }
                    },
                    scales: {
                        x: { beginAtZero: true, ticks: { precision: 0 }, title: { display: true, text: 'Total equipment' } },
                        y: { grid: { display: false } }
                    }
                }
            });

        });
    </script>
</asp:Content>
