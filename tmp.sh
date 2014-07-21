#!/bin/bash

SELF="${0}"
TMPDIR="${TMPDIR:-/tmp}"
VERSION="0.0.1"

## output usage
usage () {
  echo "usage: tmp [-hwV] [-d tmpdir] <command>"
}

## eval line
parse () {
  local tmp="${1}"
  local line
  ## read each line from input and
  ## evaluate it as bash script in
  while read -r line; do
    ## change directory context and run
    ## command redirecting stderr to an expression
    ## to capture errors and print nicely
    eval "cd "${tmp}" && ${line}" 2> >({
      local buf
      while read -r buf; do
        if [[ "$(echo ${buf} | awk '{print $1}')" =~ "${0}" ]]; then
          printf "tmp: error: "
          echo ${buf} | awk '{$1=$2=$3=""; print $0}' | sed 's/^ *//'
        fi
      done >&2
      return $?
    })
  done

  return $?
}

## main
main () {
  local TMP="${TMPDIR}"

  ## parse opt
  {
    if [ -t 0 ] && [ -z "${1}" ]; then
      usage >&2
      return 1
    fi

    case "${1}" in
      -h|--help)
        usage
        return 0
        ;;

      -w|--which)
        echo "${TMP}"
        return 0
        ;;

      -V|--version)
        echo "${VERSION}"
        return 0
        ;;

      -d|--dir)
        shift; TMP="${1}"; shift
        if [ -z "${TMP}" ]; then
          echo >&2 "error: Missing value for \`${1}'"
          usage >&2
          return 1
        fi

        ;;

      *)
        if [ "-" == "${1:0:1}" ]; then
          echo >&2 "error: Unknown option \`${1}'"
          usage >&2
          return 1
        fi
        ;;
    esac
  }

  ## replace `~' with `${HOME}'
  TMP="${TMP/\~/${HOME}}"

  {
    local file
    ## stdin is not terminal
    ## we must read from it
    if ! [ -t 0 ]; then
      while read -r buf; do
        echo "${buf}" | parse "${TMP}"
      done
    elif test -f "${1}"; then
      file="$(cd $(dirname ${1}); pwd)/$(basename ${1})"
      {
        cd "${TMP}" && source "${file}"
      }
      return $?
    else
      echo "${@}" | parse "${TMP}"
    fi
  }

  return $?
}

## run
main "${@}"
exit $?

