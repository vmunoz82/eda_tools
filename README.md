# EDA Tools: Docker image
 
When you decide to learn to program digital circuits at first, you hit a big wall, the learning curve is steep and part of this is the difficulty in creating an environment with the necessary tools to get started.

Fortunately, the world of open source EDA tools has come a long way in recent years, allowing you to use them for learning without having to resort to the bloatware hell of many commercial tools.

That's why I want to save others time, so you can focus on learning instead of tooling. And for that, nothing better than a ready-to-use Docker image.

This image is focused on [Amaranth HDL](https://github.com/amaranth-lang/amaranth), and [Silice](https://github.com/sylefeb/Silice) as HDL languages, although you can work directly with Verilog with some of the included tools.

With this image and for certain FPGAs like the Lattice ICE-40 series and Gowin LittleBee series, you can design, implement, test, inspect waveforms, perform BMC proofs, synthesize and program your board without any additional software.

The previous [0.1](https://github.com/vmunoz82/eda_tools/tree/0.1) image had a total size of 1.06GB decompressed and 309.27MB compressed.
The current one ([0.2](https://github.com/vmunoz82/eda_tools/tree/0.2)) is 1.72 GB decompressed and 567.37MB compressed.

For learning Amaranth HDL, I recommend you to try the excellent [Robert Baruch](https://github.com/RobertBaruch) [Amaranth HDL Tutorial](https://github.com/RobertBaruch/nmigen-tutorial) and the [Amaranth HDL graded exercises](https://github.com/RobertBaruch/nmigen-exercises/) as in this image you have all the needed software already installed.

As for Silice, I recommend you check out their full list of examples, as they include projects related to RISC-V, HDMI, SDRAM, I2S, NeoPixel, VGA, a [hardware  Wolfenstein 3D render loop](https://github.com/sylefeb/Silice/tree/master/projects/wolfpga) and the famous [DooM-chip](https://github.com/sylefeb/Silice/tree/master/projects/doomchip) among others.

## Tools included
Here is the list of tools included.

### [Amaranth HDL](https://github.com/amaranth-lang/amaranth) and its [Board definitions](https://github.com/amaranth-lang/amaranth-boards) (two-clause BSD license)

A modern hardware definition language and toolchain based on Python.

### [Silice](https://github.com/sylefeb/Silice) (GPLv3 and MIT licenses)

Silice is an open source language that simplifies prototyping and writing algorithms on FPGA architectures.

### [Verilator](https://www.veripool.org/verilator/) (GPLv3 or the Perl Artistic License Version 2.0)

Verilator open-source SystemVerilog simulator and lint system.

### [Yosys](https://github.com/YosysHQ/yosys) (ISC license)

This is a framework for RTL synthesis tools. It currently has extensive Verilog-2005 support and provides a basic set of synthesis algorithms for various application domains.

### [SymbiYosys](https://github.com/YosysHQ/sby) (ISC license)

SymbiYosys (sby) is a front-end driver program for [Yosys](https://github.com/YosysHQ/yosys)-based formal hardware verification flows. See [http://symbiyosys.readthedocs.io/](http://symbiyosys.readthedocs.io/) for documentation on how to use SymbiYosys.

SymbiYosys uses several SMT solvers as backend, in this image there ara three included.

#### [Z3](https://github.com/Z3Prover/z3) (MIT license)

Z3 is a theorem prover from Microsoft Research. It is licensed under the MIT license.

#### [Boolector](https://github.com/boolector/boolector) (MIT license)

Boolector is a Satisfiability Modulo Theories (SMT) solver for the theories
of fixed-size bit-vectors, arrays and uninterpreted functions.
It supports the [SMT-LIB](http://www.smt-lib.org) logics
BV,
[QF_ABV](http://smtlib.cs.uiowa.edu/logics-all.shtml#QF_ABV),
[QF_AUFBV](http://smtlib.cs.uiowa.edu/logics-all.shtml#QF_AUFBV),
[QF_BV](http://smtlib.cs.uiowa.edu/logics-all.shtml#QF_BV) and
[QF_UFBV](http://smtlib.cs.uiowa.edu/logics-all.shtml#QF_UFBV).
Boolector provides a rich C and Python API and supports incremental solving,
both with the SMT-LIB commands push and pop, and as solving under assumptions.
The documentation of its API can be found
[here](https://boolector.github.io/docs).

#### [Yices 2](https://github.com/SRI-CSL/yices2) (GPLv3 license)

Yices 2 is a solver for [Satisfiability Modulo
Theories](https://en.wikipedia.org/wiki/Satisfiability_modulo_theories)
(SMT) problems. Yices 2 can process input written in the SMT-LIB language, or in Yices' own specification language.
We also provide a [C API](https://github.com/SRI-CSL/yices2/blob/master/src/include/yices.h) 
and bindings for [Python](https://github.com/SRI-CSL/yices2_python_bindings), [Go](https://github.com/SRI-CSL/yices2_go_bindings), and [OCaml](https://github.com/SRI-CSL/yices2_ocaml_bindings).

### [nextpnr](https://github.com/YosysHQ/nextpnr) (ISC license)

nextpnr aims to be a vendor neutral, timing driven, FOSS FPGA place and route tool.

This Docker image includes nextpnr compiled for:
 * Lattice iCE40 devices supported by [Project IceStorm](http://www.clifford.at/icestorm/) (ISC license)
 * Lattice ECP5 devices supported by [Project Trellis](https://github.com/YosysHQ/prjtrellis) (ISC license)
 * Gowin LittleBee devices supported by [Project Apicula](https://github.com/yosysHQ/apicula/) (MIT license)

### [openFPGALoader](https://trabucayre.github.io/openFPGALoader/) (Apache-2.0 license)
openFPGALoader is a universal utility for programming FPGAs. Compatible with many boards, cables and FPGA from major manufacturers (Xilinx, Altera/Intel, Lattice, Gowin, Efinix, Anlogic, Cologne Chip). openFPGALoader works on Linux, Windows and macOS.

### Others
Python3, [Vim](https://www.vim.org/) editor, [GTKWave](http://gtkwave.sourceforge.net/), and [Graphviz](https://graphviz.org/)

## Build process

For build this image, you need [Docker](https://www.docker.com/) installed on a Linux based operating system (or [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10), etc.), and to perform the following command:

```bash
docker build -t vmunoz82/eda_tools:0.2 .
```

This will download and compile the list of tools listed above, this building process will take some time (lees than ~2 hour on my 4 cores i7-6600U laptop), but can be greatly improved with the [`BUILD_KIT=1` optimization](https://docs.docker.com/develop/develop-images/build_enhancements/) (with this option it builds in ~20 minutes on a 32 core CPU).

Of course you can pull the pre-compiled image from the [hub.docker.com](https://hub.docker.com/) registry with this:

```bash
docker pull vmunoz82/eda_tools:0.2
```

Which is a lot faster.

If you want to build some specific commit version for certain tool you can easily tell to the building process to do so [setting the building args variables](https://docs.docker.com/engine/reference/commandline/build/).

Example, if you want to force the Amaranth HDL version to v0.3, you have to do:

```bash
docker build --build-arg AMARANTH_COMMIT=v0.3 -t vmunoz82/eda_tools:0.2 .
```

The list of all available build arguments variables are the following:

 * *AMARANTH_COMMIT*
 * *AMARANTH_BOARDS_COMMIT*
 * *SILICE_COMMIT*
 * *VERILATOR_COMMIT*
 * *YOSYS_COMMIT*
 * *SYMBIYOSYS_COMMIT*
 * *Z3_COMMIT*
 * *BOOLECTOR_COMMIT*
 * *YICES2_COMMIT*
 * *ICESTORM_COMMIT*
 * *NEXTPNR_ICE40_COMMIT*
 * *TRELLIS_COMMIT*
 * *NEXTPNR_ECP5_COMMIT*
 * *APICULA_COMMIT* This requires the PIP syntax to specify the version (example: `==0.3.1`)
 * *NEXTPNR_GOWIN_COMMIT*
 * *OPENFPGALOADER_COMMIT*

All of them use the lastest master commit by default.

When you have an already created image, you can query the build arguments passed during the build-time with

```bash
docker inspect -f {{.Config.Labels}} vmunoz82/eda_tools
```

Or see the actual pulled commits during build-time from the files in the `/usr/local/commits directory.`

## Known working versions

Some of the included programs do not use tagging or version control and the authors only test them with the master version of their dependencies, be careful when changing versions.

For this [0.2](https://github.com/vmunoz82/eda_tools/tree/0.2) release, there is a set of known working versions that correctly interact with each other.

|commit selector|version|notes|
|:--|-|:--|
|AMARANTH_COMMIT|v0.3||
|AMARANTH_BOARDS_COMMIT|master|no tagging system|
|SILICE_COMMIT|master|no tagging system|
|VERILATOR_COMMIT|v4.222||
|YOSYS_COMMIT|yosys-0.17||
|SYMBIYOSYS_COMMIT|4886ed7e1999fd24a6e4d4383bc4fa1f91c2484e|paired with yosys-0.17|
|Z3_COMMIT|z3-4.8.17||
|BOOLECTOR_COMMIT|3.2.2||
|YICES2_COMMIT|yices-2.5.1||
|ICESTORM_COMMIT|master|paired with nextpnr-0.3|
|NEXTPNR_ICE40_COMMIT|nextpnr-0.3||
|TRELLIS_COMMIT|1.2.1|paired with nextpnr-0.3|
|NEXTPNR_ECP5_COMMIT|nextpnr-0.3||
|APICULA_COMMIT=|==0.3.1|paired with nextpnr-0.3|
|NEXTPNR_GOWIN_COMMIT|nextpnr-0.3||
|OPENFPGALOADER_COMMIT|v0.8.0||

## Programmer access from docker container

To provide access to USB programmers from the docker container, the following must be completed:

- Allow the user running the docker container to have access to the USB device, for this you can `chmod` the appropriate permission in `/dev/bus/usb/bid/did`, this also can be done adding an `udev` rule that set access right and group (plugdev) when a converter is plugged as [explained here](https://github.com/trabucayre/openFPGALoader/blob/master/doc/guide/install.rst#udev-rules).

- Put the corresponding programmer USB major on the allow list using a `cgroup` rule.

- Map the `/dev/bus/usb` directory as a volume inside the docker container.

- Join our user to the group with access to the USB device according to `udev` rule.

There are more options available to provide access to USB devices, the method used here has been tried only on Linux, more methods are [discussed here](https://stackoverflow.com/questions/24225647/docker-a-way-to-give-access-to-a-host-usb-or-serial-device).

## Usage

The idea of having the whole software stack inside a Docker image is to have an independent platform, so having the chance of work inside it without depend on the host system at all. That's why even the Vim editor is inside, of course you are free to change the properline in the Dockerfile to add your favorite editor/IDE.

The simplest way to use it is 

```bash
docker run --rm -ti vmunoz82/eda_tools
```

Which tells Docker to run in interactive mode the default entrypoint (*/bin/bash*), with the default user (*root*), on the default working directory (*/workspace*).

Of course this probably don't fit your needs, but you need to change these default values to accommodate to your own needs, for example:

```bash
docker run --rm --v $HOME/workspace:/workspace -ti vmunoz82/eda_tools:0.2
```

Will mount `$HOME/workspace` host directory on the `/workspace` directory inside the container, so everything you write there will survive among invocations.

To make your job easier, I created a script named `eda_tools.sh` which contains code equivalent to the follwing:

```bash
docker run --rm \                     # don't leave a volume on exit the container execution.
--user $(id -u):$(id -g) \            # use the same host user/group id.
-v /etc/passwd:/etc/passwd:ro \       # make available the current user list (read-only).
-v /etc/group:/etc/group:ro  \        # make available the current group list (read-only).
-v $HOME:/$HOME \                     # map host home to container home.
-w $PWD \                             # be in the same dir as the caller place.

-v /tmp/.X11-unix:/tmp/.X11-unix \    # make X available (for gtkwave).
-e DISPLAY=$DISPLAY \                 # make DISPLAY varible available.

--device-cgroup-rule="c 189:\* rmw" \ # put the USB devices with the major 189 on the devices allow group
-v /dev/bus/usb:/dev/bus/usb \        # share the USB bus tree with the container 
--group-add $PLUGDEV_GID \            # join the user to the plugdev group

-ti  vmunoz82/eda_tools:0.2           # our EDA Tools Docker image.
```

There is all explained in the comments, it invokes the container passing your home directory, your user id, your graphic environment to have a seamless experience.

