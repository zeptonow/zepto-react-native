#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# build-android-aars.sh — build & publish the Zepto Android AARs locally.
#
# Emits the matched, CLASSIC-built pair consumed by zepto-customer-app, for all
# ABIs (armeabi-v7a, arm64-v8a, x86, x86_64):
#   com.facebook.react:react-android:<rnVersion>
#   com.facebook.hermes:hermes-android:<hermesVersion>
#
# Usage:
#   ./scripts/build-android-aars.sh [OUTPUT_DIR]
#
#   OUTPUT_DIR   where to write the local maven repo.
#                Default: /tmp/maven-local
#
# Examples:
#   ./scripts/build-android-aars.sh                # -> /tmp/maven-local
#   ./scripts/build-android-aars.sh ~/zepto-aars   # -> custom dir
#
# Classic Hermes + all ABIs are the repo defaults (gradle.properties), so this is
# just `publishAllToMavenTempLocal` with a user-chosen output directory.
# ---------------------------------------------------------------------------
set -euo pipefail

cd "$(dirname "$0")/.."   # repo root

OUTPUT_DIR="${1:-/tmp/maven-local}"
mkdir -p "$OUTPUT_DIR"
ABS_OUT="$(cd "$OUTPUT_DIR" && pwd)"

echo "=================================================================="
echo " Building Zepto Android AARs (classic Hermes, all ABIs)"
echo "   output : $ABS_OUT"
echo "=================================================================="

./gradlew publishAllToMavenTempLocal -PaarOutputRepo="file://$ABS_OUT"

echo ""
echo "=================================================================="
echo " Done. Published to $ABS_OUT :"
echo "   com/facebook/react/react-android/"
echo "   com/facebook/hermes/hermes-android/"
echo "=================================================================="
