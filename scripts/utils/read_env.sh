#!/bin/bash
set -euo pipefail

# allow to read file and use is content
read_var() {
  VAR=$(grep $1 $2 | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  echo ${VAR[1]}
}
