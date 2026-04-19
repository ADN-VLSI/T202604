build:
	@echo "Creating build directory..."
	@mkdir -p build
	@echo "*" > build/.gitignore 

.PHONY: run
run_1:
	@make -s build
	@cd build && xvlog -sv ../Practice/display_example.sv # xvlog is for linux system,and xvlog.exe for windows
	@cd build && xelab display_example -s qwer
	@cd build && xsim qwer -runall

run_2:
	@make -s build
	@cd build && xvlog -sv ../Practice/monitor_example.sv
	@cd build && xelab monitor_example -s qwer
	@cd build && xsim qwer -runall

run_3:
	@make -s build
	@cd build && xvlog -sv ../Practice/strobe_example.sv
	@cd build && xelab strobe_example -s qwer
	@cd build && xsim qwer -runall

run_4:
	@make -s build
	@cd build && xvlog -sv ../Practice/dumpfile_example.sv
	@cd build && xelab dumpfile_example -s qwer
	@cd build && xsim qwer -runall

run_5:
	@make -s build
	@cd build && xvlog -sv ../Practice/dumpvars_example.sv
	@cd build && xelab dumpvars_example -s qwer
	@cd build && xsim qwer -runall

run_6:
	@make -s build
	@cd build && xvlog -sv ../Practice/time_example.sv
	@cd build && xelab time_example -s qwer
	@cd build && xsim qwer -runall

run_7:
	@make -s build
	@cd build && xvlog -sv ../Practice/stime_example.sv
	@cd build && xelab time_example -s qwer
	@cd build && xsim qwer -runall

run_8:
	@make -s build
	@cd build && xvlog -sv ../Practice/realtime_example.sv
	@cd build && xelab time_example -s qwer
	@cd build && xsim qwer -runall

run_9:
	@make -s build
	@cd build && xvlog -sv ../Practice/finish_example.sv
	@cd build && xelab finish_example -s qwer
	@cd build && xsim qwer -runall

run_10:
	@make -s build
	@cd build && xvlog -sv ../Practice/stop_example.sv
	@cd build && xelab stop_example -s qwer
	@cd build && xsim qwer -runall

run_11:
	@make -s build
	@cd build && xvlog -sv ../Practice/exit_example.sv
	@cd build && xelab exit_example -s qwer
	@cd build && xsim qwer -runall


.PHONY: clean
clean:
	@rm -rf build
	@echo "Cleaned build directory."