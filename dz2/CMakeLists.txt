cmake_minimum_required(VERSION 3.16)
project(MDL-CB-DZ2)

set(CMAKE_CXX_STANDARD 20)

set(SOURCE ./src/main.cpp)

include_directories(./include)

add_executable(main ${SOURCE})

set_target_properties(main PROPERTIES COMPILE_FLAGS "-fmodules-ts")