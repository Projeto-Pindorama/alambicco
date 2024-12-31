# vim: set filetype=sh :
xtools=true
case "x${Destdir##*/}" in
	'x') xtools=false ;;
	*) ;;
esac

c -cd "musl-$Version.tar.gz" | tar -xvf - -C "$OBJDIR"

if ! $xtools; then
	for patch in 'handle-aux-at_base.patch' \
	'fix-paths.patch' 'syscall-cp-epoll.patch'; do
		patch -Np1 -i "$patch_dir/musl-$Version/$patch"
	done

	LDFLAGS="-Wl,-soname,libc.musl-$MUSL_ARCH.so.1"

	configure_opts=( "--prefix=/usr"
		"--sysconfdir=/etc"
		"--localstatedir=/var"
		"--mandir=/usr/share/man"
		"--infodir=/usr/share/info"
		"--disable-gcc-wrapper" )
	export LDFLAGS
else
	configure_opts=( "CROSS_COMPILE=${TARGET_TUPLE}-"
		"--prefix=/"
		"--target=${TARGET_TUPLE}" )
fi

cd "$OBJDIR/musl-$Version"
./configure ${configure_opts[@]}
gmake -j$(nproc)
DESTDIR="$Destdir" gmake install

( cd "$Destdir"
if $xtools; then
	rm "$Destdir/lib/ld-musl-$MUSL_ARCH.so.1"
	ln -s libc.so "$Destdir/lib/ld-musl-$MUSL_ARCH.so.1"	
	mkdir "$Destdir/etc/" "$Destdir/bin/"
	ln -s '../lib/libc.so' "$Destdir/bin/ldd"
	printf '/llvmtools/lib\n/llvmtools/%s/lib\n/llvmtools/lib/%s\n' \
		"$TARGET_TUPLE" "$TARGET_TUPLE" > "$Destdir/etc/ld-musl-$MUSL_ARCH.path"
	"/cgnutools/bin/${TARGET_TUPLE}-gcc" -dumpspecs | sed 's@/lib/ld-musl@/llvmtools/lib/ld-musl@g' \
		> "/cgnutools/lib/gcc/${TARGET_TUPLE}/$(/cgnutools/bin/${TARGET_TUPLE}-gcc --version \
		| nawk '/.*gcc \(mussel\).*/ { print $3 }')/specs"
else
	ln -s "./lib/ld-musl-$MUSL_ARCH.so.1" ./usr/lib/libc.so
	ln "./lib/ld-musl-$MUSL_ARCH.so.1" \
		"./lib/libc.musl-$MUSL_ARCH.so.1"
	ln "./lib/ld-musl-$MUSL_ARCH.so.1" ./bin/ldd

	printf '/lib\n/usr/lib' \
		> "./etc/ld-musl-$MUSL_ARCH.path"
fi )
