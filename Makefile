export SHELL=/bin/bash

ROOT_DIR:=$(CURDIR)
BUILD_DIR:=$(ROOT_DIR)/build
LOG_DIR:=$(ROOT_DIR)/log

TN := default
TL := 50

GUI := 0

VCS = vcs
SIMV = ./simv

EW_HL = | grep -iE "error:|warning:|" --color=auto

VCS_FLAGS += -full64
VCS_FLAGS += -sverilog
VCS_FLAGS += -timescale=1ns/1ps
VCS_FLAGS += -debug_access+all
VCS_FLAGS += -kdb
VCS_FLAGS += -lca

VCS_FLAGS += +define+DEFAULT_ADDR_WIDTH=5
VCS_FLAGS += +define+DEFAULT_DATA_WIDTH=32

VCS_FLAGS += +incdir+$(ROOT_DIR)/include
VCS_FLAGS += +incdir+$(ROOT_DIR)/tb

# Uncomment if your VCS installation does not automatically provide UVM
# VCS_FLAGS += -ntb_opts uvm

SIM_FLAGS += +TEST_NAME=$(TN)
SIM_FLAGS += +TEST_LEN=$(TL)

ifeq ($(GUI),1)
SIM_FLAGS += -gui
endif

$(BUILD_DIR) $(LOG_DIR):
	@mkdir -p $@
	@echo "*" > $@/.gitignore

.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR) $(LOG_DIR)

.PHONY: env_build
env_build:
ifeq ($(TOP),)
	@echo "Error: TOP module is not specified." && exit 1
endif
	@make -s clean
	@make -s $(BUILD_DIR) $(LOG_DIR)

	@echo "$(shell find $(ROOT_DIR)/submodule/apb-uart/intf -name "*.sv")" > $(BUILD_DIR)/filelist.f
	@echo "$(shell find $(ROOT_DIR)/source -name "*.sv")" >> $(BUILD_DIR)/filelist.f
	@echo "$(shell find $(ROOT_DIR)/tb -maxdepth 1 -name "*.sv")" >> $(BUILD_DIR)/filelist.f

	@cd $(BUILD_DIR) && \
	$(VCS) $(VCS_FLAGS) \
	-top $(TOP) \
	-f filelist.f \
	-o simv \
	-l $(LOG_DIR)/vcs_$(TOP)_$(shell date +%Y%m%d_%H%M%S).log \
	$(EW_HL)

.PHONY: sim
sim:
	@cd $(BUILD_DIR) && \
	$(SIMV) $(SIM_FLAGS) \
	-l $(LOG_DIR)/simv_$(TOP)_$(shell date +%Y%m%d_%H%M%S).log \
	$(EW_HL)

.PHONY: all
all:
	@make -s env_build TOP=$(TOP)
	@make -s sim TOP=$(TOP) TN=$(TN) TL=$(TL) GUI=$(GUI)

.PHONY: uvm
uvm:
	@make -s all TOP=uvm_tb

.PHONY: layered_tb
layered_tb:
	@make -s all TOP=layered_tb
