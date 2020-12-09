# Info: https://github.com/vmunoz82/eda_tools

# COMMON BUILDER
FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install --no-install-recommends \
    build-essential clang bison flex libreadline-dev \
    gawk tcl-dev libffi-dev git mercurial graphviz   \
    xdot pkg-config python python3 libftdi-dev gperf \
    libboost-program-options-dev autoconf libgmp-dev \
    cmake curl ca-certificates \
    python3-dev libboost-filesystem-dev libboost-iostreams-dev \
    libboost-thread-dev qt5-default libeigen3-dev libqt5opengl5-dev && \
    rm -rf /var/lib/apt/lists/*

# YOSYS
FROM builder as yosys

ARG YOSYS_COMMIT=master
LABEL yosys_commit=$YOSYS_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/cliffordwolf/yosys.git yosys && \
    cd yosys && \
    git checkout $YOSYS_COMMIT && \
    git log -1 --oneline > ../yosys.commit && \
    make -j$(nproc) && \
    mkdir -p /tmp/yosys && make DESTDIR=/tmp/yosys install

# SYMBIYOSYS
FROM builder as symbiyosys

ARG SYMBIYOSYS_COMMIT=master
LABEL symbiyosys_commit=$SYMBIYOSYS_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/cliffordwolf/SymbiYosys.git symbiyosys && \
    cd symbiyosys && \
    git checkout $SYMBIYOSYS_COMMIT && \
    git log -1 --oneline > ../symbiyosys.commit && \
    mkdir -p /tmp/symbiyosys && make DESTDIR=/tmp/symbiyosys install

# Z3
FROM builder as z3

ARG Z3_COMMIT=master
LABEL z3_commit=$Z3_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/Z3Prover/z3.git z3 && \
    cd z3 && \
    git checkout $Z3_COMMIT && \
    git log -1 --oneline > ../z3.commit && \
    PKG=$(python3 -c "import site;print([p for p in site.getsitepackages() if p[:11]=='/usr/local/'][0])") && \
    python scripts/mk_make.py --prefix=/usr/local --python --pypkgdir=$PKG && cd build && make -j$(nproc) && \
    mkdir -p /tmp/z3 && make DESTDIR=/tmp/z3 install

# BOOLECTOR
FROM builder as boolector

ARG BOOLECTOR_COMMIT=master
LABEL boolector_commit=$BOOLECTOR_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/boolector/boolector.git boolector && \
    cd boolector && \
    git checkout $BOOLECTOR_COMMIT && \
    git log -1 --oneline > ../boolector.commit && \
    ./contrib/setup-lingeling.sh && \
    ./contrib/setup-btor2tools.sh && \
    ./configure.sh && cd build && make -j$(nproc) && \
    mkdir -p /tmp/boolector && make DESTDIR=/tmp/boolector install

# YICES2
FROM builder as yices2

ARG YICES2_COMMIT=master
LABEL yices2_commit=$YICES2_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/SRI-CSL/yices2.git yices2 && \
    cd yices2 && \
    git checkout $YICES2_COMMIT && \
    git log -1 --oneline > ../yices2.commit && \
    autoconf && ./configure && make -j$(nproc) && \
    mkdir -p /tmp/yices2 && make DESTDIR=/tmp/yices2 install

# ICESTORM
FROM builder as icestorm

ARG ICESTORM_COMMIT=master
LABEL icestorm_commit=$ICESTORM_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/YosysHQ/icestorm.git icestorm && \
    cd icestorm && \
    git checkout $ICESTORM_COMMIT && \
    git log -1 --oneline > ../icestorm.commit && \
    make -j$(nproc) && \
    mkdir -p /tmp/icestorm && make DESTDIR=/tmp/icestorm install

# NEXTPNR ICE40
FROM icestorm as nextpnr-ice40

ARG NEXTPNR_ICE40_COMMIT=master
LABEL nextpnr_ice40_commit=$NEXTPNR_ICE40_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/YosysHQ/nextpnr nextpnr && \
    cd nextpnr && \
    git checkout $NEXTPNR_ICE40_COMMIT && \
    git log -1 --oneline > ../nextpnr-ice40.commit && \
    cmake -DBUILD_GUI=OFF -DSTATIC_BUILD=ON -DARCH=ice40 -DICEBOX_DATADIR=/tmp/icestorm/usr/local/share/icebox . && \
    make -j$(nproc) && \
    mkdir -p /tmp/nextpnr && make DESTDIR=/tmp/nextpnr install && \
    strip /tmp/nextpnr/usr/local/bin/nextpnr-ice40

# TRELLIS
FROM builder as trellis

ARG TRELLIS_COMMIT=master
LABEL trellis_commit=$TRELLIS_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone --recursive https://github.com/YosysHQ/prjtrellis prjtrellis && \
    cd prjtrellis && \
    git checkout $TRELLIS_COMMIT && \
    git log -1 --oneline > ../trellis.commit && \
    cd libtrellis && \
    cmake . && \
    make -j$(nproc) && \
    mkdir -p /tmp/prjtrellis && make DESTDIR=/tmp/prjtrellis install

# NEXTPNR ECP5
FROM trellis as nextpnr-ecp5

ARG NEXTPNR_ECP5_COMMIT=master
LABEL nextpnr_commit=$NEXTPNR_ECP5_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/YosysHQ/nextpnr nextpnr && \
    cd nextpnr && \
    git checkout $NEXTPNR_ECP5_COMMIT && \
    git log -1 --oneline > ../nextpnr-ecp5.commit && \
    cmake -DBUILD_GUI=OFF -DSTATIC_BUILD=ON -DARCH=ecp5 -DTRELLIS_DATADIR=/tmp/prjtrellis/usr/local/share/trellis -DTRELLIS_LIBDIR=/tmp/prjtrellis/usr/local/lib/trellis . && \
    make -j$(nproc) && \
    mkdir -p /tmp/nextpnr && make DESTDIR=/tmp/nextpnr install && \
    strip /tmp/nextpnr/usr/local/bin/nextpnr-ecp5

# EDA TOOLS
FROM ubuntu:20.04

LABEL maintainer="Victor Muñoz <victor@2c-b.cl>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install --no-install-recommends \
    python3 libffi7 libtcl8.6 libgomp1 \
    python3-pip git gtkwave \
    vim less \
    libftdi1 \
    make \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/commits

ARG YOSYS_COMMIT=master
LABEL yosys_commit=$YOSYS_COMMIT
COPY --from=yosys /tmp/yosys/usr/local /usr/local/
COPY --from=yosys /tmp/build/yosys.commit /usr/local/commits

ARG SYMBIYOSYS_COMMIT=master
LABEL symbiyosys_commit=$SYMBIYOSYS_COMMIT
COPY --from=symbiyosys /tmp/symbiyosys/usr/local /usr/local/
COPY --from=symbiyosys /tmp/build/symbiyosys.commit /usr/local/commits

ARG Z3_COMMIT=master
LABEL z3_commit=$Z3_COMMIT
COPY --from=z3 /tmp/z3/usr/local /usr/local/
COPY --from=z3 /tmp/build/z3.commit /usr/local/commits

ARG BOOLECTOR_COMMIT=master
LABEL boolector_commit=$BOOLECTOR_COMMIT
COPY --from=boolector /tmp/boolector/usr/local /usr/local/
COPY --from=boolector /tmp/build/boolector.commit /usr/local/commits

ARG YICES2_COMMIT=master
LABEL yices2_commit=$YICES2_COMMIT
COPY --from=yices2 /tmp/yices2/usr/local /usr/local/
COPY --from=yices2 /tmp/build/yices2.commit /usr/local/commits

ARG ICESTORM_COMMIT=master
LABEL icestorm_commit=$ICESTORM_COMMIT
COPY --from=icestorm /tmp/icestorm/usr/local /usr/local/
COPY --from=icestorm /tmp/build/icestorm.commit /usr/local/commits

ARG NEXTPNR_ICE40_COMMIT=master
LABEL nextpnr_commit=$NEXTPNR_ICE40_COMMIT
COPY --from=nextpnr-ice40 /tmp/nextpnr/usr/local /usr/local/
COPY --from=nextpnr-ice40 /tmp/build/nextpnr-ice40.commit /usr/local/commits

ARG TRELLIS_COMMIT=master
LABEL trellis_commit=$TRELLIS_COMMIT
COPY --from=trellis /tmp/prjtrellis/usr/local /usr/local/
COPY --from=trellis /tmp/build/trellis.commit /usr/local/commits

ARG NEXTPNR_ECP5_COMMIT=master
LABEL nextpnr_commit=$NEXTPNR_ECP5_COMMIT
COPY --from=nextpnr-ecp5 /tmp/nextpnr/usr/local /usr/local/
COPY --from=nextpnr-ecp5 /tmp/build/nextpnr-ecp5.commit /usr/local/commits

ARG NMIGEN_COMMIT=master
LABEL nmigen_commit=$NMIGEN_COMMIT
RUN pip3 install git+https://github.com/nmigen/nmigen@$NMIGEN_COMMIT && \
    python3 -m pip show nmigen | grep Version > /usr/local/commits/nmigen.commit

ARG NMIGEN_BOARDS_COMMIT=master
LABEL nmigen_boards_commit=$NMIGEN_BOARDS_COMMIT
RUN pip3 install git+https://github.com/nmigen/nmigen-boards && \
    python3 -m pip show nmigen_boards | grep Version > /usr/local/commits/nmigen_boards.commit

VOLUME ["/workspace"]
WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]
