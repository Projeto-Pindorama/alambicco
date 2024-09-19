# Alambiko

Alambiko is the repository that contains all the build recipes to Copacabana Linux
packages.
It's similar in spirit to ``salsa.debian.org``, ``git.centos.org/rpms`` and many,
many others.

## Trivia

"Alambiko" (ˌalambˈiko) means "alembic" in Esperanto.

## Chip in!

### Templates

Below there is an example of a ``pkgbuild`` file.

```ini
Name="Fubá"
Vendor="Pindorama"
Description="Fubá flour-based utilities."
Version="0.0"
Depends_on=("base/kernel-headers", "base/LibC")
Maintainer="Barão de Mauá"
Hotline="irineu.evangelista@correios.gov.br"
```

```sh
# vim: set filetype=sh :
c -cd "fuba.$Version.tar.xz" | tar -xvf - -C "$OBJDIR"

cd "$OBJDIR/fuba-$Version"
./configure --prefix=/usr \
	--libdir=/lib \
	--pkgconfigdir=/usr/share/lib/pkgconfig

gmake -j$(nproc) \
	&& DESTDIR="$Destdir" gmake install
```

These are the functions currently implemented and ready to use on pkgbuilds:

| Function identifier | Description |
|---|---|
| ``basename`` | Strips directory and suffix from filenames. |
| ``c`` | Wrapper for decompressors that supports writing<br>the decompressed data to the standard output.<br>Currently it supports cat (for tarballs without<br>compression), bzip2, gzip and xz. |
| ``lines`` | Counts the quantity of lines, like ``wc -l``. |
| ``n`` | Counts elements. It's a workaround for the ``#``<br>macro present in GNU Broken-Again Shell 4.3, but<br>you can use it instead the aforesaid macro in<br>any shell that support arrays. |
| ``nproc`` | Counts processors in the machine, multiplatform (can<br>run on \*BSD, Darwin (MacOS), Linux and SunOS); |
| ``log`` | Prints messages to the standard error output |
| ``realpath`` | Gets the real path to files. |
| ``timeout`` | Runs a commmand with time limit. |

## Licence

The UUIC/NCSA licence, as Copacabana work itself.

