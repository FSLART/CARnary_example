cmake_minimum_required(VERSION 3.26)
project(CARnary_example)

set(CMAKE_CXX_STANDARD 17)

add_executable(client_example src/client.cpp)
add_executable(server_example src/server.cpp)

