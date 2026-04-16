build:
	@mkdir -p build
	@echo "*" > build/.gitignore


.PHONY: run
run:
	@make -s build
	@cd build && xvlog -sv ../practice_10.sv
	@cd build && xelab practice_1 -s qwer
	@cd build && xsim qwer -runall

.PHONY: clean
clean:
	@rm -rf build
