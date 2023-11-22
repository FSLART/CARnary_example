#include <iostream>
#include <string>
#include <thread>

#include <carnary/CARnaryClient.h>

using namespace carnary::client;

#define MAX_CONNECT_TRIES 3

#define SERVICE_NAME "example"

enum failure_t {
    CONNECT_FAILURE,
    NEGOTIATION_FAILURE
};

/*
Usage:

    client [minHeartbeatRate] [actualHeartbeatRate]

    minHeartbeatRate: the minimum heartbeat rate acceptable by the daemon
    actualHeartbeatRate: the heartbeat rate to be produced
*/

int main(int argc, char* argv[]) {
    
    (int) argc;
    (char**) argv;

    // verify the right arguments were provided
    if(argc != 3) {
        std::cerr << "Usage: client [minHeartbeatRate] [actualHeartbeatRate]" << std::endl;
        return 1;
    }

    // parse the minimum heartbeat rate
    std::uint16_t minHeartbeatRate = 0;
    try {
        minHeartbeatRate = std::stoi(argv[1]);
    } catch(std::invalid_argument& ex) {
        std::cerr << "Invalid argument: " << argv[1] << std::endl;
        return 1;
    }

    // parse the actual heartbeat rate
    std::uint16_t actualHeartbeatRate = 0;
    try {
        actualHeartbeatRate = std::stoi(argv[2]);
    } catch(std::invalid_argument& ex) {
        std::cerr << "Invalid argument: " << argv[2] << std::endl;
        return 1;
    }

    CARnaryClient client;

    // negotiation file descriptor
    int daemonfd = -1, watcherfd = -1;

    // try to connect to the daemon
    try {
        daemonfd = client.tryConnect(MAX_CONNECT_TRIES);
    } catch(std::runtime_error& ex) {
        std::cerr << ex.what() << std::endl;
        return (int) CONNECT_FAILURE;
    }

    // negotiate with the daemon
    try {
        watcherfd = client.negotiate(daemonfd, SERVICE_NAME, minHeartbeatRate);
    } catch(std::runtime_error& ex) {
        std::cerr << ex.what() << std::endl;
        return (int) NEGOTIATION_FAILURE;
    }

    // continuously ping
    while(1) {
        std::cout << "ping" << std::endl;
        client.ping();
        // sleep considering actualHeartbeatRate
        std::this_thread::sleep_for(std::chrono::milliseconds((int) ((float) 1 / actualHeartbeatRate)) * 1000);
    }

    return 0;
}
