#!/bin/sh

# Define the profiles directory
PROFILES_DIR="."

# Update dependencies
#pip install 'elementary-data[bigquery]'
#edr --help

#dbt deps --profiles-dir "$PROFILES_DIR"

dbt deps --target prod --profiles-dir "$PROFILES_DIR"
#dbt run --select elementary --target prod --profiles-dir "$PROFILES_DIR"

# Debug and run tasks for different targets
#dbt debug --target dev --profiles-dir "$PROFILES_DIR"
#dbt debug --target prod --profiles-dir "$PROFILES_DIR"

dbt run --target prod --profiles-dir "$PROFILES_DIR"

#elementary
dbt test --target prod --profiles-dir "$PROFILES_DIR"
#edr report --env prod
#edr send-report --google-service-account-path credentials/reporting.json --gcs-bucket-name elementary_pro --env prod

dbt docs generate --target prod --profiles-dir "$PROFILES_DIR"
dbt docs serve --port 8001 --target prod --profiles-dir "$PROFILES_DIR"

# Test data for the default target
#dbt test --data --target dev --profiles-dir "$PROFILES_DIR"

