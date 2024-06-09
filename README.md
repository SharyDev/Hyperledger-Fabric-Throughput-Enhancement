# Hyperledger Fabric Throughput Enhancement

This repository focuses on enhancing the throughput of Hyperledger Fabric blockchain networks. It includes configurations, scripts, and instructions for benchmarking the blockchain network using Hyperledger Caliper.

## Setup Instructions

### 1. Network Setup

Start the network and create a channel named `mychannel` using the following command:

```bash
./network.sh up createChannel -ca -c mychannel

### 2. Basic Chaincode Installation

Install the basic chaincode on the network:

```bash
