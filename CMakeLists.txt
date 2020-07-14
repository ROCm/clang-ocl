cmake_minimum_required(VERSION 2.8)

# Default installation path
set(CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "")

project(clang-ocl)

find_package(ROCM PATHS /opt/rocm)
include(ROCMSetupVersion)
include(ROCMCreatePackage)
include(CTest)

rocm_setup_version(VERSION 0.5.0)

get_filename_component(CXX_COMPILER_PATH ${CMAKE_CXX_COMPILER} DIRECTORY)
get_filename_component(CXX_COMPILER_PATH ${CXX_COMPILER_PATH} DIRECTORY)

find_package(hcc HINTS ${CXX_COMPILER_PATH} PATHS /opt/rocm/hcc)
if(hcc_FOUND)
    set(CLANG_BIN "${hcc_LIB_INSTALL_DIR}/../bin" CACHE STRING "")
    set(BITCODE_DIR "${hcc_LIB_INSTALL_DIR}" CACHE STRING "")
else()
    find_program(CLANG_EXE NAMES clang HINTS ${CXX_COMPILER_PATH}/bin PATHS /opt/rocm/llvm/bin)
    get_filename_component(CLANG_EXE_DIR ${CLANG_EXE} DIRECTORY)
    find_package(AMDDeviceLibs PATHS /opt/rocm)
    set(CLANG_BIN "${CLANG_EXE_DIR}" CACHE STRING "")
    set(BITCODE_DIR "${AMD_DEVICE_LIBS_PREFIX}/lib" CACHE STRING "")
endif()

if(NOT EXISTS "${CLANG_BIN}/clang")
    message(SEND_ERROR "Clang is not found.")
endif()

if(NOT EXISTS "${BITCODE_DIR}")
    message(SEND_ERROR "Device libs is not found.")
endif()

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
