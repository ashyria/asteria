CC := gcc
CFLAGS = -O0 -Wall -g -ggdb -std=gnu99 -pedantic -Werror -I./src/ -I/usr/include/lua5.1
LFLAGS = -lz -lpthread -lcrypt -lm -llua -ldl
SRC_DIR := src
BUILD_DIR := build
LUAC := luac
SCRIPTS_SOURCE_DIR := scripts
SCRIPTS_OUTPUT_DIR := scripts/compiled
EXE := asteria

# Find all .c files in subdirectories.
SRC := $(shell find $(SRC_DIR) -type f -name '*.c')
OBJ := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(SRC))

all: $(EXE) $(SCRIPTS_OUTPUT_DIR)/startup.luac $(SCRIPTS_OUTPUT_DIR)/base_functions.luac

$(EXE): $(OBJ)
	@mkdir -p $(BUILD_DIR)
	@echo "Linking $(EXE) ...\n"
	@$(CC) $(CFLAGS) -o $@ $^ $(LFLAGS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	@echo "Compiling $< ..."
	@$(CC) $(CFLAGS) -c -o $@ $<

$(SCRIPTS_OUTPUT_DIR)/%.luac:  $(SCRIPTS_SOURCE_DIR)/%.lua
	@mkdir -p $(@D)
	@echo "Compiling Lua $< ..."
	@$(LUAC) -o $@ $<

clean:
	rm -rf $(BUILD_DIR)
	rm -f asteria
	rm -f core*
	rm -f copyover.*

# Disable built-in rules and variables.
.SUFFIXES:
