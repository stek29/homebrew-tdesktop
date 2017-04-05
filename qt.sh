#!/usr/bin/env bash
echo "$1" "$PWD"
touch hang
while [ -e 'hang' ]; do sleep 1; done

curl 'https://raw.githubusercontent.com/telegramdesktop/tdesktop/dev/Telegram/Patches/qtbase_5_6_2.diff' -o qtbase_patch.diff

git clone "https://code.qt.io/qt/qt5.git" "qt5_6_2"
cd "qt5_6_2"
git checkout 5.6
perl init-repository --module-subset=qtbase,qtimageformats
git checkout v5.6.2
cd qtimageformats && git checkout v5.6.2 && cd ..
cd qtbase && git checkout v5.6.2 && cd ..

cd qtbase
git apply "../../qtbase_patch.diff"

for f in /usr/local/opt/*-td; do
  LDFLAGS="-L$f/lib $LDFLAGS"
  CPPFLAGS="-I$f/include $CPPFLAGS"
  PKG_CONFIG_PATH="$f/lib/pkgconfig $PKG_CONFIG_PATH"
done
export LDFLAGS="-stdlib=libc++ $LDFLAGS"
export CPPFLAGS
export PKG_CONFIG_PATH

./configure \
  -prefix "$1" \
  -debug-and-release \
  -force-debug-info \
  -opensource -confirm-license \
  -static \
  -opengl \
  desktop \
  -no-openssl \
  -securetransport \
  -nomake examples \
  -nomake tests  \
  -platform macx-clang

make -j4
make install
