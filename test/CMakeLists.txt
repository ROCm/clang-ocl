################################################################################
##
## The University of Illinois/NCSA
## Open Source License (NCSA)
##
## Copyright (c) 2022, Advanced Micro Devices, Inc. All rights reserved.
##
## Developed by:
##
##                 AMD Research and AMD HSA Software Development
##
##                 Advanced Micro Devices, Inc.
##
##                 www.amd.com
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to
## deal with the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and#or sell copies of the Software, and to permit persons to whom the
## Software is furnished to do so, subject to the following conditions:
##
##  - Redistributions of source code must retain the above copyright notice,
##    this list of conditions and the following disclaimers.
##  - Redistributions in binary form must reproduce the above copyright
##    notice, this list of conditions and the following disclaimers in
##    the documentation and#or other materials provided with the distribution.
##  - Neither the names of Advanced Micro Devices, Inc,
##    nor the names of its contributors may be used to endorse or promote
##    products derived from this Software without specific prior written
##    permission.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
## THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
## OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
## ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
## DEALINGS WITH THE SOFTWARE.
##
################################################################################
add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -C ${CMAKE_CFG_INTDIR})
add_custom_target(tests)

set(TEST_DIR ${CMAKE_CURRENT_SOURCE_DIR})
configure_file(test.cmake test.cmake @ONLY)

function(create_test NAME TEST)
    add_custom_target(${NAME} COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/test.cmake ${TEST} ${CMAKE_CURRENT_BINARY_DIR}/tmp/${NAME})
    add_test(NAME ${NAME} COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/test.cmake ${TEST} ${CMAKE_CURRENT_BINARY_DIR}/tmp/${NAME})
endfunction()

file(GLOB PASS_TESTS pass/*.cmake)
foreach(TEST ${PASS_TESTS})
    get_filename_component(NAME ${TEST} NAME_WE)
    create_test(pass-${NAME} ${TEST})
endforeach()

file(GLOB FAIL_TESTS fail/*.cmake)
foreach(TEST ${FAIL_TESTS})
    get_filename_component(NAME ${TEST} NAME_WE)
    create_test(fail-${NAME} ${TEST})
    set_tests_properties(fail-${NAME} PROPERTIES WILL_FAIL On)
endforeach()

