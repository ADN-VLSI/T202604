# Minimal Makefile
VLOG = iverilog -g2012
SRC = async_fifo_core.sv top_tb.sv
OUT = sim.out

run:
	$(VLOG) -o $(OUT) $(SRC)
	vvp $(OUT)

clean:
	rm -f $(OUT)