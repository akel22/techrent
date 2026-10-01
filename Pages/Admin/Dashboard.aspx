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

        <select class="form-select admin-period-select" aria-label="Reporting period">
            <option>Last 30 days</option>
            <option>Last 60 days</option>
            <option>Yearly</option>
        </select>
       </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-6 col-xl-3">
            <section class="card h-100 admin-card">
                <div class="card-body">
                    <p class="text-muted small mb-2">Revenue</p>
                    <p class="h3 mb-5">&#8369;153,224.43</p>
                    <p class="text-success small mb-0">+&#8369;12,345.67 since last month</p>
                </div>
            </section>
        </div>

        <div class="col-md-6 col-xl-3">
            <div class="d-flex flex-column gap-4">
                <section class="card  admin-card">
                    <div class="card-body">
                        <p class="text-muted small mb-2">Active rentals</p>
                        <p class="h3 mb-0">40</p>
                    </div>
                </section>
                <section class="card  admin-card">
                    <div class="card-body">
                        <p class="text-muted small mb-2">Equipments in maintenance</p>
                        <p class="h3 mb-0">5</p>
                    </div>
                </section>
            </div>
        </div>

        <div class="col-xl-6">
            <section class="card h-100 admin-card">
                <div class="card-body">
                    <h2 class="h6 mb-3">Equipment availability</h2>
                    <div class="admin-doughnut-chart">
                        <canvas id="availabilityChart" aria-label="Equipment availability chart" role="img"></canvas>
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
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h2 class="h6 mb-0">Upcoming transactions</h2>
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="<%$ RouteUrl:RouteName=Transactions %>" CssClass="btn btn-outline-secondary btn-sm">View all</asp:HyperLink>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-sm align-middle mb-0">
                            <thead>
                                <tr>
                                    <th scope="col">Transaction</th>
                                    <th scope="col">Due date</th>
                                    <th scope="col" class="text-end">Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>TR-1024</td>
                                    <td>Oct 22, 2026</td>
                                    <td class="text-end">&#8369;4,500.00</td>
                                </tr>
                                <tr>
                                    <td>TR-1023</td>
                                    <td>Oct 21, 2026</td>
                                    <td class="text-end">&#8369;2,800.00</td>
                                </tr>
                                <tr>
                                    <td>TR-1022</td>
                                    <td>Oct 20, 2026</td>
                                    <td class="text-end">&#8369;3,200.00</td>
                                </tr>
                                <tr>
                                    <td>TR-1021</td>
                                    <td>Oct 19, 2026</td>
                                    <td class="text-end">&#8369;5,000.00</td>
                                </tr>
                            </tbody>
                        </table>
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
                    labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
                    datasets: [{
                        data: [28500, 35400, 31200, 58100],
                        borderColor: '#0d6efd',
                        backgroundColor: 'rgba(13, 110, 253, 0.08)',
                        borderWidth: 2,
                        fill: true,
                        tension: 0.25,
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

            new Chart(document.getElementById('availabilityChart'), {
                type: 'doughnut',
                data: {
                    labels: ['Available', 'Rented'],
                    datasets: [{ data: [83, 17], backgroundColor: ['#0d6efd', '#e9ecef'], borderWidth: 0 }]
                },
                options: { responsive: true, maintainAspectRatio: false, cutout: '68%', plugins: { legend: { position: 'bottom' } } }
            });

        });
    </script>
</asp:Content>
