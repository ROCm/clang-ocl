# Copyright (c) 2022 Advanced Micro Devices, Inc. All Rights Reserved.
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

cmake_minimum_required(VERSION 3.16.8)

set(CLANG_OCL_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})
set(CLANG_OCL_WRAPPER_DIR ${CLANG_OCL_BUILD_DIR}/wrapper_dir)
set(CLANG_OCL_WRAPPER_BIN_DIR ${CLANG_OCL_WRAPPER_DIR}/bin)

#function to create symlink to binaries
function(create_binary_symlink)
  file(MAKE_DIRECTORY ${CLANG_OCL_WRAPPER_BIN_DIR})
  #create symlink for CLANG_OCL
  set(file_name "clang-ocl")
  add_custom_target(link_${file_name} ALL
                 WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    COMMAND ${CMAKE_COMMAND} -E create_symlink
                    ../libexec/${file_name}/${file_name} ${CLANG_OCL_WRAPPER_BIN_DIR}/${file_name})

endfunction()

# Create symlink to binaries
create_binary_symlink()
install(DIRECTORY ${CLANG_OCL_WRAPPER_BIN_DIR} DESTINATION .)
