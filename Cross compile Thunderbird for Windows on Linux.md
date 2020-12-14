# Cross compile Thunderbird for Windows on Linux

## Caveats

### Limited Functionality

In the current state, I've disabled several features that are found in a build done on Windows.
* Windows search integraton is removed. You know that SearchAPI.h header file?   This is how I got around its absence in the MinGW headers. It's only needed by the Windows Search component (Windows Explorer's ability to search Thunderbird emails, not search within Thunderbird), so it's been turned off for MinGW compiles.
* MAPI integration is turned off. I haven't tried to make it work yet, it might result in another header problem like with SearchAPI.h. It's on the list of things to look at closer.
* WebRTC is turmed off. I don't think anything in Thunderbird itself uses this anyway, but extensions might I suppose.

### Disclaimer

This is completely unsupported and barely tested. If something doesn't work, I'll do what I can with it as I have time.

There's a lot of compiler warnings at the moment. I'll try to clean some up. A lot look like redefined symbols and stuff, so I probably just need some #ifdefs peppered throughout.

I'm not actually using these builds. I'm doing this because there's times I need to test some piece of something on Windows, and it usually doesn't matter a whole lot whether its a regular Windows build or a limited functionality cross-compile build.

### Background and requirements

What I've got here is based on the documentation for [Building Windows Firefox on Linux with MinGW-clang](https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Cross_Compile_Mozilla_for_Mingw32). This would not be possible without the efforts of the Firefox build team.

Use their toolchain. There's a number of patches they apply, and I figure there's a reason. It's easy to grab the pieces you need, see below.

It's a combination of the CLANG compiler with MinGW header files. As a result, you do not need the  Windows 10 SDK or Microsoft's linker.exe. However, you will be missing at least SearchAPI.h and other things like sockets don't work quite the same. The most obvious place I ran into socket problems was the LDAP SDK, but that wasn't too bad to fix up.

### Get the tools

mach bootstrap won't work, you'll have to grab what you need yourself. First, make sure you have your basic requirements. Install these from your distribution repository or from source or however.

- Mercurial
- GCC/G++
- upx
- wine
- makensis
- nasm
- yasm

For makensis, you'll need the mingw32 or mingw64 variant if your distribution provides one. On Ubuntu it's called "nsis". I'd grab "nsis-pluginapi" as well.

Get a copy of the source. These patches are based on comm-central (currently 69) so that's probably the best place to start.

Create an emptyish mozconfig, and run mach configure. (maybe not?) Probably mach bootstrap.

Then you can download the toolchain files with mach artifact toolchain. Something like this should work:
```
mkdir ~/.mozbuild/mingw && pushd ~/.mozbuild/mingw
for i in linux64-clang-8-mingw-x64 mingw32-rust-1.35 linux64-cbindgen linux64-mingw-fxc2-x86 linux64-node
do
  mach artifact toolchain --cache-dir ~/.mozbuild --from-build $i
done
popd
```

Double check the version number on mingw32-rust-1.35. That's current as of this writing, but it changes fast. Look at M-C:taskcluster/ci/toolchain/rust.yml for the current name.

### Fix up mozconfig and apply patches

Double check the paths. TOOLTOOL_DIR should point at ~/.mozbuild/mingw.

The patches:
```
pushd $topsrcdir/comm
for i in disable_windows_search.patch ldap_sdk_mingw.patch recognize_mingwclang_compiler.patch; do
   patch -p1 < $PATCHPATH/$i
done
popd
```

### Run mach configure again

Hopefully it works!

### Run mach build followed by mach package

* Get mingw-clang cross-compiler and tools (for win64)
	* clang - https://index.taskcluster.net/v1/task/gecko.cache.level-3.toolchains.v3.linux64-clang-8-mingw-x64.latest/artifacts/public/build/clangmingw.tar.xz
	* rust - https://index.taskcluster.net/v1/task/gecko.cache.level-3.toolchains.v3.mingw32-rust-1.34.latest/artifacts/public/build/rustc.tar.xz
	* cbindgen - https://index.taskcluster.net/v1/task/gecko.cache.level-3.toolchains.v3.linux64-cbindgen.latest/artifacts/public/build/cbindgen.tar.xz
	* nsis - https://index.taskcluster.net/v1/task/gecko.cache.level-3.toolchains.v3.linux64-mingw32-nsis.latest/artifacts/public/build/nsis.tar.xz
		* TODO: How to build NSIS so you dont have to do install location hack thing
	* fxc2 - https://index.taskcluster.net/v1/task/gecko.cache.level-3.toolchains.v3.linux64-mingw32-fxc2.latest/artifacts/public/build/fxc2.tar.xz
* Install UPX and Wine from package manager

* Install the MAPI header files
	* Download from https://www.microsoft.com/en-us/download/details.aspx?id=12905
	* Somehow get the updated MAPI.h file in there

* Create a mozconfig file

```
srcdirname=$(basename $topsrcdir)
CC="clang -fcolor-diagnostics"
CXX="clang++ -fcolor-diagnostics"

ac_add_options --enable-application=comm/mail
ac_add_options --enable-calendar
ac_add_options --enable-ccache
ac_add_options --disable-debug-symbols

# Not supported by mingw
ac_add_options --disable-maintenance-service
ac_add_options --disable-webrtc # Bug 1393901
ac_add_options --disable-geckodriver # Bug 1489320

unset MAKECAB
ac_add_options --target=x86_64-w64-mingw32
ac_add_options --with-toolchain-prefix=x86_64-w64-mingw32-

TOOLTOOL_DIR=$HOME/.mozbuild/mingw
HOST_CC="$TOOLTOOL_DIR/clang/bin/clang"
HOST_CXX="$TOOLTOOL_DIR/clang/bin/clang++"
CC="$TOOLTOOL_DIR/clang/bin/x86_64-w64-mingw32-clang"
CXX="$TOOLTOOL_DIR/clang/bin/x86_64-w64-mingw32-clang++"
ac_add_options --with-clang-path="$CC"
ac_add_options --with-libclang-path="$TOOLTOOL_DIR/clang/lib"
CXXFLAGS="-fms-extensions"
AR=llvm-ar
RANLIB=llvm-ranlib

RUSTC="${TOOLTOOL_DIR}/rustc/bin/rustc"
CARGO="${TOOLTOOL_DIR}/rustc/bin/cargo"
RUSTFMT="${TOOLTOOL_DIR}/rustc/bin/rustfmt"
CBINDGEN="${TOOLTOOL_DIR}/cbindgen/cbindgen"

# For Stylo
BINDGEN_CFLAGS="-I$TOOLTOOL_DIR/clang/x86_64-w64-mingw32/include/c++/v1 -I$TOOLTOOL_DIR/clang/x86_64-w64-mingw32/include"

# Bug 1471698 - Work around binutils corrupting mingw clang binaries.
LDFLAGS="-Wl,-S"
STRIP=/bin/true
OBJCOPY=/bin/true

# We want to make sure we use binutils and other binaries in the tooltool
# package.
mk_add_options "export PATH=$TOOLTOOL_DIR/clang/bin:$TOOLTOOL_DIR/mingw32/bin:$TOOLTOOL_DIR/fxc2/bin:$PATH"

LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOOLTOOL_DIR/mingw32/lib64:$TOOLTOOL_DIR/clang/lib
mk_add_options "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

mk_add_options MOZ_PARALLEL_BUILD=6
mk_add_options MOZ_MAKE_FLAGS="-j6"
mk_add_options MOZ_OBJDIR="/home/rob/moz/obj-mingw-${srcdirname}"

export MOZ_INCLUDE_SOURCE_INFO=1



```

