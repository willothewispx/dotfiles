#!/bin/zsh
set -euo pipefail

project_root=${0:A:h:h:h:h:h}
source_picker=$project_root/herdr/.config/herdr/bin/current-workspace-tab-picker
deployed_picker=$HOME/.config/herdr/bin/current-workspace-tab-picker

[[ -x "$deployed_picker" ]]
[[ "$deployed_picker:A" == "$source_picker:A" ]]

printf '%s\n' 'current-workspace-tab-picker deployment test passed'
