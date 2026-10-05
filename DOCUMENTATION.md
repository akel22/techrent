# Techrent Documentation

## Purpose

Techrent is an internal web application for an IT equipment rental shop. It is intended for rental staff and administrators who will use separate interfaces while sharing a common application shell.

The application is currently being established as an ASP.NET Web Forms application targeting .NET Framework 4.8.1.

## Current scope

The current implementation includes an administrator dashboard, transaction and audit log pages, and a customer management page:

- `Pages/Admin/Admin.Master` provides the administrator sidebar and content shell.
- Bootstrap is the only stylesheet framework.
- Administrator page styles are kept in `css/admin/`.
- The transaction log uses static sample records, search applied when Enter is pressed, a created-date sort selector for earliest or latest dates, and pagination limited to eight rows per page. View opens a scrollable details modal with representative equipment, audit-log-derived pre-rental details, a receipt placeholder, and modal-scoped printing. Search, sorting, modal details, and printing are presentation-only and are not connected to a database.
- `Pages/Admin/AuditLogs.aspx` presents static sample audit events with date-range and category filters, keyword search, and pagination limited to eight rows per page. Apply Filters uses the selected category while retaining the selected date range and search; All Categories removes only the category constraint. The Show Details action opens a Bootstrap scrollable modal. These audit records and interactions are presentation-only and are not connected to a database.
- `Pages/Admin/Customers.aspx` presents static sample customer records with Enter-triggered search across customer ID, name, mobile number, and email, plus pagination limited to eight rows per page. Show Details opens a Bootstrap modal, and Remove opens a confirmation modal; both actions are presentation-only and are not connected to a database.
- The Rental Staff interface includes a presentation-only transaction flow under `Pages/RentalStaff/`. `Pages/RentalStaff/RentalStaff.Master` provides the Rental Staff shell, `Default.aspx` provides the home workspace, `New.aspx` provides static customer selection, `RegisterCustomer.aspx` provides the customer registration form, `Equipment.aspx` provides static equipment selection and a client-side summary, and `SerialAssignment.aspx` provides static serial-number assignment with required dropdowns that use native browser validation for missing selections when finalizing.
- The serial-number assignment page uses compact serial-number dropdowns sized for the available serial values, a narrower centered assignment card, and two-column assignment rows that stack on smaller screens.
- Rental Staff routes include `/` (`RentalStaff`), `/rentalStaff/new` (`RentalStaffNew`), `/rentalStaff/register-customer` (`RentalStaffRegisterCustomer`), `/rentalStaff/equipment` (`RentalStaffEquipment`), and `/rentalStaff/serial-assignment` (`RentalStaffSerialAssignment`). The equipment Continue action opens the serial-assignment step when at least one unit is selected. The master-page Sign out control remains non-functional because authentication is not implemented.
- The initial Rental Staff flow uses static sample data. Customer search, equipment search, category filtering, quantity aggregation, removal, stock limits, and estimated totals are presentation-only browser interactions. Decreasing an item below one unit removes it from the transaction summary.
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

1. `/` displays an empty transaction workspace for Rental Staff.
2. `/rentalStaff/new` requires the staff member to select a static sample customer, includes client-side customer search applied on Enter, and links to the registration form.
3. `/rentalStaff/register-customer` presents first name, last name, occupation, email, mobile number with a `+63` prefix, and organization address fields. Mobile input accepts digits only and blocks spaces. The form accepts JPG, PNG, and HEIC identification photos and displays supported images in a constrained portrait card with a `No attached photo` placeholder before selection. HEIC preview depends on browser support.
4. `/rentalStaff/equipment` displays static equipment cards with each equipment type (`Obsolete`, `Standard`, or `Professional`), Enter-triggered search, category filters, and a transaction summary. Each selected equipment line shows its total price plus the static rental fee and security deposit per unit. Selecting a card adds one unit, repeated selections aggregate by equipment model, quantities cannot exceed the displayed stock, and estimated totals update in the browser.
5. `/rentalStaff/serial-assignment` assigns static serial numbers to the sample units and opens the final review when all units are assigned.
6. `/rentalStaff/review` displays static customer, equipment, serial-number, and estimated-charge details. Rental staff can enter optional pre-rental audit-log notes with a 500-character limit and confirm the draft in the browser; neither the notes nor the confirmation is persisted.

The flow does not persist registrations or drafts, query a database, calculate business-specific charges, or implement authentication. Serial assignment, returns, customer management, equipment availability management, payment, review, and transaction completion remain future workflows.

Note: The Rental Staff master page uses a full-width, dark, borderless page header for the TECHRENT brand, matching the Admin interface's visual style rather than using a viewport-centered floating shell. Rental-staff content remains centered within a max-width content area.

### Administrators

The administrator interface currently includes a dashboard, `Pages/Admin/Equipments.aspx`, a transaction log page, and an audit log page. `Pages/Admin/Equipments.aspx` presents equipment IDs, categories, models, types, statuses, quantities, and row details using static sample data. Search is applied only when the Search button is clicked or Enter is pressed; sorting supports all equipment, category, status, and type, pagination displays at most eight rows per page, Show Details opens a scrollable Bootstrap modal with presentation-only editable fields, and Remove opens a confirmation modal without deleting data. Equipment type is limited to Obsolete, Standard, or Professional, while rental and deposit rates are exposed as numeric values with currency and hourly-unit labels rendered separately. The transaction log presents transaction IDs, customer IDs, creation and expiration dates, status, and row actions using static sample data. Search is applied when Enter is pressed; created-date sorting offers earliest and latest order; pagination displays at most eight rows per page; and View displays transaction summary, equipment, audit-log-derived pre-rental details, a receipt placeholder, and a print action in a scrollable Bootstrap modal. The audit log page presents log IDs, actors, roles, timestamps, and category-filtered sample events. Date-range and category filters are applied with the Apply Filters button, keyword search can be applied with Enter, pagination displays at most eight rows per page, and Show Details displays the selected event in a scrollable Bootstrap modal. No inventory, audit-log database integration, persistence workflow, or authorization is implemented.

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
