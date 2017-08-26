#!/bin/bash

if [[ -f remote_state.tf ]]; then
  rm remote_state.tf
fi

environment=${1:-garbage}
if [[ "${environment}" == "test" ]]; then
  state_identifier="ausmith-me-state-test"
elif [[ "${environment}" == "prod" ]]; then
  state_identifier="ausmith-me-state-prod"
else
  echo "only accepting 'test' or 'prod' as params"
  echo "bailing"
  exit 1
fi

# This is not terribly clean, but ensures we never replace the template file
cat remote_state.tf.tmpl | \
  sed -e "s/{{STATE_IDENTIFIER}}/${state_identifier}/" \
      -e "s/{{ENV_NAME}}/${environment}/" \
  > remote_state.tf
