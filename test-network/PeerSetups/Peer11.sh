#!/bin/bash

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer11 --id.secret peer11pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer11:peer11pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/msp --csr.hosts peer11.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer11:peer11pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/tls --enrollment.profile tls --csr.hosts peer11.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer11.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer11org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:951 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:951 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:951 peer lifecycle chaincode install basic.tar.gz


#invoke
CORE_PEER_ADDRESS=localhost:951 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'


# Query
CORE_PEER_ADDRESS=localhost:951 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

