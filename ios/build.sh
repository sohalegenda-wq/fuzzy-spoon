#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/build/ios"
APP="$OUT/Payload/FunnyWorld.app"
SDK_PATH="$(xcrun --sdk iphoneos --show-sdk-path)"
mkdir -p "$APP/assets"
xcrun --sdk iphoneos clang -arch arm64 -isysroot "$SDK_PATH" \
  -miphoneos-version-min=15.0 -fobjc-arc -O2 \
  -framework UIKit -framework WebKit -framework Foundation \
  "$ROOT/ios/main.m" -o "$APP/FunnyWorld"
cp "$ROOT/ios/Info.plist" "$APP/Info.plist"
cp "$ROOT/game/assets/index.html" "$ROOT/game/assets/title.jpg" "$APP/assets/"
plutil -convert binary1 "$APP/Info.plist"
printf 'APPL????' > "$APP/PkgInfo"
# An ad-hoc linker signature is not an Apple provisioning signature.
if codesign -dv "$APP/FunnyWorld" >/dev/null 2>&1; then
  codesign --remove-signature "$APP/FunnyWorld"
fi
file "$APP/FunnyWorld"
xcrun vtool -show-build "$APP/FunnyWorld"
plutil -lint "$APP/Info.plist"
mkdir -p "$ROOT/downloads"
cd "$OUT"
zip -q -r "$ROOT/downloads/FunnyWorld-0.1-unsigned.ipa" Payload
cd "$ROOT/downloads"
shasum -a 256 FunnyWorld-0.1-unsigned.ipa > FunnyWorld-0.1-unsigned.ipa.sha256
unzip -t FunnyWorld-0.1-unsigned.ipa
