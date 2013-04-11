SRC = vga_controller.v vga.v

CLEAN = vga.bgn vga.drc vga.mrp vga.ngd vga.pcf \
	vga.bld vga.lso stopwatch.lso vga.ncd vga.ngm vga.srp \
	vga.bit vga_signalbrowser.* vga-routed_pad.tx \
	vga.map vga_summary.xml timing.twr \
	vga-routed* vga_usage* vga.ngc param.opt netlist.lst \
	xst vga.prj vga*.xrpt smartpreview.twr vga.svf _impactbatch.log

all: vga.bit

vga.prj: $(SRC)
	rm -f vga.prj
	@for i in `echo $^`; do \
	    echo "verilog worlk $$i" >> vga.prj; \
	done

vga.ngc: vga.prj
	xst -ifn vga.xst

vga.ngd: vga.ngc vga.ucf
	ngdbuild -uc vga.ucf vga.ngc

vga.ncd: vga.ngd
	map vga.ngd

vga-routed.ncd: vga.ncd
	par -ol high -w vga.ncd vga-routed.ncd

vga.bit: vga-routed.ncd
	bitgen -w vga-routed.ncd vga.bit

upload:
	djtgcfg prog -d Nexys2 -i 1 -f vga.bit

clean:
	rm -Rf $(CLEAN)

.PHONY: clean view
