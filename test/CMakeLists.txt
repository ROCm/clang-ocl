################################################################################
# Copyright (C) 2017 Advanced Micro Devices, Inc.
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

