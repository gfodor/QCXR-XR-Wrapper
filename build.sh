#!/usr/bin/env bash
# Builds Pojlib and the QCXR Unity project into an Android APK.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POJLIB_DIR="${SCRIPT_DIR}/../Pojlib"
ANDROID_PLUGIN_DIR="${SCRIPT_DIR}/Assets/Plugins/Android"
BUILD_OUTPUT="${SCRIPT_DIR}/Builds/Android/QCXR.apk"
BUILD_LOG_DIR="${SCRIPT_DIR}/BuildLogs"
UNITY_PROJECT_PATH="${SCRIPT_DIR}"
UNITY_EXECUTABLE_DEFAULT="/Applications/Unity/Hub/Editor/2022.3.62f1/Unity.app/Contents/MacOS/Unity"
UNITY_EXECUTABLE="${UNITY_PATH:-$UNITY_EXECUTABLE_DEFAULT}"
UNITY_METHOD="CommandLineBuild.BuildAndroid"

if [[ ! -x "${UNITY_EXECUTABLE}" ]]; then
  echo "Unity executable not found at '${UNITY_EXECUTABLE}'. Set UNITY_PATH to your editor binary." >&2
  exit 1
fi

DEVELOPMENT_BUILD=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --development)
      DEVELOPMENT_BUILD=1
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

mkdir -p "${BUILD_LOG_DIR}"
mkdir -p "${ANDROID_PLUGIN_DIR}"

# Build Pojlib and copy the resulting AAR into the Unity Plugins folder.
pushd "${POJLIB_DIR}" >/dev/null
chmod +x gradlew
./gradlew clean assembleRelease
POJLIB_AAR="${POJLIB_DIR}/build/outputs/aar/Pojlib-release.aar"
if [[ ! -f "${POJLIB_AAR}" ]]; then
  echo "Failed to build Pojlib AAR at ${POJLIB_AAR}" >&2
  exit 1
fi
cp "${POJLIB_AAR}" "${ANDROID_PLUGIN_DIR}/Pojlib-release.aar"
popd >/dev/null

# Run the Unity build.
LOG_FILE="${BUILD_LOG_DIR}/build-$(date +%Y%m%d-%H%M%S).log"
UNITY_ARGS=(
  -batchmode
  -nographics
  -quit
  -projectPath "${UNITY_PROJECT_PATH}"
  -executeMethod "${UNITY_METHOD}"
  -buildTarget Android
  -buildPath "${BUILD_OUTPUT}"
  -logFile "${LOG_FILE}"
)
if [[ ${DEVELOPMENT_BUILD} -eq 1 ]]; then
  UNITY_ARGS+=( -development true )
fi

"${UNITY_EXECUTABLE}" "${UNITY_ARGS[@]}"

echo "Build complete."
echo " APK: ${BUILD_OUTPUT}"
echo " Log: ${LOG_FILE}"
