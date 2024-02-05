# toybox-single-musleabi

This repository holds a Dockerfile to build statically compiled,
split ToyBox binaries for Soft-Float 32-bit ARM.

## Getting Started

Make sure you have Docker. Then run the following to build:

```
docker run -it toybox-android-single:latest
```

Only `ping`, `telnet`, `tar`, and `wget` is built, you can tinker
to add more ToyBox commands.

# License

The Dockerfile is licensed under the MIT license.
© 2024 Aldo Adirajasa Fathoni
