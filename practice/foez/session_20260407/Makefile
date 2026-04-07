# Here PG is a variable that can be set when invoking make, e.g., `make run PG=p1`

# .c files are human readable source code
# .o files are compiled object files that can be executed

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

# compile source/PG.c to build/PG.o
build/${PG}.o:
	@echo "Compiling ${PG}.c..."
	@make -s build
	@cp source/${PG}.c build/${PG}.c
	@gcc build/${PG}.c -o build/${PG}.o

# run the compiled program and save output to log/PG.log
.PHONY: run
run:
	@make -s build/${PG}.o PG=${PG}
	@make -s log
	@./build/${PG}.o > log/${PG}.log
