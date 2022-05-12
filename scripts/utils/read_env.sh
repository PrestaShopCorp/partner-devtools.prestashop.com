#!/bin/bash

# allow to read file and use is content
readEnv() {
  VAR=$(grep -w $1 $2 | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  FIRST=${VAR[0]:0:1}
  if [[ "$FIRST" != "#" ]]; then
    echo ${VAR[1]}
  fi
}
