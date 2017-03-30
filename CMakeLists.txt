cmake_minimum_required(VERSION 2.8)

project(clang-ocl)

# Default installation path
set(CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "")

find_path(OPENCL_ROOT lib/x86_64/bitcode/opencl.amdgcn.bc
    PATH_SUFFIXES 
        opencl
        lib/opencl
    PATHS
        /opt/rocm
)
if(NOT OPENCL_ROOT)
    message(FATAL_ERROR "Can't find opencl")
endif()

configure_file(clang-ocl.in clang-ocl @ONLY)

install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/clang-ocl DESTINATION bin)
