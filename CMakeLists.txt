cmake_minimum_required(VERSION 2.8)

# Default installation path
set(CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "")

project(clang-ocl)

find_package(ROCM PATHS /opt/rocm)
include(ROCMSetupVersion)
include(ROCMCreatePackage)

rocm_setup_version(VERSION 0.2.0)

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

set(CPACK_DEBIAN_PACKAGE_DEPENDS "rocm-opencl-dev")
set(CPACK_RPM_PACKAGE_REQUIRES "rocm-opencl-devel")
rocm_create_package(
    NAME rocm-clang-ocl
    DESCRIPTION "OpenCL compilation with clang compiler."
    MAINTAINER "Paul Fultz II <paul.fultz@amd.com>"
)
