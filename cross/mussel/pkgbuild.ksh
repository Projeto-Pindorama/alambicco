# vim: set filetype=sh :

c -cd "dev/$Version.tar.gz" | tar -xf - -C "$OBJDIR"
cd "$OBJDIR/${Name}-${Version}"
mussel_directory="$(pwd)"
mussel_TOOLCHAIN="$mussel_directory/toolchain"
./check
./mussel $MARCH -T $CROSS_VENDOR -l -o -k -p
(cd "$mussel_TOOLCHAIN"; tar -cf - . | tar -xf - -C "$Destdir") 
"$Destdir/bin/${TARGET_TUPLE}-gcc" -dumpspecs \
	| sed 's@/lib/ld-musl@/llvmtools/lib/ld-musl@g' \
	> "$Destdir/lib/gcc/${TARGET_TUPLE}/$($Destdir/bin/${TARGET_TUPLE}-gcc --version \
		| nawk '/.*gcc \(mussel\).*/ { print $3 }')/specs"
