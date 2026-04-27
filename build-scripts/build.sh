#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

# ---- Defaults ----
LOG_FILE="${LOG_FILE:--}"
VERSION_CODE="${VERSION_CODE:-}"
COMMIT_HASH="${COMMIT_HASH:-local}"
BUILD_NUMBER="${BUILD_NUMBER:-0}"

UNITY_PATH="${UNITY_PATH:-}"
PROJECT_PATH="${PROJECT_PATH:-}"
OUTPUT_DIR="${OUTPUT_DIR:-}"

# ---- Parse flags (override env) ----
while [[ $# -gt 0 ]]; do
  case "$1" in
    --unity)        UNITY_PATH="$2"; shift 2 ;;
    --project)      PROJECT_PATH="$2"; shift 2 ;;
    --output)       OUTPUT_DIR="$2"; shift 2 ;;
    --versionCode)  VERSION_CODE="$2"; shift 2 ;;
    --commitHash)   COMMIT_HASH="$2"; shift 2 ;;
    --buildNumber)  BUILD_NUMBER="$2"; shift 2 ;;
    --logFile)      LOG_FILE="$2"; shift 2 ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

# ---- Validate required ----
if [[ -z "$UNITY_PATH" || -z "$PROJECT_PATH" || -z "$OUTPUT_DIR" || -z "$VERSION_CODE" ]]; then
  echo "Usage:"
  echo "$SCRIPT_NAME \\"
  echo "  --unity <UNITY_PATH> \\"
  echo "  --project <PROJECT_PATH> \\"
  echo "  --output <OUTPUT_DIR> \\"
  echo "  --versionCode <INT> \\"
  echo "  [--commitHash <HASH>] \\"
  echo "  [--buildNumber <NUM>] \\"
  echo "  [--logFile <PATH|- >]"
  echo ""
  echo "You can also set environment variables instead:"
  echo "  UNITY_PATH, PROJECT_PATH, OUTPUT_DIR, VERSION_CODE, COMMIT_HASH, BUILD_NUMBER, LOG_FILE"
  exit 1
fi

# ---- Validate versionCode ----
if ! [[ "$VERSION_CODE" =~ ^[0-9]+$ ]] || [[ "$VERSION_CODE" -le 0 ]]; then
  echo "Error: --versionCode must be a positive integer"
  exit 1
fi

echo "=== Unity Build ==="
echo "Script:       $SCRIPT_NAME"
echo "Unity:        $UNITY_PATH"
echo "Project:      $PROJECT_PATH"
echo "Output Dir:   $OUTPUT_DIR"
echo "Version Code: $VERSION_CODE"
echo "Commit Hash:  $COMMIT_HASH"
echo "Build Number: $BUILD_NUMBER"
echo "Log File:     $LOG_FILE"
echo "==================="

"$UNITY_PATH" \
  -batchmode \
  -nographics \
  -projectPath "$PROJECT_PATH" \
  -buildOutput "$OUTPUT_DIR" \
  -versionCode "$VERSION_CODE" \
  -commitHash "$COMMIT_HASH" \
  -buildNumber "$BUILD_NUMBER" \
  -executeMethod Editor.BuildScript.PerformBuild \
  -logFile "$LOG_FILE" \
  -quit

echo "=== Build finished ==="