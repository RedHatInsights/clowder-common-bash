setup() {
    load 'test_helper/common-setup'
    _common_setup

    source "src/clowder-config-main.sh"
}

@test "if run the script doesn't have any output" {
    run 'src/clowder-config-main.sh'
    assert_output ''
}

@test "is ClowderEnabled is defined" {
    run isClowderEnabled
    assert_output ''
}

@test "ClowderEnabled returns false if ACG_CONFIG is not defined" {

    assert [ -z ${ACG_CONFIG+x} ]
    run isClowderEnabled
    assert [ $status -eq 1 ]
}

@test "ClowderEnabled returns false if ACG_CONFIG defined but not readable" {

    local ACG_CONFIG="${BATS_TMPDIR}/test-noread.json"
    cp 'test/test.json' "$ACG_CONFIG"
    chmod a-r "$ACG_CONFIG"

    run isClowderEnabled

    assert [ $status -ne 0 ]
    assert_output ''
}

@test "ClowderEnabled returns true if ACG_CONFIG defined and readable" {

    local ACG_CONFIG="test/test.json"
    assert_file_exist "$ACG_CONFIG"

    run isClowderEnabled

    assert [ $status -eq 0 ]
    assert_output ''
}

@test "Get Metrics Path" {

    ACG_CONFIG="test/test.json"

    run ClowderConfigMetricsPath

    assert [ $status -eq 0 ]
    assert_output '"/metrics"'
}

@test "Get privatePort" {

    ACG_CONFIG="test/test.json"

    run ClowderConfigPrivatePort

    assert [ $status -eq 0 ]
    assert_output "10000"
}

@test "Get publicPort" {

    ACG_CONFIG="test/test.json"

    run ClowderConfigPublicPort

    assert [ $status -eq 0 ]
    assert_output "8000"
}

@test "Get metricsPort" {

    ACG_CONFIG="test/test.json"

    run ClowderConfigMetricsPort

    assert [ $status -eq 0 ]
    assert_output "9000"
}

@test "Get webPort " {

    ACG_CONFIG="test/test.json"

    run ClowderConfigWebPort

    assert [ $status -eq 0 ]
    assert_output "8000"
}

