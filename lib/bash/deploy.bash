#!/usr/bin/env bash
#
# (c) 2016-2018 Simbi, Inc.
# Author(s): Nick Zhebrun, Konstantin Gredeskoul, Artem Kozaev
#

export deploy__script=$(find $(pwd) -name deploy.bash)
export app__root=${deploy__script%"/lib/bash/deploy.bash"}
export bash_path="${app__root}/lib/bash"

source "${bash_path}/sym.bash"

bookstore::log() {
  local message=$*
  printf "${message}\n"
}

deploy::secrets::decrypt() {
  encrypted_file=$1
  decrypted_file=$2

  bookstore::log "please enter your Bookstore Key Password, if asked..."
  encryption_key="$(sym::key)"

  # remove any previous files
  [[ -s "${decrypted_file}" ]] && rm -f "${decrypted_file}"

  sym::decrypt "${encrypted_file}" "${decrypted_file}"
  [[ -s "${decrypted_file}" ]] || {
    exit 1
  }
}

deploy::cleanup() {
  [[ -n "${settings_decrypted}" && -f "${settings_decrypted}" ]] && rm "${settings_decrypted}"
  exit
}

deploy::docker::build() {
  set -e

  docker_script="${app__root}/bin/${app_environment}"

  "${docker_script}" build

  "${docker_script}" run --rm app bash ./config/deploy/prepare_app

  "${docker_script}" up -d
}

deploy::docker::prune() {
  set +e
  bookstore::log 'pruning unused Docker images and containers'
  docker system prune --force
  set -e
}


deploy::main() {
  trap deploy::cleanup INT TERM EXIT

  local settings_encrypted="${app__root}/config/settings/secrets/${app_environment}.yml.enc"
  export settings_decrypted="${app__root}/config/settings/${app_environment}.yml"

  deploy::secrets::decrypt "${settings_encrypted}" "${settings_decrypted}"

  deploy::docker::build
  deploy::docker::prune
}
