# using ubuntu because all the other software runs on ubuntu. it's more realistic to test.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# update the system
RUN apt update
RUN apt upgrade -y

# install build tools and git
RUN apt install git build-essential wget openssl -y

# build cmake from source
WORKDIR /home/fslart
RUN wget https://github.com/Kitware/CMake/releases/download/v3.28.0-rc5/cmake-3.28.0-rc5.tar.gz
RUN tar -xvf cmake-3.28.0-rc5.tar.gz
WORKDIR /home/fslart/cmake-3.28.0-rc5
RUN ./bootstrap
RUN make -j8
RUN make install
WORKDIR /home/fslart
RUN rm -rf /home/fslart/cmake-3.28.0-rc5.tar.gz

# install CARnary_lib
# first clone it
WORKDIR /temp/
RUN git clone https://github.com/FSLART/CARnary_lib.git
WORKDIR /temp/CARnary_lib/build
# now build it
RUN cmake ..
RUN make -j8
RUN make install

# build and run the daemon
WORKDIR /home/fslart/
RUN git clone https://github.com/FSLART/CARnary_server.git
WORKDIR /home/fslart/CARnary_server/build
RUN cmake ..
RUN make -j8

# copy this source to the container
RUN mkdir -p /home/fslart/example
COPY . /home/fslart/example

# now build this project
WORKDIR /home/fslart/example/build
RUN cmake ..
RUN make -j8

# TODO: create an entrypoint script to start the server and then the client

