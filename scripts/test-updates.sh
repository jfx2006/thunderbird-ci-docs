#!/bin/bash

source ./libjfxbash

URL="https://aus5.mozilla.org/update/6/Thunderbird/@@VERSION@@/default/Linux_x86_64-gcc3/en-US/release/default/ISET:SSE4_2,MEM:32059/default/default/update.xml"

get_url() {
  local _force
  local _url
  if [[ "$2" = "force" ]]; then
    _force="?force=1"
  fi
  _url=${URL//@@VERSION@@/$1}
  # _url=$(echo "$URL" | sed -e "s/@@VERSION@@/$1/")
  _url="${_url}${_force}"
  echo "${_url}"
}

run_test() {
  local _url
  local _version
  local _rv

  echo "Checking $1 update to $2"...

  _url=$(get_url $1)
  _version="$2"
  if [[ -n "$_version" ]]; then
    _version="$2"
    _rv=0
  else
    _version="xx"
    _rv=10
  fi

  echo "${_url} ${_rv}"
  curl -s -S "$_url" | xmllint --xpath "//updates/update[@appVersion='${_version}']/patch[@type='complete']" -
  # xmllint --xpath "//updates/update[@appVersion='$2']/patch[@type='complete']" test.txt
  if [[ $? -eq ${_rv} ]]; then
    print_GREEN PASS
  else
    print_RED FAIL
  fi
  echo ""
}


declare -A TESTS

TESTS=(
  ["52.7"]="60.9.0"
  ["60.5.1 force"]="60.9.0"
  ["60.4"]="60.9.0"
  ["60.9"]=""
  ["60.9 force"]="68.1.0"
  ["68.0"]="68.1.0"
  ["68.0 force"]="68.1.0"
)

for v in "${!TESTS[@]}"; do
  run_test "$v" "${TESTS[$v]}"
done
