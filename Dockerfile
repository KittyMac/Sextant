FROM swift:5.7.1-focal

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libpq-dev \
    libpng-dev \
    libjpeg-dev \
    libjavascriptcoregtk-4.0-dev \
    libatomic1 \
    unzip
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /root/Sextant
COPY ./Makefile ./Makefile
COPY ./Package.resolved ./Package.resolved
COPY ./Package.swift ./Package.swift
COPY ./Sources ./Sources
COPY ./Tests ./Tests

RUN swift build --configuration release
RUN swift test -v
