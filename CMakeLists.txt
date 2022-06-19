cmake_minimum_required(VERSION 3.5)

# Default installation path
set(CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "")

project(clang-ocl)

find_package(ROCM PATHS /opt/rocm)
include(GNUInstallDirs)
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

    # Support building with new and old device-lib paths
    # Previously installed to /opt/rocm/lib
    # New layout installed to /opt/rocm/amdgcn/bitcode
    find_path(BC_DIR NAMES "opencl.bc" "opencl.amdgcn.bc"
      PATHS
        "${AMD_DEVICE_LIBS_PREFIX}/amdgcn/bitcode"
        "${AMD_DEVICE_LIBS_PREFIX}/lib/bitcode"
        "${AMD_DEVICE_LIBS_PREFIX}/lib"
      NO_DEFAULT_PATH)

    set(BITCODE_DIR "${BC_DIR}" CACHE STRING "")
endif()

set(DISABLE_CHECKS OFF CACHE BOOL "Disable checking variables exist.")
if(NOT DISABLE_CHECKS)
    if(NOT EXISTS "${CLANG_BIN}/clang")
        message(SEND_ERROR "Clang is not found.")
    endif()

    if(NOT EXISTS "${BITCODE_DIR}")
        message(SEND_ERROR "Device libs is not found.")
    endif()
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

install(PROGRAMS ${CLANG_OCL} DESTINATION ${CMAKE_INSTALL_BINDIR})

set(CPACK_DEBIAN_PACKAGE_DEPENDS "rocm-llvm, rocm-opencl-dev")
set(CPACK_RPM_PACKAGE_REQUIRES "rocm-llvm, rocm-opencl-devel")
rocm_create_package(
    NAME rocm-clang-ocl
    DESCRIPTION "OpenCL compilation with clang compiler."
    MAINTAINER "Paul Fultz II <paul.fultz@amd.com>"
)
