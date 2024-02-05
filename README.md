# toybox-split-musleabi

This repository holds a Dockerfile to build statically compiled,
split ToyBox binaries for Soft-Float 32-bit ARM.

Currently only `ping`, `telnet`, `tar`, and `wget` is prebuilt.
Run `make <command>` to try build other ToyBox commands.

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
