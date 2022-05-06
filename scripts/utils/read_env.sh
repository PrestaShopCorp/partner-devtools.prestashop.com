#!/bin/bash

# allow to read file and use is content
readEnv() {
  VAR=$(grep -w $1 $2 | xargs)
  IFS="=" read -ra VAR <<< "$VAR"
  echo ${VAR[1]}
}
