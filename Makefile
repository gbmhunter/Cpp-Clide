# Define the compiler to use (e.g. gcc, g++)
CC = g++

# Define any compile-time flags (e.g. -Wall, -g)
CFLAGS = -Wall -g

# Define any directories containing header files other than /usr/include.
# Prefix every directory with "-I" e.g. "-I./src/include"
INCLUDES = -I./src/include

# Define library paths in addition to /usr/lib
# if I wanted to include libraries not in /usr/lib I'd specify
# their path using -Lpath, something like:
LFLAGS = -L./test/UnitTest++

# Define any libraries to link into executable:
#   if I want to link in libraries (libx.so or libx.a) I use the -llibname 
#   option, something like (this will link in libmylib.so and libm.so:
LIBS = -lUnitTest++

SRC_CPP_FILES := $(wildcard src/*.cpp)
SRC_OBJ_FILES := $(addprefix obj/,$(notdir $(SRC_CPP_FILES:.cpp=.o)))
SRC_LD_FLAGS := 
SRC_CC_FLAGS := -Wall -g

TEST_CPP_FILES := $(wildcard test/*.cpp)
TEST_OBJ_FILES := $(addprefix obj/,$(notdir $(TEST_CPP_FILES:.cpp=.o)))
TEST_LD_FLAGS := 
TEST_CC_FLAGS := -Wall -g


.PHONY: depend clean

# All
all: ClideLib Test
	
	# Run unit tests:
	@./test/ClideTest.out

ClideLib : ./src/Clide-Cmd.o ./src/Clide-Param.o ./src/Clide-Option.o ./src/Clide-Tx.o ./src/Clide-Rx.o ./src/MemMang.o ./src/PowerString-Split.o
	# Make Clide library
	ar r libClide.a ./src/Clide-Cmd.o ./src/Clide-Param.o ./src/Clide-Option.o ./src/Clide-Tx.o ./src/Clide-Rx.o ./src/MemMang.o ./src/PowerString-Split.o
	
# Compiles unit test code
Test : ./test/ClideTest.o | ClideLib UnitTestLib
	# Compiling unit test code
	#g++ $(TEST_LD_FLAGS) -o $@ $^ -L./test/UnitTest++ -lUnitTest++
	g++ $(TEST_LD_FLAGS) -o ./test/ClideTest.out ./test/ClideTest.o -L./test/UnitTest++ -lUnitTest++ -L./ -lClide
	
	# Run unit tests:
	@./test/ClideTest.out

# Generic rule for src object files
obj/%.o: src/%.cpp
	# Compiling src2
	g++ $(SRC_CC_FLAGS) -c -o $@ $<
	
# Generic rule for test object files
obj/%.o: test/%.cpp
	#g++ $(TEST_CC_FLAGS) -c -o $@ $<
	
UnitTestLib:
	# Compile UnitTest++ library (has it's own Makefile)
	$(MAKE) -C ./test/UnitTest++/ all
	
clean:
	# Clean UnitTest++ library (has it's own Makefile)
	$(MAKE) -C ./test/UnitTest++/ clean
	
	# Clean everything else
	@echo " Cleaning..."; $(RM) *.o *~
	@echo " Cleaning..."; $(RM) ./obj/*
