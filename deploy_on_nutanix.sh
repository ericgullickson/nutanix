#!/usr/bin/env bash
# scripts/deploy_on_ nutanix.sh
set -eux

GITHUB_HASH=$1


json_payload=$(cat <<EOF
{
              "spec": {
                  "app_name": "NCM API App Commit-$GITHUB_HASH",
                  "app_description": "NCM application launched via Nutanix REST API",
                  "app_profile_reference": {
                      "kind": "app_profile",
                      "name": "Default",
                      "uuid": "61d0573d-9106-57d3-d210-220befe306b6"
                  },
                  "runtime_editables": {
                      "variable_list": [
                          {
                              "description": "",
                              "uuid": "b486cacd-2ba1-0cc6-05db-0ebef1d87074",
                              "value": {
                                  "value": "$GITHUB_HASH"
                              },
                              "context": "app_profile.Default.variable",
                              "type": "LOCAL",
                              "name": "github_hash"
                          }
                      ]
                  }
              }
          }
EOF
)



curl --request POST \
--url https://172.30.1.72:9440/api/nutanix/v3/blueprints/0d2e27d9-3a0d-9cf8-2901-c3d0d1aca323/simple_launch \
--header 'Accept: application/json' \
--header 'Authorization: Basic YWRtaW46ZWVOZ2FoNm1hZWc5b3V0ZWluZzlvb2ppMSE=' \
--header 'Content-Type: application/json' \
--insecure \
--data "$json_payload"