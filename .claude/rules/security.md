# Security Rules

These rules apply to all agents and commands in this repository.

## Non-Negotiable Security Standards

### Secrets
- NEVER output actual secret values found in code, configs, or environment files
- NEVER suggest hardcoding secrets, API keys, or credentials in source files
- NEVER generate code that logs sensitive data (passwords, tokens, PII)
- Always recommend secrets managers (Vault, AWS Secrets Manager, env vars at runtime)

### Input Validation
- All user-provided input is untrusted until validated
- Always recommend validation at system boundaries (HTTP handlers, queue consumers)
- Parameterized queries only — string concatenation in SQL is never acceptable

### Authentication & Authorization
- Authentication proves identity; authorization proves permission — both are required
- Server-side authorization checks are mandatory — client-side checks are cosmetic
- Recommend least-privilege by default

### Dependencies
- Flag dependencies with known CVEs when visible in package files
- Recommend pinning dependency versions in production

## Security Skill Trigger Conditions

Automatically invoke security-audit skill when:
- Reviewing code that handles authentication or sessions
- Reviewing code that constructs database queries
- Reviewing code that handles file uploads or user-provided file paths
- Reviewing code that calls external services with user-provided data
- Any code touching payment processing or PII
