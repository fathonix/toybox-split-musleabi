# toybox-split-musleabi

This repository holds a Dockerfile to build split ToyBox
binaries targeting soft-float, 32-bit ARM Linux EABI.
Statically linked with musl patched to fallback to
Google DNS on systems that don't have
`/etc/resolv.conf` like Android.

Currently only `ping`, `telnet`, `tar`, and `wget` is prebuilt.
Run `make <command>` to build other ToyBox commands.
Note that all binaries have no support for time zones on
Android and `wget` is built without HTTPS support
to keep the resulting binary size small.

## Getting Started

Pull the latest image from Docker Hub.

```
docker pull fathonix/toybox-split-musleabi
```

Or build the image locally.

```
git clone https://github.com/fathonix/toybox-split-musleabi
cd toybox-split-musleabi
docker build -t toybox-split-musleabi .
```

## License

The Dockerfile is licensed under the MIT license.
© 2024 Aldo Adirajasa Fathoni
