<%@ Page Title="Payments" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Payments.aspx.cs" Inherits="Techrent.Pages.Admin.Payments" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/Payments.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-2 mb-4">
        <div>
            <h1 class="h3 mb-1">Payments activity</h1>
            <p class="text-muted mb-0">Review recorded rental payments</p>
        </div>
        <p class="text-muted small mb-0"><%: DateTime.Now.ToString("dddd, dd MMMM yyyy hh:mm tt") %></p>
    </div>

    <section class="card admin-card">
        <div class="card-body">
            <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-3">
                <div class="d-flex align-items-center gap-2 payment-sort-controls">
                    <label for="paymentSort" class="form-label mb-0 text-nowrap">Sort by</label>
                    <asp:DropDownList ID="PaymentSort" runat="server" CssClass="form-select form-select-sm payment-sort-select" AutoPostBack="true" OnSelectedIndexChanged="OnFilterChanged">
                        <asp:ListItem Value="DESC" Selected="True">Latest date</asp:ListItem>
                        <asp:ListItem Value="ASC">Earliest date</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="input-group payment-search">
                    <span class="input-group-text bg-white" aria-hidden="true">
                        <img src="<%: ResolveUrl("~/assets/svg/search.svg") %>" alt="" />
                    </span>
                    <asp:TextBox ID="PaymentSearch" runat="server" CssClass="form-control" Placeholder="Search payment or transaction" />
                    <button type="submit" class="btn btn-outline-secondary btn-sm" formaction="" formmethod="post" runat="server" id="SearchButton" onserverclick="OnSearchClicked">Search</button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-sm align-middle mb-0 payment-table">
                    <thead>
                        <tr>
                            <th scope="col">Payment ID</th>
                            <th scope="col">Transaction ID</th>
                            <th scope="col">Payment type</th>
                            <th scope="col" class="text-end">Amount</th>
                            <th scope="col">Payment method</th>
                            <th scope="col">Created date</th>
                        </tr>
                    </thead>
                    <tbody id="paymentRows">
                        <asp:Repeater ID="PaymentActivityRepeater" runat="server">
                            <ItemTemplate>
                                <tr data-created-at="<%#: Eval("CreatedAtSort") %>" data-search="<%#: Eval("SearchText") %>">
                                    <td><%#: Eval("PaymentId") %></td>
                                    <td><%#: Eval("TransactionId") %></td>
                                    <td><%#: Eval("PaymentType") %></td>
                                    <td class="text-end"><%#: Eval("Amount") %></td>
                                    <td><%#: Eval("PaymentMethod") %></td>
                                    <td><%#: Eval("CreatedAt") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <asp:Panel ID="EmptyPanel" runat="server" CssClass="text-muted text-center py-4 mb-0" Visible="false">No payment records match this search.</asp:Panel>
            <div class="d-flex justify-content-center mt-3 payment-pagination">
                <div class="d-flex gap-2 align-items-center">
                    <asp:LinkButton ID="PrevPage" runat="server" CssClass="btn btn-sm btn-outline-primary" OnClick="PrevPage_Click">Previous</asp:LinkButton>
                    <asp:Label ID="PageInfo" runat="server" CssClass="text-muted small mb-0"></asp:Label>
                    <asp:LinkButton ID="NextPage" runat="server" CssClass="btn btn-sm btn-outline-primary" OnClick="NextPage_Click">Next</asp:LinkButton>
                </div>
            </div>
        </div>
    </section>
</asp:Content>

<asp:Content ID="PageScripts" ContentPlaceHolderID="PageScripts" runat="server">
</asp:Content>
