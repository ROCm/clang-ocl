################################################################################
# Copyright (C) 2017 Advanced Micro Devices, Inc.
################################################################################


include(CMakeParseArguments)

string(RANDOM _TEST_RAND)
set(TEST ${CMAKE_ARGV3})
set(TEST_DIR @TEST_DIR@)
set(TMP_DIR ${CMAKE_ARGV4}-${_TEST_RAND})
file(MAKE_DIRECTORY ${TMP_DIR})
set(PREFIX ${TMP_DIR}/usr)
set(BUILDS_DIR ${TMP_DIR}/builds)
set(CLANG_OCL bash @CLANG_OCL@)

macro(test_expect_eq X Y)
    if(NOT ${X} EQUAL ${Y})
        message(FATAL_ERROR "EXPECT FAILURE: ${X} != ${Y} ${ARGN}")
    endif()
endmacro()

macro(test_expect_matches X Y)
    if(NOT ${X} MATCHES ${Y})
        message(FATAL_ERROR "EXPECT FAILURE: ${X} != ${Y} ${ARGN}")
    endif()
endmacro()

macro(test_expect_file FILE)
    if(NOT EXISTS ${FILE})
        message(FATAL_ERROR "EXPECT FILE: ${FILE}")
    endif()
endmacro()

function(test_exec)
    execute_process(${ARGN} RESULT_VARIABLE RESULT)
    if(NOT RESULT EQUAL 0)
        message(FATAL_ERROR "Process failed: ${ARGN}")
    endif()
endfunction()

include(${TEST})

file(REMOVE_RECURSE ${TMP_DIR})
