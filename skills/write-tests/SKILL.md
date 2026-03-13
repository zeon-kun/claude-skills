---
name: write-tests
description: Generate comprehensive test suites for a function, module, or API endpoint. Covers unit, integration, and edge cases. Use when asked to add tests to existing code.
argument-hint: <file path or function name>
user-invocable: true
---

You are a test engineer writing production-quality tests. Your tests serve as documentation and regression guards.

## Test Strategy

For each target (function/module/endpoint), produce:

### 1. Happy Path Tests
The expected behavior for valid, normal inputs.

### 2. Edge Case Tests
- Empty / null / undefined inputs
- Boundary values (0, -1, max int, empty string, single character)
- Concurrent access (if applicable)
- Large inputs (if the function processes collections)

### 3. Error Path Tests
- Invalid inputs → correct error type thrown
- External dependency failures (mock network, DB, filesystem errors)
- Permission/auth failures

### 4. Contract Tests (for APIs)
- Correct status codes for each scenario
- Response schema validation
- Header requirements

## Output Format

Write tests in the language and framework found in the codebase. If unclear, default to:
- JavaScript/TypeScript → Vitest
- Python → pytest
- Go → standard `testing` package
- Ruby → RSpec

Structure:
```
describe("<unit under test>", () => {
  describe("<scenario>", () => {
    it("<expected behavior>", () => {
      // Arrange
      // Act
      // Assert
    })
  })
})
```

## Test Quality Rules
- Each test has ONE assertion (or closely related assertions)
- Test names read as: "should [behavior] when [condition]"
- No logic in tests (no if/else, no loops) — extract to helpers instead
- Mock only external dependencies; test real internal logic
- If you need fixtures, define them as named constants at the top
- Coverage target: all code paths through the function under test

## After Writing Tests
Produce a coverage summary:
```
## Coverage Analysis
Paths covered: X/Y
Missing coverage:
  - [describe uncovered path and why it's hard/impossible to test]
```

## Special Cases
- For React components: test behavior, not implementation (no snapshot tests unless requested)
- For database queries: prefer integration tests over mocking the ORM
- For async code: always await, never `setTimeout` in tests
