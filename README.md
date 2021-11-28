
# Valhalla II

This is a Hello-World project for open-source VHDL synthesis on the [Alhambra II](https://github.com/FPGAwars/Alhambra-II-FPGA) FPGA (iCE40 HX4k) board. Further information on the development board can be found on the official webpage of [Alhambra Bits](https://alhambrabits.com/alhambra/).

Main purpose of this repository is to quickly get you started without the hassle of setting up the tool-chain yourself. For that reason, the necessary tools are provided via a Docker image over the internet. When running the script for the first time, Docker will download the required images and uses the tools from within the image. As a result, the tool versions should be relatively up-to-date, further it is not necessary to install the tool-chain on your real machine.

# Get Started

1. Clone this repository
2. Connect your Alhambra II board via the USB port (use the one marked with `PC` on the PCB) with your computer
3. Start a terminal within this repository
4. Call `make prog` which generates the ICE40 bitstream for the exemplary counter in `src` and programs your Alhambra II board.
5. Take a look at your development board, that shows the state of a binary counter on the board's LEDs, counting up every 500 ms.

# Commands

- `make` Generates the ICE40 bitstream (runs synthesis, place and rout, and bitstream generation)
- `make prog` Generates the bitstream and programs the device, when connected via USB
- `make clean` removes `build` folder of the design
- `./format.sh` Optimizes the style of the VHDL code

# Dependencies

Most dependencies are provided by the Docker images, therefore you do not need to install them yourself.

- Optional: [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) for VHDL code formatting

# Thanks

The content in this repository is largely based on examples from [ghdl-yosys-plugin](https://github.com/ghdl/ghdl-yosys-plugin) and the similar ECP5 flow in [ghdl-yosys-blink](https://github.com/antonblanchard/ghdl-yosys-blink), therefore a big thanks to those projects and their maintainers.
