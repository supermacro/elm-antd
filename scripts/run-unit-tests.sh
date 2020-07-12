#!/usr/bin/env bash

# Utility script for tests that run in a CI environment
#
# For some reason, elm-test emits a non-zero exit code when
# tests are skipped over.
# This script ensures that we return a 0 exit code when elm-test
# exits with a warning about tests having been skipped over


function check-failure () {
    declare -i ELM_TEST_EXIT_CODE=$?
    declare -i ELM_TEST_FAILURE_CODE=2
    declare -i ELM_TEST_WARNING_CODE=3

    if [ $ELM_TEST_EXIT_CODE -eq $ELM_TEST_FAILURE_CODE ]; then
        exit 1
    fi
}

echo "> Running component tests"
elm-test || check-failure

echo "> Running showcase tests"
cd showcase
elm-test || check-failure

exit 0

