# create build or log directory if it doesn't exist
build log:
	@echo "Creating $@ directory..."
	@mkdir -p $@
	@echo "*" > $@/.gitignore

# remove build  & log directory and its contents
.PHONY: clean
clean:
	@echo "Cleaning up build and log directories..."
	@rm -rf build log

build/${PG}.o:
	@echo "Compiling ${PG}.c..."
	@make -s build
	@cp source/${PG}.c build/${PG}.c
	@gcc build/${PG}.c -o build/${PG}.o

.PHONY: run
run:
	@make -s build/${PG}.o PG=${PG}
	@make -s log
	@./build/${PG}.o > log/${PG}.log

# # compile p1.c into an executable
# build/${PG}.exe: source/${PG}.c
# 	@make -s build
# 	@echo "Compiling ${PG}.c..."
# 	@gcc source/${PG}.c -o build/${PG}.exe

# # run the ${PG} executable
# .PHONY: run
# run: 
# 	@make -s PG=${PG} build/${PG}.exe
# 	@./build/${PG}.exe

# all:
# 	@$(foreach file, $(shell find source -name "*.c" | sed "s/.*\///g" | sed "s/\..*//g" ), make -s run PG=$(file);)
