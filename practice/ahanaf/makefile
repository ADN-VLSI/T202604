build:
	@mkdir -p build
	@echo "*" > build/.gitignore

.PHONY:  run

run: build
	@make -s build
	@cd build && xvlog -sv ../hw_10.sv
	@cd build && xelab hw_10 -s qwer
	@cd build && xsim qwer -runall

.PHONY: clean
clean:
	@rm -rf xsim.dir *log *jou *.pb
