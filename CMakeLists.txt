cmake_minimum_required(VERSION 2.8)

# Default installation path
set(CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "")

project(clang-ocl)

find_package(ROCM PATHS /opt/rocm)
include(ROCMSetupVersion)
include(ROCMCreatePackage)
include(CTest)

rocm_setup_version(VERSION 0.5.0)

find_program(CLANG_EXE NAMES clang PATHS /opt/rocm/llvm/bin)

get_filename_component(CLANG_BIN ${CLANG_EXE} DIRECTORY)
if(NOT CLANG_BIN)
    message("CLANG_EXE: ${CLANG_EXE}")
    message("CLANG_BIN: ${CLANG_BIN}")
    message(FATAL_ERROR "Can't find clang")
endif()

set(ROCM_PATH "${CMAKE_INSTALL_PREFIX}" CACHE STRING "")
set(CLANG_BIN "${CLANG_BIN}" CACHE STRING "")

message("")
message("--------ROCM_PATH: ${ROCM_PATH}")
message("--------CLANG_BIN: ${CLANG_BIN}")
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
