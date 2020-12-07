#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./root-source/graf2d/asimage/src/libAfterImage
set -e

mv root-source/graf2d/asimage/src/libAfterImage/{,.??}* .
rm -r root-source

if [ "$(uname)" == "Linux" ]; then
    configure_args="--x-includes=\"${PREFIX}/include\" --x-libraries=\"${PREFIX}/lib\""
else
    configure_args="--without-x"
    sed -i.bak 's@soname@install_name@g' Makefile.in
    rm Makefile.in.bak
fi

autoconf

./configure \
    --prefix="${PREFIX}" \
    --libdir="${PREFIX}/lib" \
    --mandir="${PREFIX}/share/man" \
    --enable-sharedlibs \
    --disable-staticlibs \
    --with-jpeg-includes="${PREFIX}/include" \
    --with-png-includes="${PREFIX}/include" \
    --with-tiff-includes="${PREFIX}/include" \
    --with-builtin-ungif \
    --disable-glx \
    --with-afterbase=no \
    ${configure_args}

# don't run ldconfig
sed -i -e 's/`uname`/"hack"/g' Makefile

make AR="${AR} clq"
make AR="${AR} clq" install
