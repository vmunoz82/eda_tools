# EDA Tools: Docker image
 
When you decide to learn to program digital circuits at first you hit a big wall, the learning curve is steep and part of this is the difficulty in creating an environment with the necessary tools to get started.

Fortunately, the world of open source EDA tools has come a long way in recent years allowing you to use them for learning without having to resort to the bloatware hell of many commercial tools.

That's why I want to save others time, so you can focus on learning instead of tooling. And for that, nothing better than a ready-to-use Docker image.

At the moment this image is focused on [nMigen](https://github.com/nmigen/nmigen), but later I will add [Silice](https://github.com/sylefeb/Silice), and maybe in addition to include open source tools, I will be able, through a de-bloating process, to incorporate synthesis tools from different vendors.

With this image and for certain FPGAs like the Lattice ICE-40 series, you can design, implement, test, inspect waveforms, perform BMC proofs, synthesize and program your board without any additional software.

The total size of the current image is 1.06GB uncompressed and 309.27MB.

I recommend you to try the excellent [Robert Baruch](https://github.com/RobertBaruch) [nMigen Tutorial](https://github.com/RobertBaruch) and the [nMigen exercises](https://github.com/RobertBaruch/nmigen-exercises/) as in this image you have all the needed software already installed.


## Tools included
Here is the list of tools included.

### [Yosys](https://github.com/YosysHQ/yosys)

This is a framework for RTL synthesis tools. It currently has extensive Verilog-2005 support and provides a basic set of synthesis algorithms for various application domains.

### [SymbiYosys](https://github.com/cliffordwolf/SymbiYosys)

SymbiYosys (sby) is a front-end driver program for [Yosys](http://www.clifford.at/yosys)-based formal hardware verification flows. See [http://symbiyosys.readthedocs.io/](http://symbiyosys.readthedocs.io/) for documentation on how to use SymbiYosys.

SymbiYosys uses several SMT solvers as backend, in this image there ara three included.

#### [Z3](https://github.com/Z3Prover/z3)

Z3 is a theorem prover from Microsoft Research. It is licensed under the MIT license.

#### [Boolector](https://github.com/boolector/boolector)

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

#### [Yices 2](https://github.com/SRI-CSL/yices2)

Yices 2 is a solver for [Satisfiability Modulo
Theories](https://en.wikipedia.org/wiki/Satisfiability_modulo_theories)
(SMT) problems. Yices 2 can process input written in the SMT-LIB language, or in Yices' own specification language.
We also provide a [C API](https://github.com/SRI-CSL/yices2/blob/master/src/include/yices.h) 
and bindings for [Python](https://github.com/SRI-CSL/yices2_python_bindings), [Go](https://github.com/SRI-CSL/yices2_go_bindings), and [OCaml](https://github.com/SRI-CSL/yices2_ocaml_bindings).

### [nextpnr](https://github.com/YosysHQ/nextpnr)

nextpnr aims to be a vendor neutral, timing driven, FOSS FPGA place and route tool.

This Docker image includes nextpnr compiled for:
 * Lattice iCE40 devices supported by [Project IceStorm](http://www.clifford.at/icestorm/)
 * Lattice ECP5 devices supported by [Project Trellis](https://github.com/YosysHQ/prjtrellis)

### [nMigen](https://github.com/nmigen/nmigen) and [nMigen boards](https://github.com/nmigen/nmigen-boards)
A refreshed Python toolbox for building complex digital hardware.

### Others
Python3, [Vim](https://www.vim.org/) editor, [GTKWave](http://gtkwave.sourceforge.net/)

## Build process

For build this image, you need [Docker](https://www.docker.com/) installed on a Linux based operating system (or [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10), etc), and perform the following command:

```docker build -t vmunoz82/eda_tools .```

This will download and compile the list of tools listed above, and will take some time (~1 hour on my 4 cores i7-6600U laptop).

Of course you can pull the pre-compiled image from the [hub.docker.com](https://hub.docker.com/) register with this:

```docker pull vmunoz82/eda_tools```

Which is a lot faster.

If you want to build some specific commit version of certain tool you can easily tell to the building process to do so [setting the building args variables](https://docs.docker.com/engine/reference/commandline/build/).

Example, if you want to force the nMigen version to , you have to do:

```docker build --build-arg NMIGEN_COMMIT=v0.2 -t vmunoz82/eda_tools .```

The list of all available build arguments variables are:

 * *YOSYS_COMMIT*
 * *SYMBIYOSYS_COMMIT*
 * *Z3_COMMIT*
 * *BOOLECTOR_COMMIT*
 * *YICES2_COMMIT*
 * *ICESTORM_COMMIT*
 * *NEXTPNR_ICE40_COMMIT*
 * *TRELLIS_COMMIT*
 * *NEXTPNR_ECP5_COMMIT*
 * *NMIGEN_COMMIT*
 * *NMIGEN_BOARDS_COMMIT*

All of them use the last master commit by default.

When you have an already created image, you can query the build arguments passed during the build-time with

```docker inspect -f {{.Config.Labels}} vmunoz82/eda_tools```

Or see the actual pulled commits during build-time from the files in the `/usr/local/commits directory.`

## Usage

The idea of having the whole software stack inside a Docker image is to have an independent platform, so having the chance of work inside it without depend on the host system at all. That's why even the Vim editor is inside, of course you are free to change the properline in the Dockerfile to add your favorite editor/IDE.

The simplest way to use it is 

```
docker run --rm -ti vmunoz82/eda_tools
```

Which tells Docker to run in interactive mode the default entrypoint (*/bin/bash*), with the default user (*root*), on the default working directory (*/workspace*).

Of course this probably don't fit your needs, but you need to change these default values to accommodate to your own needs, for example:

```
docker run --rm --v $HOME/workspace:/workspace -ti vmunoz82/eda_tools
```

Will mount $HOME/workspace host directory on the /workspace directory inside the container, so everything you write there will survive among invocations.

For the purpose of make the usage easy for you, I have create an script named `eda_tools.sh` that contains the follow:

```
docker run --rm \                  # don't leave a volume on exit the container execution.
--user $(id -u):$(id -g) \         # use the same host user/group id.
-v /etc/passwd:/etc/passwd:ro \    # make available the current user list (read-only).
-v /etc/group:/etc/group:ro  \     # make available the current group list (read-only).
-v /tmp/.X11-unix:/tmp/.X11-unix \ # make X available (for gtkwave).
-e DISPLAY=$DISPLAY \              # make DISPLAY varible available.
-v $HOME:/$HOME \                  # map host home to container home.
-w $PWD \                          # be in the same dir as the caller place.
-ti  vmunoz82/eda_tools            # our EDA Tools Docker image.
```

There is all explained in the comments, it invokes the container passing your home directory, your user id, your graphic environment to have a seamless experience.
