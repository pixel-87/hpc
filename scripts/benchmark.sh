#!/usr/bin/env fish
# Benchmark script for comparing serial vs OpenMP performance

echo "=========================================="
echo "HPC Coursework Benchmark"
echo "=========================================="
echo ""

# Build and time serial version
echo "Building serial version..."
make release > /dev/null 2>&1
echo "✓ Serial build complete"
echo ""

echo "Running serial version..."
echo "----------------------------------------"
set start_time (date +%s.%N)
./build/advection2D
set end_time (date +%s.%N)
set elapsed (math "$end_time - $start_time")
echo "Serial execution time: $elapsed seconds"
echo ""

# Build OpenMP version
echo "Building OpenMP version..."
make openmp > /dev/null 2>&1
echo "✓ OpenMP build complete"
echo ""

# Test with different thread counts
for threads in 1 2 4 8 16
    echo "Running OpenMP with $threads thread(s)..."
    echo "----------------------------------------"
    set start_time (date +%s.%N)
    env OMP_NUM_THREADS=$threads ./build/advection2D
    set end_time (date +%s.%N)
    set elapsed (math "$end_time - $start_time")
    echo "OpenMP ($threads threads) execution time: $elapsed seconds"
    echo ""
end

echo "=========================================="
echo "Benchmark complete!"
echo "=========================================="
