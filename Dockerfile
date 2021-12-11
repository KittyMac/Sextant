FROM ubuntu:18.04 as builder
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

RUN echo "Target: $TARGETPLATFORM $TARGETOS $TARGETARCH $TARGETVARIANT"

# 1. get an environment set ready for building with swift
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libatomic1 \
    libbsd0 \
    libcurl4 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libgcc-5-dev \
    libstdc++-5-dev \
    libpython2.7 \
    tzdata \
    zlib1g-dev \
    libpq-dev \
    git \
    curl \
    wget \
    pkg-config

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /root
ENV PATH="/root/swift/usr/bin:$PATH"
ENV SWIFTURL="http://www.chimerasw.com/swift/swift-5.3-$TARGETARCH$TARGETVARIANT-RELEASE-Ubuntu-18.04.tar.gz"

RUN mkdir -p swift
RUN wget -qO- $SWIFTURL | tar -xvz -C swift


# 2. build our swift program
WORKDIR /root/Sextant
COPY ./Makefile ./Makefile
COPY ./Package.swift ./Package.swift
COPY ./meta ./meta
COPY ./Sources ./Sources
COPY ./Tests ./Tests

RUN swift package update
RUN swift build --configuration release
RUN swift test -v
