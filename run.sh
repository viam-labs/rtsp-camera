#!/bin/sh

if [ $(command -v getprop) ]; then
	echo detected android host, reading libraries from $PWD/lib
	export LD_LIBRARY_PATH=$PWD/lib:$LD_LIBRARY_PATH
	export ANDROID=yes
fi

ARCH=$(uname -m)

if [ $ANDROID ]; then
	if [ $ARCH = "aarch64" ]; then
		echo detected arm64 arch, running viamrtsp-android-arm64
		# Run arm64 binary with LD_LIBRARY_PATH set
		exec ./bin/viamrtsp-android-arm64 $@
	fi
else;
	if [ $ARCH = "aarch64" ]; then
		echo detected arm64 arch, running viamrtsp-linux-arm64
		# Run arm64 appimage
		exec ./bin/viamrtsp-linux-arm64 $@ 
	fi
	if [ $ARCH = "x86_64" ]; then
		echo detected x86_64 arch, running viamrtsp-linux-x86_64
		# Run x86_64 appimage
		exec ./bin/viamrtsp-linux-x86_64 $@
	fi
fi
