# vim: set filetype=sh :

xtools=true
case "x${Destdir##*/}" in
	'x') xtools=false
		PREFIX=/usr ;;
	*) PREFIX=/llvmtools
		Destdir="${Destdir%/*}" ;;
esac

c -cd "dev/$Version.tar.gz" | tar -xvf - -C "$OBJDIR"
cd "$OBJDIR/libreatomic-$Version"
if ! $xtools; then
	CC=$CC
	AR='llvm-ar'
else
	CC=${TARGET_TUPLE}-gcc
	CXX=${TARGET_TUPLE}-g++
	AR=${TARGET_TUPLE}-ar
	RANLIB=${TARGET_TUPLE}-ranlib
fi
export AR CC CXX RANLIB
gmake -j$(nproc)
DESTDIR="$Destdir" PREFIX=$PREFIX gmake install
