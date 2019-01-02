cmake_minimum_required(VERSION 2.8)

# Default installation path
set(CMAKE_INSTALL_PREFIX "/opt/rocm" CACHE PATH "")

project(clang-ocl)

find_package(ROCM PATHS /opt/rocm)
include(ROCMSetupVersion)
include(ROCMCreatePackage)
include(CTest)

rocm_setup_version(VERSION 0.4.0)

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

find_program(CLINFO clinfo PATHS ${OPENCL_ROOT}/bin/x86_64/)
execute_process(COMMAND ${CLINFO} OUTPUT_VARIABLE CLINFO_OUT RESULT_VARIABLE RESULT)
if(RESULT EQUAL 0)
    string(REGEX MATCH "Platform Version[^\\(]*\\(([0-9]+).*\\)" PLATFORM_VER ${CLINFO_OUT})
    set(OPENCL_VER "${CMAKE_MATCH_1}")
    if(OPENCL_VER LESS 2534)
        set(TRIPLE amdgcn-amd-amdhsa-opencl)
    else()
        set(TRIPLE amdgcn-amd-amdhsa-amdgizcl)
    endif()
    message(STATUS "OpenCL Version: ${OPENCL_VER}")
else()
    find_program(LLVM_DIS llvm-dis PATHS /opt/rocm /opt/rocm/hcc)
    execute_process(COMMAND ${LLVM_DIS} -o - ${OPENCL_ROOT}/lib/x86_64/bitcode/oclc_isa_version_900.amdgcn.bc OUTPUT_VARIABLE LLVM_DIS_OUT)
    if(LLVM_DIS_OUT MATCHES "amdgcn-amd-amdhsa-opencl")
        set(TRIPLE amdgcn-amd-amdhsa-opencl)
    else()
        set(TRIPLE amdgcn-amd-amdhsa-amdgizcl)
    endif()
endif()

message(STATUS "OpenCL Triple: ${TRIPLE}")

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
