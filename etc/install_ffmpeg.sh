
clone_ffmpeg() {
  if [ -d FFmpeg ]; then
    echo "FFmpeg already cloned"
    return
  fi
  echo "Cloning ffmpeg"
  git clone https://github.com/FFmpeg/FFmpeg -b n6.1.1 --depth 1
}

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
    --enable-static \
    --disable-shared \
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
  clone_ffmpeg
  cd FFmpeg
  echo "Configuring ffmpeg"
  ./configure \
    --prefix=$FFMPEG_PREFIX \
    --enable-static \
    --disable-shared \
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
