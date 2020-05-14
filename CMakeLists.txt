cmake_minimum_required(VERSION 2.8)

# Default installation path
set(CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "")

project(clang-ocl)

find_package(ROCM PATHS /opt/rocm)
include(ROCMSetupVersion)
include(ROCMCreatePackage)
include(CTest)

rocm_setup_version(VERSION 0.5.0)

if(CMAKE_CXX_COMPILER MATCHES ".*hcc")
    set(HCC_EXE ${CMAKE_CXX_COMPILER})
else()
    find_program(HCC_EXE NAMES hcc clang PATHS /opt/rocm/hcc/bin)
endif()

get_filename_component(HCC_BIN ${HCC_EXE} DIRECTORY)
if(NOT HCC_BIN)
    message("HCC_EXE: ${HCC_EXE}")
    message("HCC_BIN: ${HCC_BIN}")
    message(FATAL_ERROR "Can't find hcc")
endif()

set(CLANG_BIN "${HCC_BIN}" CACHE STRING "")
set(BITCODE_DIR "${HCC_BIN}/../lib" CACHE STRING "")

message("")
message("--------CLANG_BIN: ${CLANG_BIN}")
message("------BITCODE_DIR: ${BITCODE_DIR}")
message("")

set(TRIPLE amdgcn-amd-amdhsa)
message(STATUS "Triple: ${TRIPLE}")

set(CLANG_OCL ${CMAKE_CURRENT_BINARY_DIR}/clang-ocl)

configure_file(clang-ocl.in ${CLANG_OCL} @ONLY)

add_subdirectory(test)

install(PROGRAMS ${CLANG_OCL} DESTINATION bin)

set(CPACK_DEBIAN_PACKAGE_DEPENDS "rocm-opencl-dev")
set(CPACK_RPM_PACKAGE_REQUIRES "rocm-opencl-devel")
rocm_create_package(
    NAME rocm-clang-ocl
    DESCRIPTION "OpenCL compilation with clang compiler."
    MAINTAINER "Paul Fultz II <paul.fultz@amd.com>"
)
