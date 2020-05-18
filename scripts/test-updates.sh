#!/bin/bash

source ./libjfxbash

URL="https://aus.thunderbird.net/update/6/Thunderbird/@@VERSION@@/default/@@PLATFORM@@/en-US/beta-localtest/default/ISET:SSE4_2,MEM:4096/default/default/update.xml"

get_url() {
  local _version
  local _platform
  local _args
  local _url

  _version="$1"
  shift
  _platform="$1"
  shift

  if [[ -n "$1" ]]; then
    _args="?${1}=1"
  fi
  shift
  if [[ -n "$1" ]]; then
    _args="${_args}&${1}=1"
  fi

  _url=${URL//@@VERSION@@/$_version}
  _url=${_url//@@PLATFORM@@/$_platform}
  # _url=$(echo "$URL" | sed -e "s/@@VERSION@@/$1/")
  _url="${_url}${_args}"
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
  curl -s -L -S "$_url" | tee /tmp/grab | xmllint --xpath "//updates/update[@appVersion='${_version}']/patch[@type='complete']" -
  #cat /tmp/grab
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
  ["73.0 WINNT_x86-msvc"]="77.0"
  ["73.0 WINNT_x86-msvc force"]="77.0"
#  ["74.0 Darwin_x86-gcc3"]="76.0"
#  ["74.0 Darwin_x86-gcc3 force"]="76.0"
#  ["74.0 Darwin_x86-gcc3-u-i386-x86_64"]="76.0"
#  ["74.0 Darwin_x86-gcc3-u-i386-x86_64 force"]="76.0"
#  ["74.0 Darwin_x86_64-gcc3"]="76.0"
#  ["74.0 Darwin_x86_64-gcc3 force"]="76.0"
#  ["74.0 Darwin_x86_64-gcc3-u-i386-x86_64"]="76.0"
#  ["74.0 Darwin_x86_64-gcc3-u-i386-x86_64 force"]="76.0"
#  ["76.0 Darwin_x86-gcc3"]=""
#  ["76.0 Darwin_x86-gcc3 force"]=""
#  ["76.0 Darwin_x86-gcc3-u-i386-x86_64"]=""
#  ["76.0 Darwin_x86-gcc3-u-i386-x86_64 force"]=""
#  ["76.0 Darwin_x86_64-gcc3"]=""
#  ["76.0 Darwin_x86_64-gcc3 force"]=""
#  ["76.0 Darwin_x86_64-gcc3-u-i386-x86_64"]=""
#  ["76.0 Darwin_x86_64-gcc3-u-i386-x86_64 force"]=""
  ["74.0 Linux_x86_64-gcc3"]="77.0"
  ["76.0 Linux_x86_64-gcc3"]="77.0"
)

for v in "${!TESTS[@]}"; do
  echo "$v"
  run_test "$v" "${TESTS[$v]}"
done

#for i in {1..20}; do
#  echo "Run # $i"
#  run_test "76.0a1" ""
#done
