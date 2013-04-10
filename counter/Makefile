SRC = counter.v

CLEAN = counter.bgn counter.drc counter.mrp counter.ngd counter.pcf \
	counter.bld counter.lso counter.ncd counter.ngm counter.srp \
	counter.bit counter_signalbrowser.* counter-routed_pad.tx \
	counter.map counter_summary.xml timing.twr \
	counter-routed* counter_usage* counter.ngc param.opt netlist.lst \
	xst counter.prj counter*.xrpt smartpreview.twr counter.svf _impactbatch.log

all: counter.bit

counter.prj: $(SRC)
	rm -f counter.prj
	@for i in `echo $^`; do \
	    echo "verilog worlk $$i" >> counter.prj; \
	done

counter.ngc: counter.prj
	xst -ifn counter.xst

counter.ngd: counter.ngc counter.ucf
	ngdbuild -uc counter.ucf counter.ngc

counter.ncd: counter.ngd
	map counter.ngd

counter-routed.ncd: counter.ncd
	par -ol high -w counter.ncd counter-routed.ncd

counter.bit: counter-routed.ncd
	bitgen -w counter-routed.ncd counter.bit

upload:
	djtgcfg prog -d Nexys2 -i 1 -f counter.bit

clean:
	rm -Rf $(CLEAN)

.PHONY: clean view
