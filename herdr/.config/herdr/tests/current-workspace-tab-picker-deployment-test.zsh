#!/bin/zsh
set -euo pipefail

project_root=${0:A:h:h:h:h:h}

for executable in current-workspace-tab-picker current-workspace-tab-picker-rows; do
  source_executable=$project_root/herdr/.config/herdr/bin/$executable
  deployed_executable=$HOME/.config/herdr/bin/$executable
  [[ -x "$deployed_executable" ]]
  [[ "$deployed_executable:A" == "$source_executable:A" ]]
done

printf '%s\n' 'current-workspace-tab-picker deployment test passed'
