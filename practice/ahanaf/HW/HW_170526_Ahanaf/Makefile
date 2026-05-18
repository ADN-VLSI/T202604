build:
	@mkdir -p build
	@echo "*" > build/.gitignore

.PHONY: run
run:
	@make -s build
	@cd build && xvlog -sv ../regif.sv
	@cd build && xelab tb_regif -s qwer
	@cd build && xsim qwer -runall
.PHONY: clean
clean:
	@rm -rf build

.PHONY: all
all:
	@make -s clean
	@make -s run