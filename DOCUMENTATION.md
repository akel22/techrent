# Techrent Documentation

## Purpose

Techrent is an internal web application for an IT equipment rental shop. It is intended for rental staff and administrators who will use separate interfaces while sharing a common application shell.

The application is currently being established as an ASP.NET Web Forms application targeting .NET Framework 4.8.1.

## Current scope

The current implementation includes an administrator dashboard, transaction and audit log pages, and a customer management page:

- `Pages/Admin/Admin.Master` provides the administrator sidebar and content shell.
- Bootstrap is the only stylesheet framework.
- Administrator page styles are kept in `css/admin/`.
- The transaction log uses static sample records, search applied when Enter is pressed, a created-date sort selector for earliest or latest dates, and pagination limited to eight rows per page. View opens a scrollable unified printable receipt containing transaction and customer identifiers, receipt number, creation and due dates, status, representative equipment, a single combined area for audit-log-derived pre-rental details with the auditor shown above the descriptions, rental fee, security deposit, and total. The modal-scoped print action prints the complete receipt as one document. Search, sorting, modal details, financial values, and printing are presentation-only and are not connected to a database.
- `Pages/Admin/AuditLogs.aspx` presents static sample audit events with date-range and category filters, keyword search, and pagination limited to eight rows per page. Apply Filters uses the selected category while retaining the selected date range and search; All Categories removes only the category constraint. The Show Details action opens a Bootstrap scrollable modal. These audit records and interactions are presentation-only and are not connected to a database.
- `Pages/Admin/Customers.aspx` presents static sample customer records with Enter-triggered search across customer ID, name, mobile number, and email, plus pagination limited to eight rows per page. Show Details opens a Bootstrap modal with editable customer fields except Customer ID, an active-transaction conflict warning, and a Save Changes action that updates the selected row in the browser only. Its View transaction history button sequences to a customer-filtered Bootstrap modal with five transaction rows per page. The transaction-history Go back action restores the customer details modal, while either modal's close control returns to the customer list without leaving a backdrop. Remove opens a confirmation modal; customer details, transaction history, saving, and removal actions are presentation-only and are not connected to a database.
- The Rental Staff interface includes a presentation-only transaction flow under `Pages/RentalStaff/`. `Pages/RentalStaff/RentalStaff.Master` provides the Rental Staff shell, `Default.aspx` provides the home workspace, `New.aspx` provides static customer selection with a profile-details modal, `RegisterCustomer.aspx` provides the customer registration form, `Equipment.aspx` provides required rental start and return date selection, static equipment selection, date-range validation, and a client-side summary, and `SerialAssignment.aspx` provides static serial-number assignment with required dropdowns that use native browser validation before the client-side finalization route opens.
- `Pages/RentalStaff/Review.aspx` keeps the rental-details confirmation button enabled and provides a receipt modal whose browser print action is presented as saving the receipt as a PDF file.
- The receipt displays Techrent's sample Quezon City contact block above the receipt header and provides a manual rental staff signature line near the receipt footer.
- The active-transactions Mark as done action uses a fixed-size, flex-aligned check SVG icon within the button.
- Back-related navigation and cancel actions across the Rental Staff and Admin interfaces use the shared `assets/svg/back.svg` icon.
- The rental receipt uses separated customer-information fields, readable table spacing, and print-specific page-break rules to keep receipt content from overlapping or splitting awkwardly.
- The receipt footer places the manual rental staff signature area beside the charge summary and uses compact print spacing to keep the receipt on one page when possible.
- `Pages/Admin/Transactions.aspx` uses the same receipt contact block, field layout, equipment table, signature area, charge-summary footer, and compact print styling as `Pages/RentalStaff/Review.aspx`; transaction-specific values remain dynamically populated from the admin transaction payload.
- The Rental Staff home workspace centers its welcome card horizontally and vertically and provides actions to create a new transaction or view active transactions. `Pages/RentalStaff/ActiveTransactions.aspx` displays static active rental rows in a responsive table with the Status heading aligned to its status records; Mark as done changes the selected row to Done in the browser only and is not persisted.
- The Rental Staff home action buttons use a fixed-size, flex-aligned view SVG icon so the icon remains fitted within the active-transactions link.
- The serial-number assignment page uses compact serial-number dropdowns sized for the available serial values, a narrower centered assignment card, two-column assignment rows that stack on smaller screens, and step 2 navigation actions in the page header and form footer.
- Rental Staff routes include `/` (`RentalStaff`), `/rentalStaff/active-transactions` (`RentalStaffActiveTransactions`), `/rentalStaff/new` (`RentalStaffNew`), `/rentalStaff/register-customer` (`RentalStaffRegisterCustomer`), `/rentalStaff/equipment` (`RentalStaffEquipment`), and `/rentalStaff/serial-assignment` (`RentalStaffSerialAssignment`). The equipment Continue action opens the serial-assignment step when at least one unit is selected. The master-page Sign out control remains non-functional because authentication is not implemented.
- The initial Rental Staff flow uses static sample data. Customer search, customer profile details, equipment search, category filtering, quantity aggregation, removal, stock limits, and estimated totals are presentation-only browser interactions. Decreasing an item below one unit removes it from the transaction summary.
- Equipment summary plus, minus, and Remove controls use delegated client-side click handling so they continue working after the summary is re-rendered; quantities remain within stock limits and estimated totals update immediately.
- Equipment Add buttons use the fixed-size `assets/svg/add.svg` icon alongside their labels.
- All application search bars use the shared embedded search-icon treatment and apply text searches only after the Enter key is pressed. Non-text filters, such as category and sort selectors, continue to apply when changed.
- No authentication or role authorization is implemented yet.
- No database queries, transactions, calculations, or business workflows are implemented yet.

The `Application Layer` and `Data Access Layer` directories are reserved for future development.

## UI conventions

- Keep the interface practical and easy to scan.
- Prefer Bootstrap components and utility classes over custom CSS.
- Do not add decorative animations, gradients, or unrelated UI frameworks.
- Reuse `Pages/Admin/Admin.Master` for administrator pages and the appropriate shared master page for other application pages.
- Keep navigation limited to implemented destinations. Do not add links to pages that do not exist.
- Use semantic HTML and accessible labels where applicable.
- Keep page-specific presentation close to the page unless it is a genuinely shared concern.

## Planned user interfaces

### Rental staff

The Rental Staff interface currently supports the first presentation-only transaction flow:

1. `/` displays the centered Rental Staff welcome workspace with links to create a transaction or view active transactions.
2. `/rentalStaff/active-transactions` displays static active transactions and allows each row to be marked Done in the browser only.
3. `/rentalStaff/new` requires the staff member to select a static sample customer, includes client-side customer search applied on Enter, and links to the registration form.
4. `/rentalStaff/register-customer` presents first name, last name, occupation, email, mobile number with a `+63` prefix, and organization address fields. Mobile input accepts digits only and blocks spaces. The form accepts JPG, PNG, and HEIC identification photos and displays supported images in a constrained portrait card with a `No attached photo` placeholder before selection. HEIC preview depends on browser support.
5. `/rentalStaff/equipment` displays static equipment cards with each equipment type (`Obsolete`, `Standard`, or `Professional`), Enter-triggered search, category filters, and a transaction summary. Each selected equipment line shows its total price plus the static rental fee and security deposit per unit. Selecting a card adds one unit, repeated selections aggregate by equipment model, quantities cannot exceed the displayed stock, and estimated totals update in the browser.
6. `/rentalStaff/serial-assignment` assigns static serial numbers to the sample units and opens the final review when all units are assigned.
7. `/rentalStaff/review` displays static customer, equipment, serial-number, and estimated-charge details. Rental staff can enter optional pre-rental audit-log notes with a 500-character limit and confirm the draft in the browser. Confirmation opens a printable receipt modal with Print and Close actions; the staff member must confirm that printing succeeded before Close is enabled, while selecting No leaves the receipt available for another print attempt. Neither the notes, receipt, print confirmation, nor draft confirmation is persisted.

The flow does not persist registrations or drafts, query a database, calculate business-specific charges, or implement authentication. Serial assignment, returns, customer management, equipment availability management, payment, review, and transaction completion remain future workflows.

Note: The Rental Staff master page uses a full-width, dark, borderless page header for the TECHRENT brand, matching the Admin interface's visual style rather than using a viewport-centered floating shell. Rental-staff content remains centered within a max-width content area.

### Administrators

  The administrator interface currently includes a dashboard, `Pages/Admin/Equipments.aspx`, a transaction log page, and an audit log page. `Pages/Admin/Equipments.aspx` presents equipment IDs, categories, models, types, statuses, quantities, and row details using static sample data. Search is applied only when the Search button is clicked or Enter is pressed; sorting supports all equipment, category, status, and type, pagination displays at most eight rows per page, Show Details opens a scrollable Bootstrap modal with presentation-only editable fields, and Remove opens a confirmation modal without deleting data. Equipment type is limited to Obsolete, Standard, or Professional, while rental and deposit rates are exposed as numeric values with currency and hourly-unit labels rendered separately. The transaction log presents transaction IDs, customer IDs, creation and due dates, status, and row actions using static sample data. Search is applied when Enter is pressed; created-date sorting offers earliest and latest order; pagination displays at most eight rows per page; and View displays a unified printable receipt with transaction and customer identifiers, receipt number, creation and due dates, status, representative equipment, audit-log-derived pre-rental details, rental fee, security deposit, and total in a scrollable Bootstrap modal. The modal-scoped print action prints the complete receipt as one document. The audit log page presents log IDs, actors, roles, timestamps, and category-filtered sample events. Date-range and category filters are applied with the Apply Filters button, keyword search can be applied with Enter, pagination displays at most eight rows per page, and Show Details displays the selected event in a scrollable Bootstrap modal. No inventory, audit-log database integration, persistence workflow, or authorization is implemented.

Additional management functions, permissions, and workflows will be defined before implementation.

## Intended architecture

The project separates responsibilities into the following areas:

### Presentation layer

ASP.NET Web Forms pages, master pages, code-behind, Bootstrap markup, and presentation-specific validation belong here. Presentation code should coordinate requests and display results, not contain SQL or database transaction rules.

### Application Layer

The Application Layer will contain application use cases and business orchestration. It should coordinate validation and calls to data-access abstractions without depending on Web Forms controls.

### Data Access Layer

The Data Access Layer will contain database communication, data-transfer objects, stored-procedure calls, parameter mapping, and result materialization. It should not contain page rendering logic.

The existing folders are placeholders for this separation and should not be bypassed by placing database code directly in `.aspx.cs` files.

## Database strategy

When database development begins:

- Use ADO.NET and stored procedures for database access.
- Do not introduce Entity Framework Core or EF Core LINQ queries.
- Prefer stored procedures for querying and command execution.
- Let SQL Server perform appropriate aggregate calculations and transaction-oriented work.
- Keep transaction boundaries and consistency rules explicit.
- Pass parameters rather than concatenating SQL strings.
- Map database results into DTOs or application models before returning them to the presentation layer.
- Keep connection strings and other environment-specific values in configuration rather than source code.

The database schema, stored-procedure names, transaction rules, and error-handling policy must be documented before the Data Access Layer is implemented.

## Project structure

```text
Techrent/
├── Application Layer/       Application use cases and business orchestration
├── App_Data/                Local application data location, if required
├── App_Start/               Routing and bundling configuration
├── assets/                  Static application assets
├── Content/                 Bootstrap and shared CSS
├── Data Access Layer/       DTOs and future stored-procedure data access
├── Pages/                   Application pages, including Pages/Admin
├── css/admin/               Administrator page-specific styles
├── Scripts/                 JavaScript and Web Forms scripts
├── Site.Master              Shared application layout
├── Bundle.config            Bootstrap stylesheet bundle configuration
└── Web.config               ASP.NET and runtime configuration
```

## Local development

1. Open `Techrent.slnx` in Visual Studio.
2. Restore the NuGet packages if Visual Studio reports missing packages.
3. Use IIS Express to run the ASP.NET Web Forms project.
4. Confirm that the shared master page and Bootstrap assets load correctly.
5. Build the solution before committing changes.

The project targets .NET Framework 4.8.1 and should remain compatible with classic ASP.NET Web Forms conventions.

## Future development phases

1. Define the database schema and stored-procedure contract.
2. Establish DTOs and Data Access Layer abstractions.
3. Implement Application Layer use cases and validation.
4. Add authentication and role-based authorization.
5. Continue building the Rental Staff and Administrator interfaces using their appropriate master pages.
6. Add tests for application use cases and data-access mappings.
7. Add deployment configuration and operational documentation.
