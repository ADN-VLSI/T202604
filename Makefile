export SHELL=/bin/bash

ROOT_DIR:=$(CURDIR)
BUILD_DIR:=$(ROOT_DIR)/build
LOG_DIR:=$(ROOT_DIR)/log

EW_HL = | grep -iE "error:|warning:|" --color=auto

GUI := 0
ifeq ($(GUI),0)
	XSIM_CMD += -runall
else
	XSIM_CMD += -gui --autoloadwcfg --view ../wcfg/snap_$(TOP).wcfg
endif

$(BUILD_DIR) $(LOG_DIR):
	@mkdir -p $@
	@echo "*" > $@/.gitignore

.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR) $(LOG_DIR)

.PHONY: all
all:
ifeq ($(TOP),)
	@echo "Error: TOP module is not specified." && exit 1
endif
	@make -s clean
	@make -s $(BUILD_DIR) $(LOG_DIR)
	@echo "-sv" > $(BUILD_DIR)/xvlog_cmd
	@echo "-d DEFAULT_ADDR_WIDTH=5" >> $(BUILD_DIR)/xvlog_cmd
	@echo "-d DEFAULT_DATA_WIDTH=32" >> $(BUILD_DIR)/xvlog_cmd
	@echo "-i $(ROOT_DIR)/include" >> $(BUILD_DIR)/xvlog_cmd
	@echo "$(shell find $(ROOT_DIR)/submodule/apb-uart/intf -name "*.sv")" >> $(BUILD_DIR)/xvlog_cmd
	@echo "$(shell find $(ROOT_DIR)/source -name "*.sv")" >> $(BUILD_DIR)/xvlog_cmd
	@echo "$(shell find $(ROOT_DIR)/tb -name "*.sv")" >> $(BUILD_DIR)/xvlog_cmd
	@echo "-L uvm" >> $(BUILD_DIR)/xvlog_cmd
	@cd $(BUILD_DIR) && xvlog -f $(BUILD_DIR)/xvlog_cmd -log $(LOG_DIR)/xvlog_$(shell date +%Y%m%d_%H%M%S).log $(EW_HL)
	@cd $(BUILD_DIR) && xelab -debug all $(TOP) -s snap_$(TOP) -log $(LOG_DIR)/xelab_$(TOP)_$(shell date +%Y%m%d_%H%M%S).log $(EW_HL)
	@cd $(BUILD_DIR) && xsim snap_$(TOP) $(XSIM_CMD) -log $(LOG_DIR)/xsim_$(TOP)_$(shell date +%Y%m%d_%H%M%S).log $(EW_HL)

.PHONY: uvm
uvm:
	@make -s all TOP=uvm_tb