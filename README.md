# CARnary Example

Example toy project composed of a client and a server using CARnary. This is intended to assure easily that it is working as expected, as well as to provide reference.

## Requirements

- CMake
- Some C++17 compiler
- [CARnary_lib](https://github.com/FSLART/CARnary_lib)

## Build

### Bare metal
- Install the CARnary library. Instructions found in its own repository.
- Create a directory called `build` and go to it.
- Run the commands `cmake ..` and `make -j8`.
- That's it!

### Docker
TODO...

## Running
- Start the server:
    - `./build/server_example`
- Start the client:
    - `./build/client_example`

The client should now be communicating with the daemon successfully. You can emulate a failure by killing the client process.
