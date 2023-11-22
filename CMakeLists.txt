cmake_minimum_required(VERSION 3.26)
project(CARnary_example)

set(CMAKE_CXX_STANDARD 17)

# find the carnary library
find_package(CARnary_lib REQUIRED)

# declare the header directories, including carnary headers
include_directories(include ${CARnary_lib_INCLUDE_DIRS})

# create the executables
add_executable(client_example src/client.cpp)

# link the executables to the carnary library
target_link_libraries(client_example CARnary_lib)

