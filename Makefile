GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
ARCH ?= $(shell uname -m)
TARGET_IP ?= 127.0.0.1
API_LEVEL ?= 29
MOD_VERSION ?= 0.0.1

UNAME=$(shell uname)
ifeq ($(UNAME),Linux)
	NDK_ROOT ?= $(HOME)/Android/Sdk/ndk/26.1.10909125
	HOST_OS ?= linux
	CC_ARCH ?= aarch64
else
	NDK_ROOT ?= $(HOME)/Library/Android/sdk/ndk/26.1.10909125
	HOST_OS ?= darwin
	CC_ARCH ?= aarch64
endif

TOOLCHAIN := $(NDK_ROOT)/toolchains/llvm/prebuilt/$(HOST_OS)-x86_64
ifeq ($(GOOS),android)
	CC := $(TOOLCHAIN)/bin/$(CC_ARCH)-linux-android$(API_LEVEL)-clang
else
	CC := $(shell which gcc)
endif

FFMPEG_SUBDIR=ffmpeg-$(GOOS)-$(GOARCH)
FFMPEG_PREFIX=$(PWD)/$(FFMPEG_SUBDIR)

# CGO settings
CGO_ENABLED := 1
CGO_CFLAGS := -I$(FFMPEG_PREFIX)/include
CGO_LDFLAGS=-L$(FFMPEG_PREFIX)/lib

# Output settings
OUTPUT_DIR := bin
OUTPUT := $(OUTPUT_DIR)/viamrtsp-$(GOOS)-$(GOARCH)
APPIMG := rtsp-module-$(MOD_VERSION)-$(ARCH).AppImage

.PHONY: module build
build:
	CGO_ENABLED=$(CGO_ENABLED) \
		CGO_CFLAGS="$(CGO_CFLAGS)" \
		CGO_LDFLAGS="$(CGO_LDFLAGS)" \
		CC=$(CC) \
		go build -v -tags no_cgo \
		-o $(OUTPUT) ./cmd/module/cmd.go
module:
	cp $(OUTPUT) $(OUTPUT_DIR)/viamrtsp

# Install dependencies
linux-dep:
	sudo apt install libswscale-dev libavcodec-dev libavformat-dev

# Build FFmpeg for Linux or Android
.PHONY: ffmpeg
ffmpeg:
	FFMPEG_PREFIX=$(FFMPEG_PREFIX) GOOS=$(GOOS) TOOLCHAIN=$(TOOLCHAIN) API_LEVEL=$(API_LEVEL) CC_ARCH=$(CC_ARCH) CC=$(CC) ./etc/install_ffmpeg.sh

# Temporary command to get an android-compatible rdk branch
edit-android:
	# todo: dedup with rdk-droid command
	go mod edit -replace=go.viam.com/rdk=github.com/abe-winter/rdk@droid-apk
	go mod tidy

test:
	go test

lint:
	gofmt -w -s .

updaterdk:
	go get go.viam.com/rdk@latest
	go mod tidy
