# using ubuntu because all the other software runs on ubuntu. it's more realistic to test.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# update the system
RUN apt update
RUN apt upgrade -y

# install build tools and git
RUN apt install git build-essential wget libssl-dev -y

# build cmake from source
WORKDIR /temp
RUN wget https://github.com/Kitware/CMake/releases/download/v3.27.8/cmake-3.27.8.tar.gz
RUN tar -xvf cmake-3.27.8.tar.gz
WORKDIR /temp/cmake-3.27.8
RUN ./bootstrap
RUN make -j8
RUN make install
WORKDIR /home/fslart
RUN rm -rf /temp

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
WORKDIR /home/fslart
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

ENTRYPOINT [ "entrypoint.sh" ]

