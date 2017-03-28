cmake_minimum_required(VERSION 2.8)

project(clang-ocl)

find_path(OPENCL_ROOT lib/x86_64/bitcode/opencl.amdgcn.bc
    PATH_SUFFIXES 
        opencl
    PATHS
        /opt/rocm
)

configure_file(clang-ocl.in clang-ocl @ONLY)

install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/clang-ocl DESTINATION bin)
