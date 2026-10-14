# Techrent Documentation

## Purpose

Techrent is an internal web application for an IT equipment rental shop. It is intended for rental staff and administrators who will use separate interfaces while sharing a common application shell.

The application is currently being established as an ASP.NET Web Forms application targeting .NET Framework 4.8.1.

## Current scope

The current implementation includes an administrator dashboard, transaction and audit log pages, and a customer management page:

- `Pages/Admin/Admin.Master` provides the administrator sidebar and content shell.
- Bootstrap is the only stylesheet framework.
- Administrator page styles are kept in `css/admin/`.
- `Pages/Admin/Dashboard.aspx` displays database-backed payment revenue, active rentals, transaction statuses, and equipment availability through the application and data-access layers; the Last 30 days, Last 60 days, and Yearly selector filters the revenue KPI and Statistics chart, with 30-day chart data grouped into four labeled weeks and 60-day chart data grouped into eight labeled weeks in reverse chronological order so Week 1 is the most recent period, while Rental Activity shows Ongoing, Done, Late, and Overdue counts with an explicit no-activity state; Chart.js is used only for presentation.
- The administrator sidebar displays `assets/svg/dashboard.svg`, `assets/svg/transaction.svg`, and `assets/svg/customers.svg` beside the Dashboard, Transactions, and Customers navigation links; these icons use the `admin-sidebar-icon` class, explicit 18px dimensions, and CSS constraints to remain 18px square.
- The transaction log is loaded from the database through the rental application and data-access layers, with search applied when Enter is pressed, a created-date sort selector for earliest or latest dates, a status filter for All, Ongoing, Late, Overdue, or Done, and pagination limited to eight rows per page. Each log row resolves its own transaction details so the status filter can display distinct Ongoing, Late, Overdue, and Done records; customer contact fields are returned with the transaction data to avoid per-row customer queries and request timeouts. Non-completed transactions are automatically changed to Late after their due date and Overdue after more than three days past due; Done transactions remain unchanged. View opens a two-page modal: the first page displays current transaction details and automatically calculates late days, a violation state, a fixed $25.00-per-day late fee, and an updated total from the actual completion time versus the due date; the second page contains the scrollable unified printable receipt with transaction and customer identifiers, receipt number, creation and due dates, status, representative equipment, SKU, a single combined area for audit-log-derived pre-rental details with the auditor shown above the descriptions, rental fee, security deposit, amount paid, late fee, and total. The modal-scoped print action prints the complete receipt as one document. Only Done transactions have an enabled Archive action; confirmation sets Transactions.IsArchived through a guarded stored procedure, and archived records are excluded from subsequent transaction-log queries.
- `Pages/Admin/AuditLogs.aspx` loads audit records through `AuditService` using the rerunnable `Database/Scripts/005_SearchAudits.sql` migration and stored procedure `usp_SearchAudits`. The page supports Date From/To, Category, and keyword search and renders server-side pagination. The procedure joins `Users` to obtain the recorded user's role. Audit events are limited to successful logins, rental transaction creation, transaction completion, transaction archival, customer registration, and supported record deletion events; failed operations, sign-outs, payments, customer updates, and equipment changes are not logged. `Database/Scripts/011_RemoveLegacyAuditFields.sql` updates dependent procedures and removes the legacy `Outcome`, `AffectedRecordType`, `AffectedRecordId`, and `FailureDetail` columns. Affected-record and IP fields are not displayed because they are not part of the current audit contract.
- `Pages/Admin/Customers.aspx` loads customers, active-rental status, transaction history, and stored identification images from the database. Customer account status defaults to `Active` when displayed after registration, while rental activity remains a separate transaction concern. The edit modal renders available images from the stored binary data inside a fixed, overflow-safe portrait container, and edits preserve the existing image when no replacement is uploaded. Registration, edits, and deletion use stored procedures; image parameters are explicitly typed as `VARBINARY(MAX)`. Email and telephone inputs retain their HTML5 input types through generic Web Forms HTML controls.
- `Pages/Admin/Customers.aspx` supports server-side customer deletion through `usp_DeleteCustomer`. The deletion removes the customer and dependent rental payments, rental equipment links, and transactions in one database transaction, then records a successful `RecordDeleted` audit event. `Pages/Admin/Equipments.aspx` supports server-side equipment deletion through `usp_DeleteEquipment`; deletion is blocked with a Bootstrap alert while the equipment's current stock is greater than zero. Migration `Database/Scripts/015_DeleteCustomerAndEquipment.sql` provides both procedures.
- Customer profiles are stored in `dbo.Customers`, while `dbo.Users` contains only authenticated `Admin` and `RentalStaff` accounts. Migration `Database/Scripts/010_SplitCustomers.sql` preserves existing customer GUIDs, remaps transaction foreign keys, and removes migrated customer rows from `Users`; audit actor references remain associated with authenticated users. The customer removal confirmation modal displays the selected customer's first name through the client-side modal handler, avoiding data binding outside a repeater.
- `Pages/RegisterUser.aspx` is exposed through the public `/register` route for bootstrap and testing. It hashes passwords with the application PBKDF2 `PasswordService` and can create an Admin or RentalStaff account without an existing administrator session. The database procedure still enforces its provisioning flag for other callers. Sign-in uses the resulting email and raw password through `Pages/Signin.aspx`; raw passwords are never stored.
- The public authentication pages are exposed through `/signin` and `/register`. Forms Authentication, registration navigation, and logout redirects use these routes instead of physical `.aspx` paths.
- Shared Admin and Rental Staff Sign out buttons disable ASP.NET and HTML5 client validation so required fields on the current workflow page cannot block logout postbacks.
- `Web.config` permits multipart requests up to 6 MB so registration postbacks, including the validated 5 MB identification photo and request overhead, are not rejected before Web Forms event handlers such as Sign out can run. Database access reads the `TECHRENT_CONNECTION_STRING` environment variable; the machine-specific connection string is not stored in `Web.config`. `.env.example` documents the expected local variable, while `.env` is ignored by source control.
- Friendly and direct protected routes are authorized centrally from `RouteConfig`: Admin routes require `Admin`, Rental Staff routes require `RentalStaff`, and other direct `.aspx` pages require authentication. Only `/signin` and `/register` are public, and unauthorized requests receive HTTP 403. Every forms-authentication request revalidates the user ID, active status, and role against the database before establishing the principal; changes to a user's role or active status invalidate the session. `AuthenticatedUserContext` exposes that validated actor to audit workflows and other application services, while failed anonymous sign-in events remain recorded without an authenticated user ID.
- `.gitignore` excludes environment secrets, Visual Studio state, build output, local database files, and local `App_Data` artifacts while retaining database scripts, assets, and the package setup required by the legacy project.
- Shared Admin and Rental Staff master pages perform an additional role check during page loading, preventing protected child pages from rendering when the validated current user is missing or has the wrong role.
- Rental Staff sign out clears the browser-stored rental dates before ending the authenticated session, so a subsequent rental starts without dates from the previous session.
- `Pages/Admin/Equipments.aspx` loads inventory from `usp_SearchEquipment`, displays stored equipment images inside a constrained details card, and persists modal edits to Type, Status, Stock, BaseRentalFee, and SecurityDeposit through `usp_UpdateEquipment`; `Pages/Admin/InsertEquipment.aspx` persists Category, Type, Status, Model, SKU, Stock, and Image through `usp_CreateEquipment`. The repository explicitly binds the optional image as `VARBINARY(MAX)` so equipment can be created without an uploaded image. EquipmentID and CreatedAt remain database-generated. The current equipment contract has no serial-inventory fields.
- The Rental Staff workflow under `Pages/RentalStaff/` loads customers and available equipment from database services. `New.aspx` renders the customer table through its server-side repeater, includes stored customer occupation, organization address, account status, and identification-card images in the detail data attributes, and displays the selected portrait card in a cache-busted, fixed-height details-modal placeholder with JPEG/PNG format detection and an unavailable-image fallback. `RegisterCustomer.aspx` persists customer records and validates uploaded JPG/JPEG/PNG identification images by signature with a 5 MB size limit before sending them to the typed `VARBINARY(MAX)` parameter. Equipment selections are validated against current stock before review, and the review confirmation persists the rental and initial payment atomically. Required rental start and return date-times and selected equipment are carried between workflow pages in browser state and revalidated on the server before persistence. `SerialAssignment.aspx` renders the assignment step directly, and the Review page returns to it without losing the selected customer context.
- `Pages/RentalStaff/Review.aspx` loads the selected customer from the database, renders the equipment selected in `techrent.selectedEquipment` without displaying SKU/serial values, calculates hourly rental charges across the complete rental period with partial hours rounded up, and persists the rental and payment through the rental service. Equipment selection displays the database-backed `Equipments.BaseRentalFee` hourly rate and `Equipments.SecurityDeposit` values, and the review save path re-reads those values before creating each transaction item. The confirmation flow uses stable client IDs for its hidden client/server handoff fields so the receipt modal opens before the server-side save and reopens after a successful Web Forms postback once the page scripts have loaded. The receipt print action remains browser-based. Rental transaction records persist `StartAt`, `DueAt`, and the rounded-up `BillableHours` value.
- The receipt displays Techrent's sample Quezon City contact block above the receipt header and provides a manual rental staff signature line near the receipt footer.
- The active-transactions Mark as done action uses a fixed-size, flex-aligned check SVG icon within the button.
- The active-transactions completion modal submits the selected transaction to a server-side Web Forms handler, which persists the transaction as `Done`, optional return condition notes (up to 500 characters), and optional repeatable `LateFee` or `DamageCharge` entries through the parameterized completion and payment procedures. Each additional charge uses `Cash` or `GCash` and is saved as its own payment record in the same database transaction; existing databases receive the charge contract through `Database/Scripts/013_AddCompletionCharges.sql`.
- Back-related navigation and cancel actions across the Rental Staff and Admin interfaces use the shared `assets/svg/back.svg` icon.
- The rental receipt uses separated customer-information fields, readable table spacing, and print-specific page-break rules to keep receipt content from overlapping or splitting awkwardly.
- The receipt footer places the manual rental staff signature area beside the charge summary and uses compact print spacing to keep the receipt on one page when possible.
- `Pages/Admin/Transactions.aspx` opens a single scrollable `Rental Receipt` modal with the TECHRENT contact block, database-backed customer contact fields, equipment, payment totals, and guarded archive behavior; the assigned rental units table excludes serial numbers, and unsupported actual-return and rate fields are not fabricated.
- `Pages/Admin/Payments.aspx` provides a database-backed Payments Activity page at `/payments`, linked from the administrator sidebar. It displays Payment ID, Transaction ID, payment type, amount, payment method, and created date from `TransactionPayment`, including completion-time `LateFee` and `DamageCharge` records; the page supports client-side keyword search, latest/earliest created-date sorting, a fixed ten-item page size, and pagination positioned below the table or empty-state message. `PaymentRepository` and `PaymentService` retrieve the records through `dbo.usp_GetPaymentActivity`.
- The Rental Staff home workspace centers its welcome card horizontally and vertically, greets the authenticated staff member using the database-backed first name, and provides actions to create a new transaction or view active transactions. `Pages/RentalStaff/ActiveTransactions.aspx` displays database-backed active rental rows in a responsive table with the Status heading aligned to its status records; Mark as done opens a wide, landscape-oriented confirmation modal showing the transaction code, customer, customer ID, due date, and current status beside a transaction-level return-condition audit card with one generic equipment entry and optional notes. The completion modal now uses balanced responsive spacing, wraps long identifiers safely, scrolls within short viewports, and stacks additional-charge controls before they can overflow the audit card. A successful completion displays a Bootstrap success alert after the transaction list is refreshed. A condition selection is not required; the selected transaction and notes are submitted through the server-side completion handler and persisted in the database.
- `Pages/Admin/Guidelines.aspx` explains how return notes relate to the existing damage-charge matrix: good or undamaged returns have no damage charge, damaged returns use the cosmetic or functional rate, and missing or beyond-repair returns use the existing Beyond repair / lost rate. The matrix percentages remain static and are not connected to a database.
- The Rental Staff home action buttons use a fixed-size, flex-aligned view SVG icon so the icon remains fitted within the active-transactions link.
- The serial-number assignment page uses compact serial-number dropdowns sized for the available serial values, a narrower centered assignment card, two-column assignment rows that stack on smaller screens, and step 2 navigation actions in the page header and form footer. Its Review-page back link preserves the selected customer context.
- Rental Staff routes include `/` (`RentalStaff`), `/rentalStaff/active-transactions` (`RentalStaffActiveTransactions`), `/rentalStaff/new` (`RentalStaffNew`), `/rentalStaff/register-customer` (`RentalStaffRegisterCustomer`), `/rentalStaff/equipment` (`RentalStaffEquipment`), and `/rentalStaff/serial-assignment` (`RentalStaffSerialAssignment`). The equipment Continue action opens the serial-assignment step when at least one unit is selected. The master-page Sign out control remains non-functional because authentication is not implemented.
- The Rental Staff flow carries required start/end date-times through browser state and revalidates them on the server. Hourly rental fees use the complete elapsed period, with any partial hour rounded up; security deposits remain per unit. Customer search, customer profile details, equipment search, category filtering, quantity aggregation, removal, and stock limits remain browser interactions until their corresponding server workflows are invoked. The equipment category filter uses the database category contract (`Laptop`, `Desktop`, `Monitor`, `Projector`, `Peripheral`, and `Other`) and compares values case-insensitively. Decreasing an item below one unit removes it from the transaction summary.
- Equipment summary plus, minus, and Remove controls use delegated client-side click handling so they continue working after the summary is re-rendered; quantities remain within stock limits and estimated totals update immediately.
- Equipment Add buttons use the fixed-size `assets/svg/add.svg` icon alongside their labels.
- All application search bars use the shared embedded search-icon treatment and apply text searches only after the Enter key is pressed. Non-text filters, such as category and sort selectors, continue to apply when changed.
- No authentication or role authorization is implemented yet.
- The initial ADO.NET database foundation is implemented for customers, equipment, rental transactions, rental items, and audit logs. Database access uses stored procedures and is separated into DTOs, repositories, and application services. Rental timing is stored in `Transactions.StartAt`, `Transactions.DueAt`, and `Transactions.BillableHours`; `TransactionEquipments.RentalFee` stores the hourly rate multiplied by the server-validated rounded-up duration. Transaction completion uses the Done status, while transaction archiving uses the IsArchived flag and is restricted to Done records.
- `Web.config` contains the named `TechrentConnection` SQL Server Express connection string. `Data Access Layer/Repositories/DatabaseConnectionFactory.cs` creates unopened `SqlConnection` instances from that configuration; repositories open and dispose connections within `using` scopes.
- `Database/Scripts/000_DeployDatabase.sql`, `Database/Scripts/001_CreateSchema.sql`, and `Database/Scripts/002_CreateStoredProcedures.sql` include the required rental timing contract for fresh deployments. `Database/Scripts/003_AddTransactionArchiving.sql` upgrades an existing database with the archive flag, Done status constraint, transaction-log query, completion procedure, and guarded archive procedure. `Database/Scripts/011_AddOverdueTransactionStatus.sql` adds automatic Late and Overdue transitions and keeps the transaction-detail lookup constrained to the requested transaction, preserving distinct statuses in the transaction log. `Database/Scripts/014_AddRentalTiming.sql` incrementally adds required rental start and billable-hour fields, updates transaction creation and retrieval procedures, and must be applied without dropping the existing tables after dependent transaction records have been cleared. For an existing database showing a `usp_CreateTransaction` parameter mismatch, execute `014_AddRentalTiming.sql` against the active database before saving a rental.
- `Application Layer/Services/ServiceFactory.cs` provides Web Forms-compatible service construction without adding a dependency-injection framework. Existing pages remain presentation-only until their markup is deliberately changed to bind service results.

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
4. `/rentalStaff/register-customer` presents first name, last name, occupation, email, mobile number with a `+63` prefix, and organization address fields. Occupation uses the `Student`, `Employed`, `Unemployed`, and `Other` options. Mobile input accepts digits only and blocks spaces. The form accepts JPG, PNG, and HEIC identification photos and displays supported images in a constrained portrait card with a `No attached photo` placeholder before selection. HEIC preview depends on browser support.
5. `/rentalStaff/equipment` displays database-backed equipment cards with each equipment type (`Obsolete`, `Standard`, or `Professional`), Enter-triggered search, category filters, required rental start/end date-times, and a transaction summary. Each selected equipment line shows its duration-based rental fee and security deposit per unit. Selecting a card adds one unit, repeated selections aggregate by equipment model, quantities cannot exceed the displayed stock, and estimated totals update in the browser before server-side recalculation.
6. `/rentalStaff/serial-assignment` assigns static serial numbers to the sample units and opens the final review when all units are assigned.
7. `/rentalStaff/review` displays static customer, equipment, serial-number, and estimated-charge details. Rental staff can enter optional pre-rental audit-log notes with a 500-character limit, enter the amount paid, and confirm the draft in the browser. Confirmation opens a printable receipt modal with Print and Close actions; the presentation-only receipt displays the entered payment and calculates the change against the sample ₱13,500.00 total, and Close dismisses the receipt directly without a print-confirmation prompt. Neither the notes, receipt, paid amount, calculated change, nor draft confirmation is persisted.

The flow persists customer registrations, rental timing, equipment charges, payments, and review data through the application and data-access layers. Serial assignment, returns, customer management, equipment availability management, and authentication remain separate workflows or future enhancements.

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

## Database setup

The default development configuration targets SQL Server Express at `./SQLEXPRESS` and a database named `techrentDB` using Windows authentication. Create the database before running the scripts, or change the `TechrentConnection` value in `Web.config` to match the local SQL Server Express instance and database name. Keep machine-specific credentials and production connection strings out of source control.

Run these files in order:

1. `Database/Scripts/000_DeployDatabase.sql` for an additive deployment to an existing database
2. `Database/Scripts/001_CreateSchema.sql` and `Database/Scripts/002_CreateStoredProcedures.sql` for a clean database
3. `Database/Scripts/003_AddTransactionArchiving.sql` when upgrading an existing database with transaction archiving support
4. `Database/Scripts/004_AddPaymentActivity.sql` when upgrading an existing database with the Payments Activity page
5. `Database/Scripts/005_SyncEquipmentUpdateProcedure.sql` when an existing database reports that `usp_UpdateEquipment` has too many arguments specified

The database contract follows the ERD tables `Users`, `Equipments`, `Transactions`, `TransactionEquipments`, `TransactionPayment`, and `Logs`. Customer mobile numbers use `Users.MobileNumber`, and transaction deadlines use `Transactions.DueAt`; stored procedures use these same names. All primary and foreign keys use SQL Server `UNIQUEIDENTIFIER` values. Transaction statuses include `Ongoing`, `Overdue`, `Late`, and `Done`; payment types are `RentalFee`, `Deposit`, and `LateFee`; equipment statuses are `Available`, `Rented`, and `Maintenance`; payment methods are `Cash` and `GCash`; and equipment types are `Obsolete`, `Standard`, and `Professional`. The current contract does not include serial inventory, actual-return timestamps, equipment rates, telephone numbers, user deactivation, affected audit records, or IP addresses.

Repositories call stored procedures only. They do not expose `SqlConnection`, `SqlCommand`, or `DataReader` objects to the Application Layer. Multi-step rental creation is protected by an explicit ADO.NET transaction in `RentalRepository`, and payment persistence is provided by `PaymentRepository` and `PaymentService`.

## Project configuration notes

- `Techrent.csproj` explicitly includes the application, page, master-page, code-behind, and designer files required for the non-SDK ASP.NET Web Forms build. Matching `DependentUpon` metadata keeps the files associated with their markup and allows the compiled `Techrent.Global` type to be resolved from `Global.asax`.
- The `TechrentConnection` connection string uses the `System.Data.SqlClient` keyword `TrustServerCertificate` without spaces so SQL connections can be initialized successfully.
- Server-side HTML inputs whose types are not supported by `HtmlInputText` (including number, email, and tel inputs) use `HtmlInputGenericControl` in their designer declarations to match ASP.NET Web Forms parser behavior.
- Server-side controls referenced by upload-preview JavaScript use `ClientIDMode="Static"` so file inputs and preview alerts retain the IDs expected by the client-side scripts.
- The equipment edit form sends `EquipmentID`, `Type`, `Status`, `Stock`, `BaseRentalFee`, and `SecurityDeposit` to `usp_UpdateEquipment`. Run `Database/Scripts/005_SyncEquipmentUpdateProcedure.sql` against an existing database whose procedure has an older parameter list before saving equipment edits.

## Future development phases

1. Expand service-level validation and result types for user-facing workflows.
2. Bind the Rental Staff and Administrator pages to application services where each page is ready for database-backed behavior.
3. Add authentication and role-based authorization.
4. Add tests for application use cases, repository mappings, and stored-procedure contracts.
5. Add deployment configuration and operational documentation.
