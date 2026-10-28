#!/usr/bin/env bash
# check-plan.sh — asserts the action planned both passes on testdata/fixture.
#
# The fixture pins golang.org/x/net v0.17.0 (vulnerable, upgradable) and
# actions/checkout@v4 (older than the latest release), so a working action
# must report updates and plan one change in each pass. Neither fact expires:
# the module stays vulnerable and checkout releases only move forward.
set -euo pipefail

: "${PLAN:?plan-file output missing}"
cat "$PLAN"
[[ "${HAS_UPDATES:-}" == "true" ]] || { echo "::error::has-updates=${HAS_UPDATES:-} (want true)"; exit 1; }
grep -q '^plan: go get golang.org/x/net ' "$PLAN" || { echo "::error::no package plan for golang.org/x/net"; exit 1; }
grep -q '^plan: actions/checkout ' "$PLAN" || { echo "::error::no action-pin plan for actions/checkout"; exit 1; }
