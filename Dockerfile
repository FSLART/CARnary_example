# using ubuntu because all the other software runs on ubuntu. it's more realistic to test.
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# update the system
RUN apt update
RUN apt upgrade -y

# install build tools and git
RUN apt install git build-essential -y

# copy this source to the container
RUN mkdir -p /home/fslart/example
COPY . /home/fslart/example

# install CARnary_lib
# first clone it
WORKDIR /temp/
RUN git clone https://github.com/FSLART/CARnary_lib.git
WORKDIR /temp/CARnary_lib/build
# now build it
RUN cmake ..
RUN make -j8
RUN make install

# now build this project
WORKDIR /home/fslart/example/build
RUN cmake ..
RUN make -j8

# TODO: create an entrypoint script to start the server and then the client

