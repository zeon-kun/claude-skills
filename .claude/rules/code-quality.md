# Code Quality Rules

Standards applied across all code generation and review in this repository.

## Code Generation Standards

### General
- Write code that the most junior developer on the team can understand
- Prefer explicit over implicit — no magic, no clever tricks without comments
- One function, one responsibility — if you can't name it without "and", split it
- Functions > 20 lines need justification
- Nesting > 3 levels needs refactoring

### Error Handling
- Errors must be handled or explicitly propagated — never silently swallowed
- Error messages must be actionable ("Failed to connect to database at {host}" not "Error")
- Distinguish between user errors (400) and system errors (500)

### Testing
- New business logic requires tests before or alongside the code
- Tests must be deterministic — no random data, no time-dependent behavior without mocking
- Test file mirrors the source file location (`src/auth.ts` → `src/auth.test.ts`)

### Naming
- Variables: describe what they ARE (`userId`, not `id` or `x`)
- Functions: describe what they DO (`getUserById`, not `get` or `fetch`)
- Booleans: `is`, `has`, `should`, `can` prefix (`isActive`, `hasPermission`)
- Constants: SCREAMING_SNAKE_CASE for module-level constants

## Review Standards
- Review for security first, correctness second, style third
- Every finding must cite file:line and provide a concrete fix
- Acknowledge good work in reviews — it reinforces patterns to continue
