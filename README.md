# clowder-common-bash

Simple client access helper functions for the configuration for the Clowder operator

**Please note** this is a work in progress and it's in a very early stage, function names, output format, and structure of returned data is likely to change

## Prerequisites

[jq][jq-home] is required to extract data (however it is not required to detect whether if the ClowderEnvironment is active or not).

Bash version >= 4 is **recommended** as future releases will make use of hashmaps

## Installation

To access the different configuration, load the `clowder-config-main` file in your shell:

```bash
curl https://raw.githubusercontent.com/squizzi/clowder-common-bash/master/src/clowder-config-main.sh -o clowder-config-main.sh && source clowder-config-main.sh
```

## Usage

Once sourced, you can use the helper functions to query Clowder configuration:

```bash
$ isClowderEnabled
# Returns 0 or 1 whether the Clowder environment is detected

$ ClowderConfigWebPort
8080
```

## API Reference

The library provides the following functions to access Clowder configuration values. All functions require the `ACG_CONFIG` environment variable to be set to the path of the Clowder configuration JSON file.

### `isClowderEnabled`

Checks whether the Clowder environment is active.

**Returns:** Exit code 0 if enabled, 1 otherwise

**Example:**
```bash
if isClowderEnabled; then
    echo "Clowder is enabled"
fi
```

### `ClowderConfigWebPort`

Returns the web port from the Clowder configuration.

**Returns:** The value of the `webPort` key (e.g., `8000`)

**Example:**
```bash
port=$(ClowderConfigWebPort)
```

### `ClowderConfigMetricsPort`

Returns the metrics port from the Clowder configuration.

**Returns:** The value of the `metricsPort` key (e.g., `9000`)

### `ClowderConfigMetricsPath`

Returns the metrics path from the Clowder configuration.

**Returns:** The value of the `metricsPath` key (e.g., `"/metrics"`)

### `ClowderConfigPrivatePort`

Returns the private port from the Clowder configuration.

**Returns:** The value of the `privatePort` key (e.g., `10000`)

### `ClowderConfigPublicPort`

Returns the public port from the Clowder configuration.

**Returns:** The value of the `publicPort` key (e.g., `8000`)

## Testing

Give it a try with a quick test run with the help of the included `test/test.json` file:

```bash
$ source src/clowder-config-main.sh
$ ( ACG_CONFIG="test/test.json";  isClowderEnabled && ClowderConfigWebPort )
```

Or run the full test suite with:

```bash
./test/bats/bin/bats test
```

## Development

### Setup

Clone the repository with submodules:

```bash
git clone --recursive https://github.com/squizzi/clowder-common-bash.git
cd clowder-common-bash
```

If you already cloned without `--recursive`, initialize the submodules:

```bash
git submodule update --init --recursive
```

The test suite uses [BATS][bats-home] (Bash Automated Testing System) with the following libraries:
- bats-support
- bats-assert
- bats-file

### Linting

This project uses [ShellCheck][shellcheck-home] for shell script linting. Install it on your system:

**macOS:**
```bash
brew install shellcheck
```

**Linux:**
```bash
# Debian/Ubuntu
apt-get install shellcheck

# Fedora/RHEL
dnf install ShellCheck
```

Run ShellCheck on all shell files:
```bash
shellcheck src/*.sh
```

### Running Tests

Run the test suite using BATS:

```bash
./test/bats/bin/bats test
```

Or with the proper library path set:

```bash
BATS_LIB_PATH=test/test_helper:test/bats/lib bats -r .
```

### Contributing

See [CONTRIBUTING.md][contributing] for contribution guidelines.

## License

This project does not currently have a specified license. Please contact the repository owner for licensing information.

[jq-home]: https://stedolan.github.io/jq
[bats-home]: https://github.com/bats-core/bats-core
[shellcheck-home]: https://www.shellcheck.net/
[contributing]: ./CONTRIBUTING.md
