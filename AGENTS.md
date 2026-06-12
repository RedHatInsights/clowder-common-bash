# AGENTS.md

## Project Overview

clowder-common-bash is a Bash shell script library that provides helper functions for reading
configuration values from the Clowder operator's JSON config map. It is sourced into other shell
scripts and distributed by downloading the single entry-point file directly from the repository.

## Dependencies

**Runtime:** jq (required for JSON extraction), Bash >= 4 (recommended for future hashmap support)

**Dev/Test:** [BATS][bats-home] (Bash Automated Testing System), bats-support, bats-assert,
bats-file (all included as git submodules under `test/`)

**Linting:** [ShellCheck][shellcheck-home]

## Development Commands

See [Development Setup][readme-dev] in the README for the full command reference.

```bash
# Run ShellCheck on source files (also run in CI via .github/workflows/shellcheck.yaml)
shellcheck src/*.sh

# Run the test suite (also run in CI via .github/workflows/ci.yaml)
./test/bats/bin/bats test

# Clone with submodules (required for test libraries)
git clone --recursive <repo-url>

# Initialize submodules if cloned without --recursive
git submodule update --init --recursive
```

CI runs both ShellCheck linting and BATS tests on push and pull requests to `master`.

## Architecture

The library consists of a single source file (`src/clowder-config-main.sh`) structured in three
layers:

- **Detection:** `isClowderEnabled` checks whether the `ACG_CONFIG` environment variable is set and
  points to a readable file.
- **Internal extraction:** `_getClowderValue` and `_getClowderValueIfClowderEnabled` are private
  helpers (prefixed with `_`) that use jq to extract a given key from the config JSON. The
  "IfClowderEnabled" variant gates extraction behind an `isClowderEnabled` check.
- **Public API:** Five functions (`ClowderConfigWebPort`, `ClowderConfigMetricsPort`,
  `ClowderConfigMetricsPath`, `ClowderConfigPrivatePort`, `ClowderConfigPublicPort`) each delegate
  to `_getClowderValueIfClowderEnabled` with a hardcoded JSON key.

All configuration state flows through the `ACG_CONFIG` environment variable and the module-level
`CLOWDER_CONFIG` variable.

## Code Style

- **Linter:** ShellCheck (enforced in CI via `.github/workflows/shellcheck.yaml`)
- **Private functions:** Prefixed with `_` (e.g., `_getClowderValue`)
- **Public functions:** PascalCase (e.g., `ClowderConfigWebPort`)
- **Bash version:** Scripts use `#!/usr/bin/env bash` shebang; Bash >= 4 is recommended

## Common Mistakes

1. **Forgetting to set `ACG_CONFIG`:** All public functions require the `ACG_CONFIG` environment
   variable to point to a valid Clowder JSON config file. Without it, `isClowderEnabled` returns
   false and every accessor prints "Clowder config not enabled" to stdout.

2. **Missing jq dependency:** The library does not check for jq at runtime (there is a TODO in the
   source). If jq is not installed, `_getClowderValue` will fail with a command-not-found error
   rather than a clear message.

3. **Submodules not initialized:** The test suite depends on BATS libraries that are git submodules.
   Running `./test/bats/bin/bats test` without first running `git submodule update --init --recursive`
   will fail because the `test/bats/` directory will be empty.

4. **Return values are printed to stdout:** Public functions echo their result to stdout and use
   exit codes for success/failure. Capturing the output requires command substitution
   (e.g., `port=$(ClowderConfigWebPort)`), not checking `$?` alone.

5. **`CLOWDER_CONFIG` is module-level state:** The `CLOWDER_CONFIG` variable is set by
   `isClowderEnabled` and persists for the shell session. Changing `ACG_CONFIG` after the first call
   requires calling `isClowderEnabled` again to update the cached path.

## Testing

Tests are located in `test/test.bats` and use a fixture file at `test/test.json` that contains a
sample Clowder configuration. Run the suite with:

```bash
./test/bats/bin/bats test
```

Test libraries (bats-support, bats-assert, bats-file) are included as git submodules under
`test/`.

[bats-home]: https://github.com/bats-core/bats-core
[shellcheck-home]: https://www.shellcheck.net/
[readme-dev]: ./README.md#development
