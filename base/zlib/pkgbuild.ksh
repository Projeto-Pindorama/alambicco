# vim: set filetype=sh :

xtools=true
case "x${Destdir##*/}" in
	'x') xtools=false
		PREFIX=usr ;;
	*) PREFIX=llvmtools
		Destdir="${Destdir%/*}";;
esac

c -cd "$Version.tar.gz" | tar -xvf - -C "$OBJDIR"

cd "$OBJDIR/zlib-ng-$Version"
CC=${TARGET_TUPLE}-gcc
CXX=${TARGET_TUPLE}-g++
./configure --prefix=/$PREFIX \
	--libdir=/$PREFIX/lib \
	--zlib-compat	
gmake -j$(nproc)
DESTDIR="$Destdir" gmake install
( cd "$Destdir/$PREFIX/lib"; ln -s libz.so.?.?.?.zlib-ng libz.so.1.3.11 )
