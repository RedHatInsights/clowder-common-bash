#!/usr/bin/env bash

CLOWDER_CONFIG=""

isClowderEnabled() {

    CLOWDER_CONFIG="$ACG_CONFIG"

    [ -n "$CLOWDER_CONFIG" ] && [ -r "$CLOWDER_CONFIG" ]
}

_getClowderValue() {

    local KEY="$1"
    local VALUE
    VALUE=$(jq ".$KEY" "$CLOWDER_CONFIG")

    if [ -z "$VALUE" ]; then
        echo "no value found for key '$KEY'"
        return 1
    else
        echo "$VALUE"
    fi
}

# TODO: check jq is in the system

_getClowderValueIfClowderEnabled() {

    local KEY="$1"

    if isClowderEnabled; then
        _getClowderValue "$KEY"
    else
        echo "Clowder config not enabled"
        return 1
    fi
}

ClowderConfigMetricsPath() {
    _getClowderValueIfClowderEnabled 'metricsPath'
}

ClowderConfigWebPort() {
    _getClowderValueIfClowderEnabled 'webPort'
}

ClowderConfigMetricsPort() {
    _getClowderValueIfClowderEnabled 'metricsPort'
}

ClowderConfigPrivatePort() {
    _getClowderValueIfClowderEnabled 'privatePort'
}

ClowderConfigPublicPort() {
    _getClowderValueIfClowderEnabled 'publicPort'
}
