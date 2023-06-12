#!/bin/sh

REGION="us-east-1"

# v1
APIS1=$(aws apigateway get-rest-apis | jq -r '.items[].id' | tr '\n' ' ')
for A in $APIS1; do
  STAGES=$(aws apigateway get-stages --rest-api-id $A | jq -r '.item[].stageName'| tr '\n' ' ')
  for S in $STAGES; do
    PATHS=$(aws apigateway get-resources --rest-api-id $A | jq -r '.items[].path' | tr '\n' ' ')
    # if STAGE is not null
    for P in $PATHS; do
      if [ ! -z "$STAGES" ]; then
        URLS+="https://${A}.execute-api.${REGION}.amazonaws.com/${S}${P}\n"
      else
        URLS+="https://${A}.execute-api.${REGION}.amazonaws.com${P}\n"
      fi
    done
  done
done

# v2
APIS2=$(aws apigatewayv2 get-apis | jq -r '.Items[].ApiId' | tr '\n' ' ')
for A in $APIS2; do
  STAGES=$(aws apigatewayv2 get-stages --api-id $A | jq -r '.Items[].StageName'| tr '\n' ' ')
  for S in $STAGES; do
    PATHS=$(aws apigatewayv2 get-routes --api-id $A | jq -r '.Items[].RouteKey' | cut -d' ' -f2 | tr '\n' ' ')
    for P in $PATHS; do
      if [ ! -z "$STAGES" ]; then
        URLS+="https://${A}.execute-api.${REGION}.amazonaws.com/${S}${P}\n"
      else
        URLS+="https://${A}.execute-api.${REGION}.amazonaws.com${P}\n"
      fi
    done
  done
done

echo -e "$URLS"
