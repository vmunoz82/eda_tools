# Info: https://github.com/vmunoz82/eda_tools

# COMMON BUILDER
FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install --no-install-recommends \
# Generated from matrix dependencies
# boolector icestorm nextpnr-ecp5 nextpnr-gowin nextpnr-ice40 openfpgaloader silice symbiyosys trellis verilator yices2 yosys z3
    build-essential git \
# apicula icestorm nextpnr-ecp5 nextpnr-gowin nextpnr-ice40 trellis verilator yosys z3
    python3 \
# boolector nextpnr-ecp5 nextpnr-gowin openfpgaloader silice trellis
    cmake \
# nextpnr-ecp5 nextpnr-gowin nextpnr-ice40 trellis
    libboost-filesystem-dev libboost-iostreams-dev libboost-program-options-dev libboost-thread-dev python3-dev \
# nextpnr-ecp5 nextpnr-gowin nextpnr-ice40
    libeigen3-dev \
# openfpgaloader silice yosys
    pkg-config \
# verilator yosys
    bison flex \
# verilator yices2
    autoconf \
# openfpgaloader
    libftdi1-dev libhidapi-dev libhidapi-hidraw0 libudev-dev zlib1g-dev \
# yosys
    clang libffi-dev libreadline-dev tcl-dev \
# silice
    default-jdk uuid-dev \
# yices2
    gperf libgmp-dev \
# boolector
    curl \
# verilator
    libfl-dev \
# icestorm
    libftdi-dev \
# apicula
    python3-pip \
# common
    ca-certificates \
    && \
    rm -rf /var/lib/apt/lists/*

# verilator
FROM builder as verilator

ARG VERILATOR_COMMIT=master
LABEL verilator_commit=$VERILATOR_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/verilator/verilator verilator && \
    cd verilator && \
    git checkout $VERILATOR_COMMIT && \
    git log -1 --oneline > ../verilator.commit && \
    export VERILATOR_ROOT=/usr/local/share/verilator && \
    autoconf && \
    ./configure && \
    make -j `nproc` && \
    make DESTDIR=/tmp/verilator install

# Silice
FROM builder as silice

ARG SILICE_COMMIT=master
LABEL silice_commit=$SILICE_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone --recurse-submodules https://github.com/sylefeb/Silice.git silice && \
    cd silice && \
    git checkout $SILICE_COMMIT && \
    git log -1 --oneline > ../silice.commit && \
    ./compile_silice_linux.sh && \
    cd /tmp/build/silice && \
    mkdir -p /tmp/silice/share/silice && \
    cp -R bin src docs frameworks learn-silice projects python tests tools /tmp/silice/share/silice

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

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    mkdir -p /tmp/build && cd /tmp/build && \
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
    cmake -DBUILD_GUI=OFF -DARCH=ice40 -DICEBOX_DATADIR=/tmp/icestorm/usr/local/share/icebox . && \
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
    cmake -DBUILD_GUI=OFF -DARCH=ecp5 -DTRELLIS_DATADIR=/tmp/prjtrellis/usr/local/share/trellis -DTRELLIS_LIBDIR=/tmp/prjtrellis/usr/local/lib/trellis . && \
    make -j$(nproc) && \
    mkdir -p /tmp/nextpnr && make DESTDIR=/tmp/nextpnr install && \
    strip /tmp/nextpnr/usr/local/bin/nextpnr-ecp5

# APICULA
FROM builder as apicula

ARG APICULA_COMMIT=">=0.3.1"
LABEL apicula_commit=$APICULA_COMMIT

RUN python3 -m pip install apycula$APICULA_COMMIT

# NEXTPNR GOWIN
FROM apicula as nextpnr-gowin

ARG NEXTPNR_GOWIN_COMMIT=master
LABEL nextpnr_gowin_commit=$NEXTPNR_GOWIN_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/YosysHQ/nextpnr nextpnr && \
    cd nextpnr && \
    git checkout $NEXTPNR_GOWIN_COMMIT && \
    git log -1 --oneline > ../nextpnr-gowin.commit && \
    cmake -DBUILD_GUI=OFF -DARCH=gowin -DGOWIN_BBA_EXECUTABLE=/usr/local/bin/gowin_bba . && \
    make -j$(nproc) && \
    mkdir -p /tmp/nextpnr && make DESTDIR=/tmp/nextpnr install && \
    strip /tmp/nextpnr/usr/local/bin/nextpnr-gowin

# OpenFPGALoader
FROM builder as openfpgaloader

ARG OPENFPGALOADER_COMMIT=master
LABEL openfpgaloader_commit=$OPENFPGALOADER_COMMIT

RUN mkdir -p /tmp/build && cd /tmp/build && \
    git clone https://github.com/trabucayre/openFPGALoader openfpgaloader && \
    cd openfpgaloader && \
    git checkout $OPENFPGALOADER_COMMIT && \
    git log -1 --oneline > ../openfpgaloader.commit && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/tmp/openfpgaloader && \
    cmake --build . && \
    mkdir -p /tmp/openfpgaloader && make install

# EDA TOOLS
FROM ubuntu:20.04

LABEL maintainer="Victor Muñoz <victor@2c-b.cl>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install --no-install-recommends \
    libffi7 libtcl8.6 libgomp1 \
# python
    python3 python3-pip \ 
# visualization
    gtkwave \
    graphviz \
    xdot \    
# cli
    vim less \
# nextpnr
    libboost-filesystem1.71.0 \
    libboost-program-options1.71.0 \
    libboost-thread1.71.0 \
# openFPGALoader
    libftdi1 \
    libusb-1.0-0 \
    libftdi1-2 \
    libhidapi-hidraw0 \
# dev misc
    git make \
# dev verilator
    g++ \
    && \
    rm -rf /var/lib/apt/lists/* 

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

ARG NEXTPNR_GOWIN_COMMIT=master
LABEL nextpnr_commit=$NEXTPNR_GOWIN_COMMIT
COPY --from=nextpnr-gowin /tmp/nextpnr/usr/local /usr/local/
COPY --from=nextpnr-gowin /tmp/build/nextpnr-gowin.commit /usr/local/commits

ARG APICULA_COMMIT=">=0.3.1"
LABEL apicula_commit=$APICULA_COMMIT
RUN python3 -m pip install apycula$APICULA_COMMIT && \
    python3 -m pip show apycula | grep Version > /usr/local/commits/apicula.commit

ARG AMARANTH_COMMIT=main
LABEL amaranth_commit=$AMARANTH_COMMIT
RUN pip3 install git+https://github.com/amaranth-lang/amaranth@$AMARANTH_COMMIT && \
    python3 -m pip show amaranth | grep Version > /usr/local/commits/amaranth.commit

ARG AMARANTH_BOARDS_COMMIT=main
LABEL amaranth_boards_commit=$AMARANTH_BOARDS_COMMIT
RUN pip3 install git+https://github.com/amaranth-lang/amaranth-boards@$AMARANTH_BOARDS_COMMIT && \
    python3 -m pip show amaranth_boards | grep Version > /usr/local/commits/amaranth_boards.commit

ARG SILICE_COMMIT=master
LABEL silice_commit=$SILICE_COMMIT
COPY --from=silice /tmp/silice /usr/local/
COPY --from=silice /tmp/build/silice.commit /usr/local/commits
ENV PATH="$PATH:/usr/local/share/silice/bin"

ARG OPENFPGALOADER_COMMIT=master
LABEL openfpgaloader_commit=$OPENFPGALOADER_COMMIT
COPY --from=openfpgaloader /tmp/openfpgaloader /usr/local/
COPY --from=openfpgaloader /tmp/build/openfpgaloader.commit /usr/local/commits

ARG VERILATOR_COMMIT=master
LABEL verilator_commit=$VERILATOR_COMMIT
COPY --from=verilator /tmp/verilator/usr/local /usr/local/
COPY --from=verilator /tmp/build/verilator.commit /usr/local/commits

VOLUME ["/workspace"]
WORKDIR /workspace
ENTRYPOINT ["/bin/bash"]
