#!/bin/bash

while [[ $(curl http://localhost:8080/data/contact/website) != '"ausmith.me"' ]]; do
  echo "$(date): Webserver not responding yet, sleeping"
  sleep 1
done

if [[ $(curl http://localhost:8080/data/contact/website) == '"ausmith.me"' ]]; then
  export AWS_DEFAULT_REGION=us-east-1
  aws ec2 associate-address --allow-reassociation \
                            --public-ip "${eip}" \
                            --instance-id $(ec2metadata --instance-id)
fi
