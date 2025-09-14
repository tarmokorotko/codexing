#!/bin/bash

# Configuration constants
WEB_SERVER="https://example.com"
TIMEOUT=5
INTERVAL=60            # seconds between checks
TOTAL_REQUESTS=10      # number of iterations
COUNTER=0
CONSTANT_PARAMETER_ID=1
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="your_db"
DB_USER="your_user"
DB_PASS="your_password"
TABLE_NAME="connectivity"

send_request() {
    START_TIME=$SECONDS
    TIMESTAMP=$(date "+%s")

    if curl -Is "$WEB_SERVER" --max-time "$TIMEOUT" >/dev/null 2>&1; then
        DATA_1=1
    else
        DATA_1=0
    fi

    PSQL_CMD="INSERT INTO $TABLE_NAME (timestamp, parameter_id, data_1) VALUES ('$TIMESTAMP', '$CONSTANT_PARAMETER_ID', '$DATA_1');"
    PGPASSWORD=$DB_PASS psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -p "$DB_PORT" -c "$PSQL_CMD"

    END_TIME=$SECONDS
    ELAPSED_TIME=$((END_TIME - START_TIME))
    SLEEP_TIME=$((INTERVAL - ELAPSED_TIME))
    if [ "$SLEEP_TIME" -gt 0 ]; then
        sleep "$SLEEP_TIME"
    fi
}

while [ "$COUNTER" -lt "$TOTAL_REQUESTS" ]; do
    send_request
    COUNTER=$((COUNTER + 1))
done

echo "Completed $TOTAL_REQUESTS requests."
