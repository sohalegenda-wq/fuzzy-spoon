#!/usr/bin/env bash
set -euo pipefail
# Usage: SDK=/path/to/android-sdk ECJ=/path/to/ecj.jar ./build.sh
: "${SDK:?Set SDK to Android SDK directory}"
: "${ECJ:?Set ECJ to Eclipse Java compiler jar}"
BT="${BUILD_TOOLS:-$SDK/build-tools/35.0.0}"
ANDROID="$SDK/platforms/android-35/android.jar"
mkdir -p classes
java -jar "$ECJ" -source 1.8 -target 1.8 -classpath "$ANDROID" -d classes src/com/funnyworld/game/MainActivity.java
"$BT/aapt" package -f -M AndroidManifest.xml -S res -A assets -I "$ANDROID" -F base.apk
"$BT/d8" --lib "$ANDROID" --output . classes/com/funnyworld/game/MainActivity.class
cp base.apk unsigned.apk
zip -j unsigned.apk classes.dex
"$BT/zipalign" -f 4 unsigned.apk aligned.apk
if [ ! -f release.jks ]; then
 keytool -genkeypair -keystore release.jks -storepass funnyworld-local -keypass funnyworld-local -alias funnyworld -keyalg RSA -keysize 2048 -validity 10000 -dname 'CN=Funny World Local, O=Independent Game, C=KZ' -noprompt
fi
"$BT/apksigner" sign --ks release.jks --ks-pass pass:funnyworld-local --key-pass pass:funnyworld-local --out FunnyWorld-0.1.apk aligned.apk
"$BT/apksigner" verify --verbose FunnyWorld-0.1.apk
