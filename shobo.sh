#!/bin/bash

BITWARDEN_ITEM_NAME="Work SSO"
BITWARDEN_CLI="bw"

get_session_token() {
  echo "${BITWARDEN_CLI}" get username \""${BITWARDEN_ITEM_NAME}"\"
  user=$("${BITWARDEN_CLI}" get username "${BITWARDEN_ITEM_NAME}"| tr -d '\n')
  pass=$("${BITWARDEN_CLI}" get password "${BITWARDEN_ITEM_NAME}" | tr -d '\n')
  totp=$("${BITWARDEN_CLI}" get totp "${BITWARDEN_ITEM_NAME}" | tr -d '\n')
  echo "User: ${user}"
  echo "Pass: ${pass}"
  echo "Totp: ${totp}"
  eval "$(printf '%s\n%s\n%s\n' "$user" "$pass" "$totp" | shobo-aws-sts-cli -role-to-switch arn:aws:iam::144662694367:role/saascore-stg-ops --script)"
}

get_session_token
