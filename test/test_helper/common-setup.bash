#!/usr/bin/env bash

_common_setup() {

    local BATS_HELPER_LIBRARY_PATH='test_helper'

    if [ -n "${GITHUB_ACTION+x}" ]; then
        BATS_HELPER_LIBRARY_PATH='/usr/lib'
    fi

    load "${BATS_HELPER_LIBRARY_PATH}/bats-support/load.bash"
    load "${BATS_HELPER_LIBRARY_PATH}/bats-assert/load.bash"
    load "${BATS_HELPER_LIBRARY_PATH}/bats-file/load.bash"
}

