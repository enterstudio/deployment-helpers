ENVIRONMENT=$(echo "$DEPLOYMENT_GROUP_NAME" | tr '[:upper:]' '[:lower:]')
echo "counters.${APPLICATION_NAME}.${ENVIRONMENT}.inf.deployment:1|c"
echo "counters.${APPLICATION_NAME}.${ENVIRONMENT}.inf.deployment:1|c" | nc -u -w0 127.0.0.1 8125