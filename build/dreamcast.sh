#!/bin/sh

# Resolve paths relative to this script so it works from any cwd.
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/cmake"
BUILD_DIR="build-dreamcast"
mkdir -p "$BUILD_DIR"

# Configure with CMake for KallistiOS Dreamcast target
echo "Configuring LZ4 for Dreamcast..."
kos-cmake -S "$SOURCE_DIR" \
      -B "$BUILD_DIR" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="${KOS_BASE}/addons" \
      -DCMAKE_INSTALL_LIBDIR:STRING="lib/dreamcast" \
      -DCMAKE_INSTALL_INCLUDEDIR:STRING="include/lz4" \
      -DBUILD_SHARED_LIBS=OFF \
      -DBUILD_STATIC_LIBS=ON \
      -DLZ4_BUILD_CLI=OFF \
      -DLZ4_BUILD_LEGACY_LZ4C=OFF \
      -DCMAKE_C_FLAGS="-include kos.h -include fastmem/fastmem.h -DLZ4_FAST_DEC_LOOP=1 -DLZ4_DISTANCE_MAX=32 -DLZ4_FREESTANDING=1 -DLZ4_memcpy=memcpy_fast -DLZ4_memmove=memmove_fast -DLZ4_memset=memset_fast"

#-DCMAKE_C_FLAGS="-DLZ4_FREESTANDING=1 -include /home/gpf/code/dreamcast/lz4/build/lz4_dreamcast.h 
# Build
echo "Building LZ4..."
cmake --build "$BUILD_DIR" -- -j$(nproc)

# Install
echo "Installing LZ4 to ${KOS_BASE}/addons..."
cmake --install "$BUILD_DIR"

# Optionally strip symbols to reduce size
# echo "Stripping liblz4.a to reduce size..."
# sh-elf-strip "${KOS_BASE}/addons/lib/dreamcast/liblz4.a"
