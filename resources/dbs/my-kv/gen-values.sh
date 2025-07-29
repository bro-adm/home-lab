#!/bin/bash
set -e

# Required inputs
VALUES_FILE="$1"

if [[ -z "$VALUES_FILE" ]]; then
  echo "❌ Error: path to values.yaml is required as first argument"
  exit 1
fi

# Read from environment or fall back to defaults
NAME_OVERRIDE="${NAME_OVERRIDE:-my-app}"
REPLICA_COUNT="${REPLICA_COUNT:-1}"

# Ensure yq is available
if ! command -v yq &> /dev/null; then
  echo "⚙️ Installing yq..."
  curl -sSL https://github.com/mikefarah/yq/releases/download/v4.15.1/yq_linux_amd64 -o /usr/local/bin/yq
  chmod +x /usr/local/bin/yq
fi

# Apply updates using yq
echo "🔧 Updating $VALUES_FILE..."
yq e ".nameOverride = \"$NAME_OVERRIDE\"" -i "$VALUES_FILE"
yq e ".replicaCount = $REPLICA_COUNT" -i "$VALUES_FILE"

echo "✅ values.yaml updated."

