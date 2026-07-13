#!/bin/zsh
set -euo pipefail

project_root=${0:A:h:h:h:h:h}
picker=$project_root/herdr/.config/herdr/bin/current-workspace-tab-picker
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT

cat > "$test_root/herdr" <<'STUB'
#!/bin/zsh
set -euo pipefail
printf '%s\n' "$*" >> "$HERDR_CALL_LOG"
if [[ "$1 $2" == "tab list" ]]; then
  [[ "$3" == "--workspace" ]]
  [[ "$4" == "$EXPECTED_WORKSPACE_ID" ]]
  if [[ "${MALFORMED_JSON:-0}" == "1" ]]; then
    printf '%s\n' '{malformed'
    exit 0
  fi
  printf '%s\n' '{"result":{"tabs":[{"number":3,"label":"grok","agent_status":"idle","tab_id":"w3:t7"},{"number":1,"label":"editor","agent_status":"unknown","tab_id":"w3:t1"},{"number":2,"label":"codex","agent_status":"working","tab_id":"w3:t4"}],"type":"tab_list"}}'
elif [[ "$1 $2" == "pane list" ]]; then
  printf '%s\n' '{"result":{"panes":[{"pane_id":"w3:p1","tab_id":"w3:t1"},{"pane_id":"w3:p4","tab_id":"w3:t4"},{"pane_id":"w3:p7","tab_id":"w3:t7"}],"type":"pane_list"}}'
elif [[ "$1 $2 $3" == "pane process-info --pane" ]]; then
  case "$4" in
    w3:p1) printf '%s\n' '{"result":{"process_info":{"foreground_processes":[{"name":"nvim"}]}}}' ;;
    *) printf '%s\n' '{"result":{"process_info":{"foreground_processes":[{"name":"zsh"}]}}}' ;;
  esac
elif [[ "$1 $2" == "tab focus" ]]; then
  printf '%s\n' "$3" > "$FOCUS_LOG"
else
  exit 64
fi
STUB

cat > "$test_root/fzf" <<'STUB'
#!/bin/zsh
set -euo pipefail
cat > "$FZF_INPUT_LOG"
if [[ "${FZF_CANCEL:-0}" == "1" ]]; then
  exit 130
fi
awk -F $'\x1f' 'index($1, ENVIRON["FZF_SELECT_LABEL"]) { print; found=1; exit } END { if (!found) exit 1 }' "$FZF_INPUT_LOG"
STUB

chmod +x "$test_root/herdr" "$test_root/fzf"
export PATH="$test_root:$PATH"
export HERDR_BIN_PATH="$test_root/herdr"
export HERDR_ACTIVE_WORKSPACE_ID=w3
export EXPECTED_WORKSPACE_ID=w3
export HERDR_CALL_LOG="$test_root/herdr-calls"
export FOCUS_LOG="$test_root/focus"
export FZF_INPUT_LOG="$test_root/fzf-input"
export FZF_SELECT_LABEL=codex

"$picker"

[[ "$(cat "$FOCUS_LOG")" == "w3:t4" ]]
[[ "$(sed -n '1p' "$HERDR_CALL_LOG")" == "tab list --workspace w3" ]]
[[ "$(sed -n '2p' "$HERDR_CALL_LOG")" == "pane list --workspace w3" ]]
[[ "$(rg -c '^pane process-info --pane ' "$HERDR_CALL_LOG")" == "3" ]]
[[ "$(sed -n '6p' "$HERDR_CALL_LOG")" == "tab focus w3:t4" ]]
expected_picker_input=$'  editor  unknown\x1fw3:t1\n󰚩  codex   working\x1fw3:t4\n󰧑  grok    idle\x1fw3:t7'
[[ "$(cat "$FZF_INPUT_LOG")" == "$expected_picker_input" ]]

rm -f "$FOCUS_LOG"
: > "$HERDR_CALL_LOG"
export FZF_CANCEL=1

"$picker"

[[ ! -e "$FOCUS_LOG" ]]
[[ "$(sed -n '1p' "$HERDR_CALL_LOG")" == "tab list --workspace w3" ]]
[[ "$(sed -n '2p' "$HERDR_CALL_LOG")" == "pane list --workspace w3" ]]
[[ "$(rg -c '^pane process-info --pane ' "$HERDR_CALL_LOG")" == "3" ]]

: > "$HERDR_CALL_LOG"
export MALFORMED_JSON=1
if "$picker"; then
  malformed_status=0
else
  malformed_status=$?
fi

(( malformed_status != 0 ))
[[ ! -e "$FOCUS_LOG" ]]
[[ "$(sed -n '1p' "$HERDR_CALL_LOG")" == "tab list --workspace w3" ]]
[[ "$(sed -n '2p' "$HERDR_CALL_LOG")" == "pane list --workspace w3" ]]
[[ "$(rg -c '^pane process-info --pane ' "$HERDR_CALL_LOG")" == "3" ]]

printf '%s\n' 'current-workspace-tab-picker tests passed'
