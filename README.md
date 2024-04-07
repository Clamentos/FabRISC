# FabRISC ISA

**This the official repository for the FabRISC project.**

FabRISC is an open-source, modular, RISC-like instruction set architecture for 32 and 64 bit microprocessors (8 and 16-bit are also possible too). Some features of this specifications are:

- Variable length instructions of 2, 4 and 6 bytes.
- Scalar and vector capabilities.
- Atomic and transactional memory support.
- Privileged architecture with user and machine modes.
- Classically virtualizable.
- Performance monitoring counters and more!

## Compiling from source

This repository simply holds the [Typst](https://github.com/typst/typst) source code to generate the PDF documents for the privileged and unprivileged specifications. Currently, only the unprivileged specification is close to being complete. The steps to compile are very simple and all is needed is to compile the `Main.typ` file in the `./src/unprivileged` directory and run the following comand:

> typst compile Main.typ --root ../

#### Disclaimer

This is just a personal project used as a learning experience so don't expect anything ground breaking, however any kind of feedback is absolutely welcome and needed!
