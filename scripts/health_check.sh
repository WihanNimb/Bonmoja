#!/bin/bash

# File: scripts/health_check.sh

URL="http://localhost:5678"
LOG_FILE="scripts/health_check.log"

echo "[$(date)] Checking service at $URL..." | tee -a "$LOG_FILE"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "[$(date)] ✅ Service is healthy (HTTP 200)" | tee -a "$LOG_FILE"
else
    echo "[$(date)] ⚠️ WARNING: Service unhealthy (HTTP $HTTP_STATUS)" | tee -a "$LOG_FILE"
fi
