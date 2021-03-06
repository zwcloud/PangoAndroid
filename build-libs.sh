#! /usr/bin/env bash
# Note this script requires an environment variable called ANDROID_NDK_HOME, mine is /Users/guysherman/Library/Android/ndk-bundle

with_download=true
with_extract=true
with_iconv=true
with_ffi=true
with_zlib=true
with_xml2=true
with_png=true
with_gettext=true
with_glib=true
with_gi=true
with_atk=true
with_pixman=true
with_ft2=true
with_fc=true
with_cairo=true
with_harfbuzz=true
with_pango=true

pushd glob
make clean
make
popd

pushd cpufeatures
make clean
make
popd

while :; do
  case "$1" in
	--skip-download) with_download=false; shift;;
	--skip-extract) with_extract=false; shift;;
    --skip-iconv) with_iconv=false; shift;;
	--skip-ffi) with_ffi=false; shift;;
	--skip-gettext) with_gettext=false; shift;;
	--skip-glib) with_glib=false; shift;;
	--skip-gi) with_gi=false; shift;;
	--skip-atk) with_atk=false; shift;;
	--skip-xml2) with_xml2=false; shift;;
	--skip-pixman) with_pixman=false; shift;;
	--skip-ft2) with_ft2=false; shift;;
	--skip-zlib) with_zlib=false; shift;;
	--skip-png) with_png=false; shift;;
	--skip-fc) with_fc=false; shift;;
	--skip-cairo) with_cairo=false; shift;;
	--skip-pango) with_pango=false; shift;;
	--skip-harfbuzz) with_harfbuzz=false; shift;;
    *) break ;;
  esac
done

if $with_download; then
	mkdir downloads
	pushd downloads
	wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
	wget ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
	wget ftp://xmlsoft.org/libxml2/libxml2-2.9.3.tar.gz
	wget http://zlib.net/zlib-1.2.8.tar.gz
	wget http://downloads.sourceforge.net/project/libpng/libpng16/1.6.24/libpng-1.6.24.tar.xz
	wget http://ftp.gnu.org/pub/gnu/gettext/gettext-0.19.7.tar.xz
	wget http://ftp.gnome.org/pub/gnome/sources/glib/2.40/glib-2.40.0.tar.xz
	wget http://ftp.gnome.org/pub/gnome/sources/atk/2.20/atk-2.20.0.tar.xz
	wget https://www.cairographics.org/releases/pixman-0.34.0.tar.gz
	wget http://download.savannah.gnu.org/releases/freetype/freetype-2.6.3.tar.gz
	wget https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.1.tar.gz
	wget https://www.cairographics.org/releases/cairo-1.14.6.tar.xz
	wget https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.2.6.tar.bz2
	wget http://ftp.gnome.org/pub/GNOME/sources/pango/1.40/pango-1.40.1.tar.xz
	popd
fi

if $with_extract; then
	tar -xzf downloads/libiconv-1.14.tar.gz -C .
	tar -xzf downloads/libffi-3.2.1.tar.gz -C .
	tar -xzf downloads/libxml2-2.9.3.tar.gz -C .
	tar -xzf downloads/zlib-1.2.8.tar.gz -C .
	tar -xzf downloads/libpng-1.6.24.tar.xz -C .
	tar -xzf downloads/gettext-0.19.7.tar.xz -C .
	tar -xzf downloads/glib-2.40.0.tar.xz -C .
	tar -xzf downloads/atk-2.20.0.tar.xz -C .
	tar -xzf downloads/pixman-0.34.0.tar.gz -C .
	tar -xzf downloads/freetype-2.6.3.tar.gz -C .
	tar -xzf downloads/fontconfig-2.11.1.tar.gz -C .
	tar -xzf downloads/cairo-1.14.6.tar.xz -C .
	tar -xzf downloads/harfbuzz-1.2.6.tar.bz2 -C .
	tar -xzf downloads/pango-1.40.1.tar.xz -C .
fi

if $with_iconv; then
	pushd libiconv-1.14
	./autogen.sh --skip-gnulib
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR  CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX"  LDFLAGS="$HOSTLDFLAGS"
	make clean
	make
	make install
	popd
fi

if $with_ffi; then
	pushd libffi-3.2.1
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR  CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -I$TOP/libffi-extra/src" LDFLAGS="$HOSTLDFLAGS"
	make clean
	make
	make install
	popd
fi

if $with_zlib; then
	pushd zlib-1.2.8
	./configure --static --prefix=$INSTALLDIR
	make clean
	make
	make install
	popd
fi

if $with_xml2; then
	pushd libxml2-2.9.3
	./configure --host=$CONFIGURE_HOST $FIXSHARED --without-python --without-threads --enable-rebuild-docs=no --without-ftp --prefix=$INSTALLDIR CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX" LDFLAGS="$HOSTLDFLAGS -L$TOP/glob -lglob"
	make clean
	make
	make install
	popd
fi


# PNG
# Depends: zlib
# Note: remove libz.so from your toolchain, otherwise the compiler will try to link
# against the shitty old zlib 1.2.3 and it won't be happy

if $with_png; then
	pushd libpng-1.6.24
	make clean
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -Duint64_t=__uint64_t -static" LDFLAGS="$HOSTLDFLAGS -L$SYSROOT/usr/lib -static"
	make clean
	make
	make install
	popd
fi

# GETTEXT
# Depends: iconv

if $with_gettext; then
	pushd gettext-0.19.7
	./autogen.sh --skip-gnulib
	patch gettext-runtime/gnulib-lib/localcharset.c ../gettext-extra/gettext-runtime_gnulib-lib_localcharset.patch
	patch gettext-runtime/intl/localcharset.c ../gettext-extra/gettext-runtime_intl_localcharset.patch
	patch gettext-tools/gnulib-lib/localcharset.c ../gettext-extra/gettext-tools_gnulib-lib_localcharset.patch
	patch gettext-tools/libgettextpo/localcharset.c ../gettext-extra/gettext-tools_libgettextpo_localcharset.patch
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR --with-included-gettext --disable-java --disable-native-java --disable-threads --disable-libasprintf --without-emacs CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -DUSE_ICONV_LOCALE_CHARSET -Dpw_gecos=pw_name -I$TOP/gettext-extra" LDFLAGS="$HOSTLDFLAGS"  gl_cv_func_memchr_works=yes ac_cv_func_strnlen_working=yes
	make clean
	make
	make install
	popd
fi

# GLIB
# Depends: gettext, iconv, ffi

if $with_glib; then
	pushd glib-2.40.0
	NOCONFIGURE=1 ./autogen.sh
	patch gio/gnetworkmonitornetlink.c ../glib-extra/gnetworkmonitornetlink-droid.patch
	patch gio/gthreadedresolver.c ../glib-extra/gthreadedresolver-droid.patch
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR --enable-gc-friendly  CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -Dpw_gecos=pw_name -I$SYSROOT/usr/lib/libffi-3.2.1/include -I$TOP/glib-extra" LDFLAGS="$HOSTLDFLAGS -lintl -liconv -lgettextpo -lffi" glib_cv_stack_grows=no glib_cv_uscore=no glib_os_android=yes ac_cv_func_posix_getpwuid_r=no ac_cv_func_posix_getgrgid_r=no
	make clean
	make
	make install
	popd
fi

# if $with_gi; then
# 	pushd gobject-introspection-1.31.22
# 	./configure --host=$CONFIGURE_HOST $FIXSHARED2 --disable-tests --with-glib-src=../glib-2.40.0 CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -marm -I$TOOLCHAIN/../include" LDFLAGS="$HOSTLDFLAGS"
# 	make
# 	popd
# fi

# ATK
# Depends: ffi
if $with_atk; then
	pushd atk-2.20.0
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR --disable-glibtest CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -I$SYSROOT/usr/lib/libffi-3.2.1/include" LDFLAGS="$HOSTLDFLAGS -lffi" INTROSPECTION_SCANNER=g-ir-scanner LIBS="-lffi"
	make clean
	make
	make install
	popd
fi

# PIXMAN

if $with_pixman; then
	pushd pixman-0.34.0
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR CFLAGS="-DPIXMAN_NO_TLS -DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -I$TOP/pixman-extra -I$TOP/cpufeatures -include pixman-elf-fix.h" LDFLAGS="$HOSTLDFLAGS -L$TOP/cpufeatures -lcpu-features" --disable-arm-simd --disable-arm-neon
	make clean
	make
	make install
	popd
fi

# FREETYPE2
# Depends png, zlib

if $with_ft2; then
	pushd freetype-2.6.3
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -Duint64_t=__uint64_t" LDFLAGS="$HOSTLDFLAGS" --without-harfbuzz
	make clean
	make
	make install
	popd
fi

# FONTCONFIG
# Depends: freetype2

if $with_fc; then
	pushd fontconfig-2.11.1
	./configure --build=i686-pc-linux-gnu --host=$CONFIGURE_HOST $FIXSHARED --with-freetype-config=$INSTALLDIR/bin/freetype-config --enable-libxml2 --with-default-fonts=/system/fonts --prefix=$INSTALLDIR CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -I$TOP/fontconfig-extra/src" LDFLAGS="$HOSTLDFLAGS"
	make clean
	make
	make install
	popd
fi

# CAIRO
# Depends: pixman, freetype2, glib, fontconfig

if $with_cairo; then
	pushd cairo-1.14.6
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR --enable-ps=no --enable-pdf=no --enable-svg=no --enable-xlib=no FREETYPE_CONFIG=no CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -DCAIRO_NO_MUTEX -I$TOP/cairo-extra" LDFLAGS="$HOSTLDFLAGS -lffi" LIBS="-lm -lffi"
	make clean
	make
	make install
	popd
fi

if $with_harfbuzz; then
	pushd harfbuzz-1.2.6
	NOCONFIGURE=1 ./autogen.sh
	./configure --host=$CONFIGURE_HOST $FIXSHARED --prefix=$INSTALLDIR CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX" LD=$HOST-ld LDFLAGS="$HOSTLDFLAGS"
	make clean
	make
	make install
	popd
fi

if $with_pango; then
	pushd pango-1.40.1
	./configure --host=$CONFIGURE_HOST $FIXSHARED --without-x --with-included-modules=yes --prefix=$INSTALLDIR CFLAGS="-DWCHAR_MIN=INT_MIN -DWCHAR_MAX=INT_MAX -I$TOP/pango-extra" LD=$HOST-ld LDFLAGS="$HOSTLDFLAGS"
	make clean
	make
	make install
	popd
fi
