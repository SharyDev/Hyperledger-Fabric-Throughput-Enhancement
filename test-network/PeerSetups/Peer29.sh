#!/bin/bash

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer29 --id.secret peer29pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer29:peer29pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/msp --csr.hosts peer29.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer29:peer29pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/tls --enrollment.profile tls --csr.hosts peer29.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer29.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer29org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:4651 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:4651 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:4651 peer lifecycle chaincode install basic.tar.gz

# Query
CORE_PEER_ADDRESS=localhost:4651 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

