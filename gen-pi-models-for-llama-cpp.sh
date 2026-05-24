#!/usr/bin/env bash
# Generate pi custom models JSON from a local API /models endpoint.
# Usage: ./gen_models.sh [baseURL]
#   baseURL defaults to http://localhost:18000/v1
set -euo pipefail

BASE_URL="${1:-http://localhost:18000/v1}"

curl -sS "${BASE_URL}/models" | jq --arg url "$BASE_URL" '
  if .data then {
    providers: {
      llamacpp: {
        baseUrl: $url,
        api: "openai-completions",
        apiKey: "llamacpp",
        compat: {
          "supportsDeveloperRole": false,
          "supportsReasoningEffort": false,
          "supportsUsageInStreaming": false
        },
        models: [
          .data[].id | select(. != "default") | { id: . }
        ]
      }
    }
  } else
    error("Expected .data in response")
  end
'
