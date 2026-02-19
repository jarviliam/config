{
  description = "C++20 project with development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        buildTools = with pkgs; [
          gcc13
          cmake
          ninja
          gdb
          valgrind
          clang-tools
          bear
          cppcheck
          doxygen
          graphviz
          ccache
          gtest
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          name = "cpp-dev-shell";
          buildInputs = buildTools;

          CC = "gcc";
          CXX = "g++";
          CMAKE_GENERATOR = "Ninja";

          shellHook = ''
            echo "C++ Development Environment Ready!"
            echo "Compiler: $(gcc --version | head -n1)"
            echo "C++ Standard: C++20"
            echo ""
            echo "Available commands:"
            echo "  cmake -B build -DCMAKE_BUILD_TYPE=Debug"
            echo "  cmake --build build"
            echo "  ./build/your_program"
            echo ""
            echo "Development tools:"
            echo "  clang-format    - Code formatting"
            echo "  cppcheck       - Static analysis"
            echo "  gdb            - Debugger"
            echo "  valgrind       - Memory analysis"
            echo "  doxygen        - Documentation generation"
          '';
        };
      }
    );
}
