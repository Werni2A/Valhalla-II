
# Use local tools
# GHDL       = ghdl
# GHDLSYNTH  = ghdl.so
# YOSYS      = yosys
# NEXTPNR    = nextpnr-ice40
# PACK       = icepack
# TIME       = icetime
# ICEPROG    = iceprog
# OPENOCD    = openocd
# OPENFPGALOADER = openFPGALoader

# Use Docker images
DOCKER = docker
# DOCKER = podman

DOCKERARGS=run --rm -v /"$(PWD)"://wrk -w //wrk

GHDL      = $(DOCKER) $(DOCKERARGS) ghdl/synth:beta ghdl
GHDLSYNTH = ghdl
YOSYS     = $(DOCKER) $(DOCKERARGS) ghdl/synth:beta yosys
NEXTPNR   = $(DOCKER) $(DOCKERARGS) ghdl/synth:nextpnr nextpnr-ice40
PACK      = $(DOCKER) $(DOCKERARGS) ghdl/synth:icestorm icepack
TIME      = $(DOCKER) $(DOCKERARGS) ghdl/synth:icestorm icetime
ICEPROG   = $(DOCKER) $(DOCKERARGS) --device /dev/bus/usb gcr.io/hdl-containers/prog:latest iceprog
OPENOCD        = $(DOCKER) $(DOCKERARGS) --device /dev/bus/usb ghdl/synth:prog openocd
OPENFPGALOADER = $(DOCKER) $(DOCKERARGS) --device /dev/bus/usb gcr.io/hdl-containers/openfpgaloader:latest openFPGALoader

# ICE40-HX4K
PROJ ?= counter
GHDL_GENERICS =
PIN_DEF = constraints/alhambra2.pcf
DEVICE  = hx4k
PACKAGE = tq144
# OPENOCD_JTAG_CONFIG   = openocd/ecp5-evn.cfg
# OPENOCD_DEVICE_CONFIG = openocd/LFE5UM5G-85F.cfg

all: $(PROJ).bit report

$(PROJ).json: src/$(PROJ).vhdl
	mkdir -p build
	$(YOSYS) -m $(GHDLSYNTH) -p 'ghdl src/counter.vhdl src/top.vhdl -e top; synth_ice40 -json build/$(PROJ).json'

$(PROJ).asc: $(PIN_DEF) $(PROJ).json
	$(NEXTPNR) --$(DEVICE) --json build/$(PROJ).json --pcf $(PIN_DEF) --asc build/$(PROJ).asc --placed-svg build/placement.svg --routed-svg build/routing.svg

$(PROJ).bit: $(PROJ).asc
	$(PACK) build/$(PROJ).asc build/$(PROJ).bin

report: $(PROJ).asc
	$(TIME) -d $(DEVICE) -p $(PIN_DEF) -P $(PACKAGE) -mtr build/$(PROJ)_timing.txt build/$(PROJ).asc

$(PROJ).svf: $(PROJ).bit

prog: $(PROJ).svf
	# $(ICEPROG) -d i:0x0403:0x6010:0 build/$(PROJ).bin
	# $(OPENOCD) -f $(OPENOCD_JTAG_CONFIG) -f $(OPENOCD_DEVICE_CONFIG) -c "transport select jtag; init; svf build/$(PROJ).svf; exit"
	$(OPENFPGALOADER) -b ice40_generic build/$(PROJ).bin

clean:
	rm -rf build

.PHONY: all clean prog
.PRECIOUS: $(PROJ).json $(PROJ).config $(PROJ).bit