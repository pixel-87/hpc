# ============================================================================
# HPC Coursework Makefile - C with OpenMP Support
# ============================================================================

PREFIX ?= /usr/local
BIN_DIR ?= $(PREFIX)/bin

# Project configuration
TARGET_EXEC ?= advection2D
BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

# Find all C source files (no C++ for this project)
SRCS := $(shell find $(SRC_DIRS) -name '*.c')
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

# Include directories
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# Compiler and flags
CC := gcc
CPPFLAGS := $(INC_FLAGS) -MMD -MP

# Base C flags
CFLAGS_BASE := -std=c99 -Wall -Wextra -pedantic

# OpenMP flag for parallelization
OPENMP_FLAG := -fopenmp

# Math library
LDFLAGS := -lm

# Build modes
CFLAGS_DEBUG := $(CFLAGS_BASE) -g -O0 -DDEBUG
CFLAGS_RELEASE := $(CFLAGS_BASE) -O3 -march=native -DNDEBUG
CFLAGS_PROFILE := $(CFLAGS_BASE) -g -O2 -pg

# Default to release build
CFLAGS ?= $(CFLAGS_RELEASE)

# ============================================================================
# Build Targets
# ============================================================================

.PHONY: all clean install run debug release openmp check format help

# Default target
all: $(BUILD_DIR)/$(TARGET_EXEC)

# Main executable (serial version)
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)
	@echo "✓ Built: $@"

# OpenMP parallel version
openmp: CFLAGS += $(OPENMP_FLAG)
openmp: LDFLAGS += $(OPENMP_FLAG)
openmp: clean $(BUILD_DIR)/$(TARGET_EXEC)
	@echo "✓ Built with OpenMP support"

# Debug build
debug: CFLAGS = $(CFLAGS_DEBUG)
debug: clean $(BUILD_DIR)/$(TARGET_EXEC)
	@echo "✓ Debug build complete"

# Release build (optimized)
release: CFLAGS = $(CFLAGS_RELEASE)
release: clean $(BUILD_DIR)/$(TARGET_EXEC)
	@echo "✓ Release build complete"

# Profile build
profile: CFLAGS = $(CFLAGS_PROFILE)
profile: LDFLAGS += -pg
profile: clean $(BUILD_DIR)/$(TARGET_EXEC)
	@echo "✓ Profile build complete (use gprof to analyze)"

# ============================================================================
# Compilation Rules
# ============================================================================

# C source compilation
$(BUILD_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# ============================================================================
# Static Analysis & Code Quality
# ============================================================================

# Run cppcheck static analysis
check:
	@echo "Running cppcheck..."
	@cppcheck --enable=all --std=c99 --suppress=missingIncludeSystem $(SRC_DIRS)

# Run clang-tidy linting
lint:
	@echo "Running clang-tidy..."
	@clang-tidy $(SRCS) -- $(INC_FLAGS) -std=c99

# Format code with clang-format
format:
	@echo "Formatting code..."
	@clang-format -i $(SRCS)

# Alternative: format with astyle
format-astyle:
	@echo "Formatting code with astyle..."
	@astyle --style=linux --indent=spaces=2 $(SRCS)

# ============================================================================
# Utility Targets
# ============================================================================

# Clean build artifacts
clean:
	@rm -rf $(BUILD_DIR)
	@rm -f *.dat *.png gmon.out
	@echo "✓ Cleaned build directory"

# Install to system
install: $(BUILD_DIR)/$(TARGET_EXEC)
	@install -Dt $(BIN_DIR) $<
	@echo "✓ Installed to $(BIN_DIR)"

# Run the program
run: $(BUILD_DIR)/$(TARGET_EXEC)
	@./$<

# Run with valgrind memory checking
valgrind: debug
	@echo "Running with valgrind..."
	@valgrind --leak-check=full --show-leak-kinds=all ./$(BUILD_DIR)/$(TARGET_EXEC)

# Run with gdb debugger
gdb: debug
	@gdb ./$(BUILD_DIR)/$(TARGET_EXEC)

# Help target
help:
	@echo "HPC Coursework Makefile"
	@echo "======================="
	@echo ""
	@echo "Build targets:"
	@echo "  make              - Build release version (default)"
	@echo "  make debug        - Build with debug symbols"
	@echo "  make release      - Build optimized version"
	@echo "  make openmp       - Build with OpenMP parallelization"
	@echo "  make profile      - Build for profiling with gprof"
	@echo ""
	@echo "Analysis targets:"
	@echo "  make check        - Run cppcheck static analysis"
	@echo "  make lint         - Run clang-tidy linting"
	@echo "  make format       - Format code with clang-format"
	@echo ""
	@echo "Utility targets:"
	@echo "  make run          - Run the program"
	@echo "  make valgrind     - Run with valgrind memory checker"
	@echo "  make gdb          - Run with gdb debugger"
	@echo "  make clean        - Remove build artifacts"
	@echo "  make install      - Install to $(BIN_DIR)"

# Include dependency files
-include $(DEPS)
