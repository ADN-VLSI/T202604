build:
	@mkdir -p build
	@echo "*" > build/.gitignore

.PHONY: run
run:
	@make -s build
	@cd build && xvlog -sv ../my_module.sv
	@cd build && xelab my_module -s qwer
	@cd build && xsim qwer -runall

.PHONY: clean
clean:
	@rm -rf build
