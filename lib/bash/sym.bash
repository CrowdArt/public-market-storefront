#!/usr/bin/env bash
#
# (C) Simbi, Inc
#
# Wrapper functions around sym functions
#

sym::init() {
  export key_args="-ck bookstore.key"
  sym::ensure_version
}

sym::key() {
  sym::init
  sym ${key_args}
}

sym::ensure_version() {
  [[ -z "$(sym -h 2>&1 | grep -- '-c, --cache-password')" ]] && {
    printf "detected a (possibly) older version of %b$(sym -V)%b... upgrading...\n" "${bldgrn}" "${txtrst}"
    echo y | gem uninstall sym -a  2>/dev/null
    gem install sym > /dev/null
  }
}

# usage:
#   sym::decrypt <encrypted-file> <decrypted-file>
# note:
#   removes decrypted file before attempting encryption
sym::decrypt() {
  from=$1
  to=$2

  temp="/tmp/sym-${RANDOM}$(date +'%Y%m%d')"
  rm -f "${temp}" 2>/dev/null

  sym::init

  sym -d ${key_args} -f "${from}" -o "${temp}"
  result=$?

  if [[ $result -ne 0 ]]; then
    rm -f "${temp}" 2>/dev/null
    printf "%bdecryption error, exit code %s, aborting..." "${txtred}" "${result}"
    exit $result
  fi

  mv "${temp}" "${to}"
}

sym::init
