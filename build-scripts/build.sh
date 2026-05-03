#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$(basename "$0")"

printHelp() {
  echo "Usage:"
  echo "$SCRIPT_NAME \\"
  echo "  --unity <UNITY_PATH> \\"
  echo "  --project <PROJECT_PATH> \\"
  echo "  --output <OUTPUT_DIR> \\"
  echo "  --log-file <PATH>"
  echo ""
  echo "You can also set environment variables instead:"
  echo "  UNITY_PATH, PROJECT_PATH, OUTPUT_DIR, LOG_FILE"
}

printVariables() {
  echo "=== Unity Build ==="
  echo "Script:       $SCRIPT_NAME"
  echo "Unity:        $UNITY_PATH"
  echo "Project:      $PROJECT_PATH"
  echo "Output Dir:   $OUTPUT_DIR"
  echo "Android Version Code: $ANDROID_VERSION_CODE"
  echo "Android Version Name: $ANDROID_VERSION_NAME"
  echo "Version:      $VERSION"
  echo "Commit Hash:  $COMMIT_HASH"
  echo "Build ID: $BUILD_ID"
  echo "Log File:     $LOG_FILE"
  echo "==================="
}

runUnityBuild() {
  local unity_args=(
    -batchmode
    -nographics
    -projectPath "$PROJECT_PATH"
    -executeMethod Editor.BuildScript.PerformBuild
    -logFile "$LOG_FILE"
    -quit
  )
    
  local ci_args=(
    -ciBuildOutput "$OUTPUT_DIR"
    -ciVersion "$VERSION"
    -ciCommitHash "$COMMIT_HASH"
    -ciBuildId "$BUILD_ID"
    -ciAndroidVersionCode "$ANDROID_VERSION_CODE"
    -ciAndroidVersionName "$ANDROID_VERSION_NAME"
  )
      
  "$UNITY_PATH" "${unity_args[@]}" "${ci_args[@]}"
}

main() {
  echo "Setting defaults..."
  LOG_FILE="${LOG_FILE:--}"
  VERSION="${VERSION:-1.0.0}"
  COMMIT_HASH="${COMMIT_HASH:-local}"
  BUILD_ID="${CI_RUN_NUMBER:-$(date -u +%Y%m%d%H%M%S)}"
  ANDROID_VERSION_CODE="${BUILD_ID}"
  ANDROID_VERSION_NAME="1.0.${BUILD_ID}"
  
  UNITY_PATH="${UNITY_PATH:-}"
  PROJECT_PATH="${PROJECT_PATH:-}"
  OUTPUT_DIR="${OUTPUT_DIR:-}" 
  
  echo "Parsing flags..."
  # flags override environment variables
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --unity)        UNITY_PATH="$2"; shift 2 ;;
      --project)      PROJECT_PATH="$2"; shift 2 ;;
      --output)       OUTPUT_DIR="$2"; shift 2 ;;
      --log-file)      LOG_FILE="$2"; shift 2 ;;
      *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
  done
  
  if [[ -z "$UNITY_PATH" || -z "$PROJECT_PATH" || -z "$OUTPUT_DIR" ]]; then
    echo "Error: required variables missing"
    printHelp
    exit 1
  fi

  printVariables
  runUnityBuild
  
  echo "=== Build finished ==="
}

main "$@"
