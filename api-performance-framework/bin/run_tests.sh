#!/bin/bash

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
JMETER_HOME="${JMETER_HOME:-/usr/local/bin}"
TEST_PLAN="$ROOT_DIR/test-plans/User_API_Test.jmx"
PROPERTIES_FILE="$ROOT_DIR/config/env-test.properties"
RESULT_DIR="$ROOT_DIR/results/raw-data"
REPORT_DIR="$ROOT_DIR/results/html-reports"

mkdir -p "$RESULT_DIR" "$REPORT_DIR"

if [ -z "$JMETER_BIN" ]; then
  if [ -x "$JMETER_HOME/bin/jmeter" ]; then
    JMETER_BIN="$JMETER_HOME/bin/jmeter"
  elif command -v jmeter >/dev/null 2>&1; then
    JMETER_BIN="$(command -v jmeter)"
  else
    echo "JMeter is not installed or JMETER_HOME is not set."
    echo "Set JMETER_HOME or add jmeter to PATH."
    exit 1
  fi
fi

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
OUTPUT_JTL="$RESULT_DIR/results_${TIMESTAMP}.jtl"
REPORT_HTML="$REPORT_DIR/report_${TIMESTAMP}.html"

"$JMETER_BIN" \
  -n \
  -t "$TEST_PLAN" \
  -p "$PROPERTIES_FILE" \
  -l "$OUTPUT_JTL" \
  -e \
  -o "$REPORT_DIR/report_${TIMESTAMP}"

echo "Test run complete."
echo "JTL: $OUTPUT_JTL"
echo "HTML Report: $REPORT_HTML"
