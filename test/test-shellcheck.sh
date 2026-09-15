#!/usr/bin/env bash
# run shellcheck on the bash scripts
# TODO: this only checks for errors for now, make it stricter over time

echo running "$0"
set -o errexit
#set -o nounset
set -o pipefail

ROOT=$(dirname "${BASH_SOURCE[0]}")/..
cd "${ROOT}"
# shellcheck disable=SC1091
. test/util.sh

command -v shellcheck >/dev/null 2>&1 || { echo >&2 "shellcheck not found"; exit 1; }

find_files() {
	repo_files | grep -e '\.sh$' -e '\.bash$' | grep -v 'misc/delta-cpu.sh'
}

mapfile -t files < <(find_files)

# We start at the error severity so that the existing scripts pass. Lower it
# with --severity=warning and so on, as the scripts get cleaned up.
if ! shellcheck --severity=error "${files[@]}"; then
	fail_test "The above bash files did not pass shellcheck"
fi
echo 'PASS'
