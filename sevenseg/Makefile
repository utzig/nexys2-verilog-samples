SRC = stopwatch.v sevenseg.v

CLEAN = sevenseg.bgn sevenseg.drc sevenseg.mrp sevenseg.ngd sevenseg.pcf \
	sevenseg.bld sevenseg.lso stopwatch.lso sevenseg.ncd sevenseg.ngm sevenseg.srp \
	sevenseg.bit sevenseg_signalbrowser.* sevenseg-routed_pad.tx \
	sevenseg.map sevenseg_summary.xml timing.twr \
	sevenseg-routed* sevenseg_usage* sevenseg.ngc param.opt netlist.lst \
	xst sevenseg.prj sevenseg*.xrpt smartpreview.twr sevenseg.svf _impactbatch.log

all: sevenseg.bit

sevenseg.prj: $(SRC)
	rm -f sevenseg.prj
	@for i in `echo $^`; do \
	    echo "verilog worlk $$i" >> sevenseg.prj; \
	done

sevenseg.ngc: sevenseg.prj
	xst -ifn sevenseg.xst

sevenseg.ngd: sevenseg.ngc sevenseg.ucf
	ngdbuild -uc sevenseg.ucf sevenseg.ngc

sevenseg.ncd: sevenseg.ngd
	map sevenseg.ngd

sevenseg-routed.ncd: sevenseg.ncd
	par -ol high -w sevenseg.ncd sevenseg-routed.ncd

sevenseg.bit: sevenseg-routed.ncd
	bitgen -w sevenseg-routed.ncd sevenseg.bit

upload:
	djtgcfg prog -d Nexys2 -i 1 -f sevenseg.bit

clean:
	rm -Rf $(CLEAN)

.PHONY: clean view
