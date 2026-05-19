# Variables
SIM = iverilog
FLAGS = -g2012
TARGET = regif_sim
SRC = regif.sv regif_tb.sv

# Default rule: Compile and Run
all: compile run

compile:
	$(SIM) $(FLAGS) -o $(TARGET) $(SRC)

run:
	vvp $(TARGET)

clean:
	rm -f $(TARGET)