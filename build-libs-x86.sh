#! /usr/bin/env bash
# Note this script requires an environment variable called ANDROID_NDK_HOME, mine is /Users/guysherman/Library/Android/ndk-bundle
export TOOLCHAIN=$TOP/../../toolchains/x86-android/bin
export SYSROOT=$TOOLCHAIN/../sysroot
export CONFIGURE_HOST="i386-linux-gnu"
export CROSS_PREFIX="i686-linux-android-"


export HOSTCFLAGS=" -fpic -ffunction-sections -funwind-tables -Wno-psabi  -Os -fomit-frame-pointer -fno-strict-aliasing -finline-limit=64 -DANDROID -Wa,--noexecstack -g -DUSE_ICONV_LOCALE_CHARSET"
#HOSTLDFLAGS="-Wl, -Wl,--no-undefined -Wl,-z,noexecstack"
export HOSTLDFLAGS=""
export FIXSHARED="--enable-static --disable-shared ac_cv_host=$CONFIGURE_HOST"
export FIXSHARED2="--enable-static ac_cv_host=$CONFIGURE_HOST"
export TOP="`pwd`"
export GLIB_BIN=/usr/local/Cellar/glib/2.46.2/bin

export PKG_CONFIG_LIBDIR=$SYSROOT/usr/lib/pkgconfig
export PKG_CONFIG_PATH=$SYSROOT/usr/lib/pkgconfig
#export PKG_CONFIG_SYSROOT_DIR=$SYSROOT
export INSTALLDIR=$TOOLCHAIN/../sysroot/usr
export PATH=$GLIB_BIN:$TOP/helper:$SYSROOT/usr/bin:$TOOLCHAIN:$ANDROID_NDK_HOME:$PATH
export CC="${CROSS_PREFIX}gcc $HOSTCFLAGS"
export CXX="${CROSS_PREFIX}g++ $HOSTCFLAGS -DFOOFOOFOO"
export LD="${CROSS_PREFIX}ld"
export STRIP="${CROSS_PREFIX}strip"
export RANLIB="${CROSS_PREFIX}ranlib"
export AR="${CROSS_PREFIX}ar"
export CHOST="i686-linux-android"

./build-libs.sh "$@"
