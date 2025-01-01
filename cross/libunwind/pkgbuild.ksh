# vim: set filetype=sh :

# Link to /cgnutools's lib.C.
"/cgnutools/bin/${TARGET_TUPLE}-gcc" -dumpspecs | sed 's@/lib/ld-musl@/cgnutools/lib/ld-musl@g' \
	> "/cgnutools/lib/gcc/${TARGET_TUPLE}/$(/cgnutools/bin/${TARGET_TUPLE}-gcc --version \
	| nawk '/.*gcc \(mussel\).*/ { print $3 }')/specs"

c -cd "dev/llvm-project-${Version}.src.tar.xz" | tar -xvf - -C "$OBJDIR"
cd "$OBJDIR/llvm-project-${Version}.src"

# Set CFLAGS to generate position-independent code,
# also set ld(1) flags for linking with libraries
# placed at /cgnutools/lib and to use cc(1), c++(1),
# ar(1), nm(1) and ranlib(1) from /cgnutools/bin.
CFLAGS='-fPIC'
CXXFLAGS=$CFLAGS
LINKERFLAGS='-Wl,-rpath=/cgnutools/lib '
CT="-DCMAKE_C_COMPILER=${TARGET_TUPLE}-gcc "
CT+="-DCMAKE_CXX_COMPILER=${TARGET_TUPLE}-g++ "
CT+="-DCMAKE_AR=/cgnutools/bin/${TARGET_TUPLE}-ar "
CT+="-DCMAKE_NM=/cgnutools/bin/${TARGET_TUPLE}-nm "
CT+="-DCMAKE_RANLIB=/cgnutools/bin/${TARGET_TUPLE}-ranlib "

cmake -G Ninja -B build -S libunwind -Wno-dev \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/cgnutools \
      -DCMAKE_INSTALL_OLDINCLUDEDIR=/cgnutools/include \
      -DCMAKE_EXE_LINKER_FLAGS="${LINKERFLAGS}" \
      -DCMAKE_SHARED_LINKER_FLAGS="${LINKERFLAGS}" \
      -DLIBUNWIND_INSTALL_HEADERS=ON \
      -DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON \
      -DLIBUNWIND_ENABLE_STATIC=OFF \
      -DLIBUNWIND_HIDE_SYMBOLS=ON $CT
ninja -C build unwind
DESTDIR="${Destdir%/*}" ninja -C build install-unwind-stripped

# Relink back to /llvmtools's lib.C.
"/cgnutools/bin/${TARGET_TUPLE}-gcc" -dumpspecs | sed 's@/lib/ld-musl@/llvmtools/lib/ld-musl@g' \
	> "/cgnutools/lib/gcc/${TARGET_TUPLE}/$(/cgnutools/bin/${TARGET_TUPLE}-gcc --version \
	| nawk '/.*gcc \(mussel\).*/ { print $3 }')/specs"
