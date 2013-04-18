SRC = test.v uart.v

CLEAN = uart.bgn uart.drc uart.mrp uart.ngd uart.pcf \
	uart.bld uart.lso stopwatch.lso uart.ncd uart.ngm uart.srp \
	uart.bit uart_signalbrowser.* uart-routed_pad.tx \
	uart.map uart_summary.xml timing.twr \
	uart-routed* uart_usage* uart.ngc param.opt netlist.lst \
	xst uart.prj uart*.xrpt smartpreview.twr uart.svf _impactbatch.log

all: uart.bit

uart.prj: $(SRC)
	rm -f uart.prj
	@for i in `echo $^`; do \
	    echo "verilog worlk $$i" >> uart.prj; \
	done

uart.ngc: uart.prj
	xst -ifn uart.xst

uart.ngd: uart.ngc nexys2.ucf
	ngdbuild -uc nexys2.ucf uart.ngc

uart.ncd: uart.ngd
	map uart.ngd

uart-routed.ncd: uart.ncd
	par -ol high -w uart.ncd uart-routed.ncd

uart.bit: uart-routed.ncd
	bitgen -w uart-routed.ncd uart.bit

upload:
	djtgcfg prog -d Nexys2 -i 0 -f uart.bit

clean:
	rm -Rf $(CLEAN)

.PHONY: clean view
