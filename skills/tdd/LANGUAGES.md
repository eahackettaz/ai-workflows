# Language-specific TDD conventions

Language-universal testing idioms, so tests match each language's norms. These are
**defaults**. Project-specific choices — which runner this repo actually uses,
coverage bars, where fixtures live — come from the project's `CLAUDE.md` /
`CONTEXT.md`. Read those first; fall back to this file when the project is silent.

The red-green-refactor discipline in [SKILL.md](SKILL.md) is identical across every
language. Only the mechanics below change.

## TypeScript / JavaScript

- **Runner**: Jest or Vitest (Vitest for Vite/ESM projects). Check `package.json`.
- **Layout**: `*.test.ts` / `*.spec.ts` beside source, or under `__tests__/`.
- **Structure**: `describe` / `it`; `expect(...).toBe(...)`.
- **Async**: `async` tests; `await` the behavior, then assert the result.
- **Mocking**: `vi.mock` / `jest.mock` at true external seams only (see
  [MOCKING.md](MOCKING.md)). Prefer fakes over asserting `toHaveBeenCalled`.
- **Run**: `npm test` / `npx vitest run`.

## Python

- **Runner**: pytest (not `unittest`, unless the repo already uses it).
- **Layout**: `tests/` package, or `test_*.py` beside source; functions `test_*`.
- **Structure**: plain `assert` — pytest rewrites it for rich diffs. No assert-methods.
- **Fixtures**: `@pytest.fixture` for setup; `conftest.py` for shared fixtures.
- **Table cases**: `@pytest.mark.parametrize`.
- **Mocking**: `pytest-mock` / `unittest.mock` at boundaries only; `monkeypatch` for env.
- **Run**: `pytest -q`.

## Go

- **Runner**: built-in `testing`; add `testify` only if the repo already uses it.
- **Layout**: `foo_test.go` beside `foo.go`; funcs `TestXxx(t *testing.T)`.
- **Structure**: **table-driven tests** are the idiom — a slice of cases with
  `t.Run(name, ...)` per case for subtests.
- **Assertions**: standard lib is `if got != want { t.Errorf(...) }`. Keep it plain
  unless testify is already established.
- **Mocking**: prefer small interfaces + hand-written fakes over mock frameworks;
  inject via interface params.
- **Run**: `go test ./...`.

## Rust

- **Runner**: built-in `cargo test`.
- **Layout**: unit tests in a `#[cfg(test)] mod tests` block in the same file;
  integration tests in `tests/`.
- **Structure**: `#[test]` fns; `assert!`, `assert_eq!`. `#[should_panic]` for panics;
  or return `Result<(), E>` and use `?` for fallible tests.
- **Mocking**: trait objects + hand-written fakes; `mockall` only if established.
- **Run**: `cargo test`.

## C / C++ (incl. embedded)

- **Runner**: Unity/Ceedling or CMocka for C; GoogleTest/Catch2 for C++. Check the repo.
- **Layout**: `test_*.c` / `*_test.cpp` under a `test/` dir; one build target per test.
- **Structure**: `TEST_ASSERT_*` (Unity) / `EXPECT_*`, `ASSERT_*` (GoogleTest).
- **Embedded seam**: test business logic **on the host**, not on-target. Abstract
  hardware behind an interface and supply a host fake — the fast deterministic
  feedback loop (see the `diagnose` skill) lives on the host. Reserve on-target runs
  for integration.
- **Mocking**: CMock (with Ceedling) generates mocks from headers; GoogleMock for C++.
- **Run**: `ceedling test:all` / `ctest`.
