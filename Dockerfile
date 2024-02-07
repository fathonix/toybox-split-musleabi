FROM debian:bookworm

# Install armeabi toolchain and other dependencies
RUN apt update && \
	DEBIAN_FRONTEND=noninteractive apt upgrade -y && \
	DEBIAN_FRONTEND=noninteractive apt install -y \
		--no-install-recommends \
		--no-install-suggests   \
		gcc-arm-linux-gnueabi   \
		libc-dev-armel-cross    \
		ca-certificates         \
		libc-dev                \
		patch                   \
		make                    \
		wget                    \
		file                    \
		gcc

# Set musl and ToyBox versions
ENV MUSL_VERSION=1.2.4 \
    HEADERS_VERSION=4.19.88 \
    TOYBOX_VERSION=0.8.10

# Download tarballs
RUN set -eux; \
	mkdir -p /work/musl; \
	cd /work/musl; \
	wget -O musl.tgz "https://musl.libc.org/releases/musl-$MUSL_VERSION.tar.gz"; \
	tar xf musl.tgz --strip-components=1; \
	rm musl.tgz; \
	mkdir -p /work/kernel-headers; \
	cd /work/kernel-headers; \
	wget -O headers.tgz "https://github.com/sabotage-linux/kernel-headers/archive/v$HEADERS_VERSION.tar.gz"; \
	tar xf headers.tgz --strip-components=1; \
	rm headers.tgz; \
	mkdir -p /work/toybox; \
	cd /work/toybox; \
	wget -O toybox.tgz "https://landley.net/toybox/downloads/toybox-$TOYBOX_VERSION.tar.gz"; \
	tar xf toybox.tgz --strip-components=1; \
	rm toybox.tgz

COPY musl-*.patch /work/musl/

# Compile musl and install kernel headers
RUN set -eux; \
	cd /work/musl; \
	for f in *.patch; do patch -p1 < "$f"; done; \
	CROSS_COMPILE=arm-linux-gnueabi- ./configure \
		--prefix=/work/musl/out \
		--disable-shared \
		--enable-wrapper; \
	make install; \
	cd /work/kernel-headers; \
	make ARCH=arm prefix=/work/musl/out install

# Compile ToyBox with musl
ENV CC=/work/musl/out/bin/musl-gcc \
    STRIP=arm-linux-gnueabi-strip \
    PREFIX=/work/toybox/out \
    CFLAGS=-static

RUN set -eux; \
	cd /work/toybox; \
	make allnoconfig; \
	make ping telnet tar

# ToyBox enables all optional command options when building single commands.
# This becomes a problem when building wget without TLS support.
# This workaround only enables wget and invokes make.sh directly.
RUN set -eux; \
	cd /work/toybox; \
	cp .config .singleconfig; \
	sed -i \
		-e 's/# CONFIG_WGET is not set/CONFIG_WGET=y/' \
		-e 's/CONFIG_TOYBOX=y/# CONFIG_TOYBOX is not set/' \
		.singleconfig; \
	KCONFIG_CONFIG=.singleconfig OUTNAME="$PREFIX/wget" scripts/make.sh; \
	file out/*

WORKDIR /work/toybox