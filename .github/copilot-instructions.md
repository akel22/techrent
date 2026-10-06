# Copilot Instructions for Techrent

## Project baseline

- This is a classic ASP.NET Web Forms application targeting .NET Framework 4.8.1.
- Preserve Web Forms code-behind, designer files, master-page, and legacy Web Application project conventions.
- Do not migrate or convert the project unless the user explicitly requests it.
- Keep changes compatible with the packages and framework already used by the project.
- Update `DOCUMENTATION.md` whenever files, folders, code, or libraries are added or changed, so Copilot's project context stays current.

## UI rules

- Reuse `Site.Master` for application pages that use the shared shell.
- Keep the header and navigation concise and role-neutral until authentication and authorization are implemented.
- Use Bootstrap as the only stylesheet framework.
- Prefer Bootstrap components and utility classes before adding custom CSS.
- Keep custom CSS minimal and focused on shared layout or accessibility needs.
- Place page-specific CSS files in the dedicated root css folder rather than adding page styles to shared Content/Site.css; keep each page's styles separated.
- Do not add animations, gradients, or decorative web-design effects.
- Do not create Admin or Rental Staff pages unless the user explicitly requests their implementation.
- Do not add navigation links to pages that do not exist.
- Preserve user-provided files in `Pages` and `assets`; inspect them before creating replacements.

## Architecture rules

- Keep presentation logic in Web Forms pages and code-behind.
- Keep application workflows and business orchestration in `Application Layer`.
- Keep database communication, DTO mapping, and stored-procedure calls in `Data Access Layer`.
- Do not place SQL, connection handling, or business transaction rules in `.aspx.cs` files.
- Do not bypass the intended layers by coupling UI controls directly to database code.

## Database rules

- Use ADO.NET and stored procedures for database access when that work is requested.
- Do not introduce Entity Framework Core or EF Core LINQ queries.
- Prefer database-side aggregate functions and calculations when they are part of the database contract.
- Use parameterized commands and explicit transaction boundaries.
- Keep connection strings in configuration, not in source code.
- Map stored-procedure results into DTOs or application models before returning them to the UI.

## Project-file and validation rules

- This is a legacy non-SDK Web Application project. Newly added files may require explicit entries in `Techrent.csproj`.
- Keep `.aspx`, code-behind, and designer `DependentUpon` relationships correct.
- Build the solution after code or project-file changes.
- Investigate and fix errors introduced by the change; do not hide them with broad workarounds.
- Do not add a root README until the project owner requests it after the project is complete.

## PowerShell Commands

- When writing future PowerShell commands that need line breaks, use `[Environment]::NewLine` instead of `r`n, especially in replacement strings.

## Audit Display Rules

- When displaying consolidated pre-rental audit details, place the auditor attribution above the actual detail description instead of repeating it in parentheses after every serial-number entry.
