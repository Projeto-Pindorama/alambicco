# vim: set filetype=sh :

c -cd "dev/$Version.tar.gz" | tar -xvf - -C "$OBJDIR"

cd "$OBJDIR/${Name}-${Version}"
mussel_directory="$(pwd)"
mussel_PREFIX="$mussel_directory/toolchain"
mussel_SYSROOT="$mussel_directory/sysroot"
./check
./mussel "$(uname -m)" -l -o -k -p
(cd "$mussel_SYSROOT"; tar -cf - . | tar -xf - -C "$Destdir") \
&& (cd "$mussel_PREFIX"; tar -cf - . | tar -xf - -C "$Destdir")

mv $Destdir/usr/lib/* "$Destdir/lib/"
mv  $Destdir/usr/include/* "$Destdir/include/"
rmdir $Destdir/usr/{include,lib}
ln -s '../lib' "$Destdir/usr/lib"
ln -s '../include' "$Destdir/usr/include"
"$Destdir/bin/${TARGET_TUPLE}-gcc" -dumpspecs \
	| sed 's@/lib/ld-musl@/llvmtools/lib/ld-musl@g' \
	> "/cgnutools/lib/gcc/${TARGET_TUPLE}/12.2.0/specs"	
