# FROM alpine:3.9 as builder
FROM debian:stretch-slim as builder

# RUN apk add --update build-base curl git
RUN apt-get update && apt-get install -y \
    automake \
    build-essential \
    curl \
    git \
    libev-dev \
 && rm -rf /var/lib/apt/lists/*

ARG SRC_TAG=master
RUN git clone https://github.com/gaiasercomm/dtlsproxy.git -b $SRC_TAG /src
WORKDIR /src

# ADD . /src

RUN make

# FROM alpine:3.9
# FROM frolvlad/alpine-glibc:alpine-3.9_glibc-2.29
FROM debian:stretch-slim

RUN apt-get update && apt-get install -y \
    libev4 \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/dtlsproxy /usr/local/bin/

ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
