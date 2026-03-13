# Review PR

Deep code review combining quality and security analysis.

Launches the `code-reviewer` agent which applies:
- Code quality review (code-review skill)
- Security vulnerability scan (security-audit skill)

## Usage
`/review-pr <file path, directory, or paste the diff>`

## What you'll get
1. Severity-tagged findings (CRITICAL → LOW)
2. Security vulnerability scan (OWASP Top 10)
3. Specific fixes for every issue
4. Explicit APPROVE / REQUEST CHANGES verdict

---

$ARGUMENTS

Use the `code-reviewer` agent to perform a thorough code review and security audit of:

$ARGUMENTS

If no arguments were provided, ask: "Please provide the file path, directory, or paste the code/diff to review."
