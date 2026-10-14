# Techrent

Techrent is an ASP.NET Web Forms application for managing IT equipment rentals, customers, transactions, payments, and audit activity. It targets **.NET Framework 4.8.1** and uses SQL Server stored procedures through ADO.NET.

## Requirements

- Visual Studio with ASP.NET and web development tools
- .NET Framework 4.8.1 Developer Pack
- SQL Server or SQL Server Express
- A database created from the scripts in `Database/Scripts`

## Getting started

1. Clone the repository.
2. Create the Techrent database by running the database scripts in `Database/Scripts` in their numbered order.
3. Copy `.env.example` to `.env`, or set the environment variable directly in Windows/Visual Studio.
4. Set `TECHRENT_CONNECTION_STRING` to a connection string for the local database. The application reads this environment variable at runtime; it does not read a connection string from `Web.config`.
5. Open `Techrent.slnx` in Visual Studio.
6. Restore NuGet packages and run the application with IIS Express.
7. Open `/register` to create an initial Admin or Rental Staff account, then use `/signin` to log in.

The real `.env` file and database credentials must never be committed. `.env.example` is only a safe configuration template.

## Routes

### Public routes

| Route | Purpose |
| --- | --- |
| `/signin` | Sign in with an existing staff or administrator account. |
| `/register` | Bootstrap or test registration of an Admin or Rental Staff account. |

### Rental Staff routes

All of these routes require an authenticated `RentalStaff` account.

| Route | Purpose |
| --- | --- |
| `/` | Rental Staff dashboard. |
| `/rental-staff/active-transactions` | View active rental transactions. |
| `/rental-staff/new` | Create a rental transaction. |
| `/rental-staff/register-customer` | Register a customer. |
| `/rental-staff/equipment` | Browse equipment. |
| `/rental-staff/review` | Review rental details. |

### Administrator routes

All of these routes require an authenticated `Admin` account.

| Route | Purpose |
| --- | --- |
| `/dashboard` | Administrator dashboard. |
| `/transactions` | Transaction log and transaction management. |
| `/payments` | Payment activity. |
| `/audit-logs` | Audit log search. |
| `/customers` | Customer management. |
| `/equipments` | Equipment management. |
| `/equipments/insert` | Add equipment. |
| `/damage-charge-guidelines` | View damage-charge guidelines. |

Forms Authentication and application-level authorization reject anonymous access to protected routes and reject users with the wrong role. Direct access to application `.aspx` pages is also protected.

## Configuration

The required environment variable is:

```text
TECHRENT_CONNECTION_STRING=Data Source=localhost\SQLEXPRESS;Initial Catalog=techrentDB2;Integrated Security=True;TrustServerCertificate=True
```

For a deployed application, configure the variable in the hosting environment rather than storing it in source control. For local development, `.env.example` can be copied to `.env`; the project does not load `.env` automatically, so Visual Studio or the process hosting IIS Express must receive the variable.

## Project structure

- `Pages/` - Web Forms pages, master pages, and code-behind.
- `Application Layer/` - Application workflows and business orchestration.
- `Data Access Layer/` - DTOs, repositories, stored-procedure calls, and database connections.
- `Database/Scripts/` - Numbered SQL schema and migration scripts.
- `Content/` and `css/` - Bootstrap and application styles.
- `assets/` - Shared application assets.

## Security notes

- Do not commit `.env`, credentials, local database files, or machine-specific configuration.
- Passwords are hashed by the application and are not stored as plain text.
- Keep database access in the data-access layer and use the supplied stored procedures.
- Registration is intentionally public for bootstrap/testing. In a production deployment, restrict or remove public registration according to the deployment policy.
