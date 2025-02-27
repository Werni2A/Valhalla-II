
# Use Docker images
# DOCKER = docker
DOCKER = podman

DOCKERARGS = run --rm -v /"$(PWD)"://wrk -w //wrk

GHDL           = $(DOCKER) $(DOCKERARGS) docker.io/hdlc/ghdl:yosys ghdl
GHDLSYNTH      = ghdl
YOSYS          = $(DOCKER) $(DOCKERARGS) docker.io/hdlc/ghdl:yosys yosys
NEXTPNR        = $(DOCKER) $(DOCKERARGS) docker.io/hdlc/nextpnr:ice40 nextpnr-ice40
ICEPACK        = $(DOCKER) $(DOCKERARGS) docker.io/hdlc/icestorm:latest icepack
ICETIME        = $(DOCKER) $(DOCKERARGS) docker.io/hdlc/icestorm:latest icetime
ICEPROG        = $(DOCKER) $(DOCKERARGS) --device /dev/bus/usb docker.io/hdlc/prog:latest iceprog
OPENFPGALOADER = $(DOCKER) $(DOCKERARGS) --device /dev/bus/usb docker.io/hdlc/openfpgaloader:latest openFPGALoader

# Parameters
PROJ ?= counter
PIN_DEF = constraints/alhambra2.pcf
DEVICE  = hx4k
PACKAGE = tq144

STYLE   = style/my_style.yaml

TOPLVL   = TOP
GHDLARGS = --std=08

SRC += src/top.vhdl
SRC += src/counter.vhdl

all: build/$(PROJ).bit

build/$(PROJ).json: $(SRC)
	mkdir -p build
	$(YOSYS) -m $(GHDLSYNTH) -p 'ghdl $(GHDLARGS) $^ -e $(TOPLVL); synth_ice40 -json $@'

build/$(PROJ).asc: $(PIN_DEF) build/$(PROJ).json
	$(NEXTPNR) --$(DEVICE) --json build/$(PROJ).json --pcf $(PIN_DEF) --asc $@ --placed-svg build/placement.svg --routed-svg build/routing.svg

build/$(PROJ).bit: build/$(PROJ).asc
	$(ICEPACK) $< $@

report: build/$(PROJ).asc
	$(ICETIME) -d $(DEVICE) -p $(PIN_DEF) -P $(PACKAGE) -mtr build/timing.txt $<

prog: build/$(PROJ).bit
	# $(ICEPROG) -d i:0x0403:0x6010:0 $<
	$(OPENFPGALOADER) --board ice40_generic $<

clean:
	rm -rf build
	rm -f work-obj*.cf

format: $(SRC)
	vsg -f $^ -c $(STYLE) --fix


.PHONY: all clean format prog report
.PRECIOUS: build/$(PROJ).json build/$(PROJ).bit