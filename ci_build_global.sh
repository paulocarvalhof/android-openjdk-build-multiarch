#!/bin/bash
set -e
. setdevkitpath.sh

export JDK_DEBUG_LEVEL=release

if [[ "$BUILD_IOS" != "1" ]]; then
  wget -nc -nv -O android-ndk-$NDK_VERSION-linux-x86_64.zip "https://dl.google.com/android/repository/android-ndk-$NDK_VERSION-linux-x86_64.zip"
  ./extractndk.sh
  ./maketoolchain.sh
else
  chmod +x ios-arm64-clang
  chmod +x ios-arm64-clang++
  chmod +x macos-host-cc
fi

# Some modifies to NDK to fix

./getlibs.sh
./buildlibs.sh
./clonejdk.sh
sed -i 's/as_fn_error \$? "GCC < 5 may incorrectly.*/:/' openjdk/common/autoconf/generated-configure.sh && grep -c "GCC < 5 may" openjdk/common/autoconf/generated-configure.sh || true
./removejdkdebuginfo.sh
./tarjdk.sh
