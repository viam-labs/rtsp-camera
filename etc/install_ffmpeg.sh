
clone_ffmpeg() {
  if [ -d FFmpeg ]; then
    echo "FFmpeg already cloned"
  fi
  echo "Cloning ffmpeg"
  git clone https://github.com/FFmpeg/FFmpeg -b n6.1.1 --depth 1
}

TOOLCHAIN=${NDK_ROOT}/toolchains/llvm/prebuilt/${HOST_OS}-x86_64
CC=${TOOLCHAIN}/bin/${CC_ARCH}-linux-android${API_LEVEL}-clang
CXX=${TOOLCHAIN}/bin/${CC_ARCH}-linux-android${API_LEVEL}-clang++
AR=${TOOLCHAIN}/bin/llvm-ar
LD=${CC}
RANLIB=${TOOLCHAIN}/bin/llvm-ranlib
STRIP=${TOOLCHAIN}/bin/llvm-strip
NM=${TOOLCHAIN}/bin/llvm-nm
SYSROOT=${TOOLCHAIN}/sysroot

if [ "$GOOS" = "android" ]; then
  clone_ffmpeg
  cd FFmpeg
  echo "Configuring ffmpeg"
  ./configure \
    --prefix=$FFMPEG_PREFIX \
    --target-os=android \
    --arch=aarch64 \
    --cpu=armv8-a \
    --cc=$CC \
    --cxx=$CXX \
    --ar=$AR \
    --ld=$CC \
    --ranlib=$RANLIB \
    --strip=$STRIP \
    --nm=$NM \
    --disable-static \
    --enable-shared \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-symver \
    --enable-small \
    --enable-cross-compile \
    --sysroot=$SYSROOT
    echo "Installing to $FFMPEG_PREFIX"
    make -j$(nproc)
    make install

elif [ "$GOOS" = "linux" ]; then
  # install ffmpeg
  clone_ffmpeg
  cd FFmpeg
  echo "Configuring ffmpeg"
  ./configure \
    --prefix=$FFMPEG_PREFIX \
    --disable-static \
    --enable-shared \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-symver \
    --enable-small
    make -j$(nproc)
    echo "Installing to $FFMPEG_PREFIX"
    make install
fi 