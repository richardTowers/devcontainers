#!/bin/bash

set -e

# Import test library
# https://github.com/devcontainers/cli/blob/main/docs/features/test.md
source dev-container-features-test-lib

check "claude binary exists" bash -c "command -v claude"
check "claude is executable" bash -c "test -x \$(command -v claude)"
check "claude --version works" bash -c "claude --version"

reportResults
