{
  mkShellNoCC,
  callPackage,

  # Compilers and build tools
  gcc,
  gnumake,

  # Plotting and visualization
  gnuplot,

  # Debugging tools
  gdb,
  valgrind,

  # Static analysis and linting
  cppcheck,
  clang-tools, # For clang-format, clang-tidy (C compatible)


  # Code formatting
  astyle, # Alternative C formatter

  # Documentation
  doxygen,

  ltrace, # Library call tracing
}:
let
  defaultPackage = callPackage ./default.nix { };
in
mkShellNoCC {
  inputsFrom = [ defaultPackage ];

  packages = [
    # Core compilation
    gcc # Includes OpenMP support with -fopenmp flag
    gnumake

    # Plotting (required for coursework)
    gnuplot

    # Debugging
    gdb # GNU debugger
    valgrind # Memory error detection
    ltrace # Library call tracer

    # Static analysis and linting
    cppcheck # C/C++ static analyzer
    clang-tools # clang-format, clang-tidy for C code

    # Code formatting
    astyle # Artistic Style code formatter

    # Documentation
    doxygen # Generate docs from comments
  ];

  # Set up shell environment
  shellHook = ''
    echo "🚀 HPC Development Environment Loaded"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Available Tools:"
    echo "  • gcc (with OpenMP: use -fopenmp flag)"
    echo "  • gdb, valgrind (debugging)"
    echo "  • cppcheck, clang-tidy (static analysis)"
    echo "  • clang-format, astyle (code formatting)"
    echo "  • gnuplot (plotting)"
    echo "  • doxygen (documentation)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  '';
}
