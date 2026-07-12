export SHELL=/bin/bash

ROOT_DIR:=$(CURDIR)
BUILD_DIR:=$(ROOT_DIR)/build
LOG_DIR:=$(ROOT_DIR)/log

TN := default
TL := 50

EW_HL = | grep -iE "error:|warning:|" --color=auto

GUI := 0
ifeq ($(GUI),0)
	XSIM_CMD += -runall
else
	XSIM_CMD += -gui --autoloadwcfg --view ../wcfg/snap_$(TOP).wcfg
endif

XSIM_CMD += --testplusarg TEST_NAME=$(TN)
XSIM_CMD += --testplusarg TEST_LEN=$(TL)

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
	@echo "-sv" > $(BUILD_DIR)/xvlog_cmd
	@echo "-d DEFAULT_ADDR_WIDTH=5" >> $(BUILD_DIR)/xvlog_cmd
	@echo "-d DEFAULT_DATA_WIDTH=32" >> $(BUILD_DIR)/xvlog_cmd
	@echo "-i $(ROOT_DIR)/include" >> $(BUILD_DIR)/xvlog_cmd
	@echo "-i $(ROOT_DIR)/tb" >> $(BUILD_DIR)/xvlog_cmd
	@echo "$(shell find $(ROOT_DIR)/submodule/apb-uart/intf -name "*.sv")" >> $(BUILD_DIR)/xvlog_cmd
	@echo "$(shell find $(ROOT_DIR)/source -name "*.sv")" >> $(BUILD_DIR)/xvlog_cmd
	@echo "$(shell find $(ROOT_DIR)/tb -maxdepth 1 -name "*.sv")" >> $(BUILD_DIR)/xvlog_cmd
	@echo "-L uvm" >> $(BUILD_DIR)/xvlog_cmd
	@cd $(BUILD_DIR) && xvlog -f $(BUILD_DIR)/xvlog_cmd -log $(LOG_DIR)/xvlog_$(shell date +%Y%m%d_%H%M%S).log $(EW_HL)
	@cd $(BUILD_DIR) && xelab -debug all $(TOP) -s snap_$(TOP) -log $(LOG_DIR)/xelab_$(TOP)_$(shell date +%Y%m%d_%H%M%S).log $(EW_HL)

.PHONY: sim
sim:
	@echo "$(XSIM_CMD)" > $(BUILD_DIR)/xsim_cmd
	@cd $(BUILD_DIR) && xsim snap_$(TOP) -f $(BUILD_DIR)/xsim_cmd -log $(LOG_DIR)/xsim_$(TOP)_$(shell date +%Y%m%d_%H%M%S).log $(EW_HL)

.PHONY: all
all:
	@make -s env_build TOP=$(TOP)
	@make -s sim TOP=$(TOP) TN=$(TN) TL=$(TL) GUI=$(GUI)

.PHONY: uvm
uvm:
	@make -s all TOP=uvm_tb TN=$(TN) TL=$(TL) GUI=$(GUI)

.PHONY: layered_tb
layered_tb:
	@make -s all TOP=layered_tb TN=$(TN) TL=$(TL) GUI=$(GUI)
