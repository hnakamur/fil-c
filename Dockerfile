# syntax=docker/dockerfile:1
FROM debian

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git patchelf ruby cmake ninja-build make clang automake libtool bison python3 \
        texinfo autopoint

RUN useradd --create-home --home-dir /home/build --shell /bin/bash \
        -c 'build user for fil-C' build
RUN echo "build:mypassword" | chpasswd

USER build
WORKDIR /home/build
RUN git clone https://github.com/pizlonator/llvm-project-deluge
WORKDIR /home/build/llvm-project-deluge
RUN sed -i '/configure/s;$; --with-privsep-path=$HOME/var/empty;' build_openssh.sh
RUN ./setup_gits.sh
RUN ./build_all.sh
