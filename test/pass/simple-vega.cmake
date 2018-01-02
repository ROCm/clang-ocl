
test_exec(COMMAND ${CLANG_OCL} ${TEST_DIR}/simple.cl -mcpu=gfx900 -o ${TMP_DIR}/simple.o)
test_expect_file(${TMP_DIR}/simple.o)
