<%@ Page Title="Damage Charge Guidelines" Language="C#" MasterPageFile="~/Pages/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Guidelines.aspx.cs" Inherits="Techrent.Pages.Admin.DamageChargeGuidelines" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="<%: ResolveUrl("~/css/admin/DamageChargeGuidelines.css") %>" rel="stylesheet" />
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-2 mb-4">
        <div>
            <h1 class="h3 mb-1">Damage charge guidelines</h1>
            <p class="text-muted mb-0">Use the return notes to document equipment condition and apply the appropriate charge guidance.</p>
        </div>
    </div>

    <div class="alert alert-info border-0 shadow-sm mb-4" role="note">
        <strong>How charges are calculated:</strong> a good or undamaged return has no damage charge. For damaged equipment, apply the percentage below to the security deposit for each affected unit. Missing or beyond-repair equipment uses the <strong>Beyond repair / lost</strong> rate. These guidelines add a damage charge; they do not replace the rental fee or security deposit.
    </div>

    <section class="card admin-card mb-4" aria-labelledby="chargeMatrixHeading">
        <div class="card-body p-3 p-md-4">
            <div class="mb-3">
                <h2 id="chargeMatrixHeading" class="h5 mb-1">Charge matrix</h2>
                <p class="text-muted small mb-0">Percentages are based on the affected unit's security deposit.</p>
            </div>
            <div class="table-responsive">
                <table class="table align-middle mb-0 damage-charge-table">
                    <caption class="visually-hidden">Damage charge percentages by equipment type and condition</caption>
                    <thead>
                        <tr>
                            <th scope="col">Equipment type</th>
                            <th scope="col">Cosmetic damage</th>
                            <th scope="col">Functional damage</th>
                            <th scope="col">Beyond repair / lost</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="DamageChargeRulesRepeater" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <th scope="row"><%#: Eval("EquipmentType") %></th>
                                    <td><%#: Eval("CosmeticDamagePercentage") %></td>
                                    <td><%#: Eval("FunctionalDamagePercentage") %></td>
                                    <td><%#: Eval("BeyondRepairPercentage") %></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <section class="card admin-card" aria-labelledby="conditionHeading">
        <div class="card-body p-3 p-md-4">
            <h2 id="conditionHeading" class="h5 mb-2">Return outcome guidance</h2>
            <p class="text-muted small mb-3">When marking a transaction done, record the relevant outcome in the optional notes field. Use the charge categories below when a damage charge is applicable.</p>
            <div class="row g-3 mb-4">
                <div class="col-12 col-md-4">
                    <article class="damage-condition-card h-100">
                        <h3 class="h6 mb-2">Good / undamaged</h3>
                        <p class="small text-muted mb-0">The equipment is returned in working order with no chargeable damage.</p>
                    </article>
                </div>
                <div class="col-12 col-md-4">
                    <article class="damage-condition-card h-100">
                        <h3 class="h6 mb-2">Damaged</h3>
                        <p class="small text-muted mb-0">Describe the issue in the notes and use the cosmetic or functional damage rate that best matches it.</p>
                    </article>
                </div>
                <div class="col-12 col-md-4">
                    <article class="damage-condition-card h-100">
                        <h3 class="h6 mb-2">Missing / beyond repair</h3>
                        <p class="small text-muted mb-0">Record the missing item or unusable condition in the notes and use the Beyond repair / lost rate.</p>
                    </article>
                </div>
            </div>
            <h3 class="h6 mb-3">Damage charge definitions</h3>
            <div class="row g-3">
                <asp:Repeater ID="ConditionRulesRepeater" runat="server">
                    <ItemTemplate>
                        <div class="col-12 col-md-4">
                            <article class="damage-condition-card h-100">
                                <h3 class="h6 mb-2"><%#: Eval("DamageCondition") %></h3>
                                <p class="small text-muted mb-0"><%#: Eval("ConditionDescription") %></p>
                            </article>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </section>
</asp:Content>
