#!/bin/bash

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer10 --id.secret peer10pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer10:peer10pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/msp --csr.hosts peer10.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer10:peer10pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/tls --enrollment.profile tls --csr.hosts peer10.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer10.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer10org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:851 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:851 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:851 peer lifecycle chaincode install basic.tar.gz

#invoke
CORE_PEER_ADDRESS=localhost:851 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'

# Query
CORE_PEER_ADDRESS=localhost:851 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

#Peer3

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

#peer4

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer12 --id.secret peer12pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer12:peer12pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/msp --csr.hosts peer12.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer12:peer12pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/tls --enrollment.profile tls --csr.hosts peer12.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer12.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer12org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:1051 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:1051 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:1051 peer lifecycle chaincode install basic.tar.gz


#invoke
CORE_PEER_ADDRESS=localhost:1051 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'


# Query
CORE_PEER_ADDRESS=localhost:1051 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

#Peer5
# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer13 --id.secret peer13pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer13:peer13pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/msp --csr.hosts peer13.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer13:peer13pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/tls --enrollment.profile tls --csr.hosts peer13.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer13.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer13org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:1151 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:1151 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:1151 peer lifecycle chaincode install basic.tar.gz
#invoke
CORE_PEER_ADDRESS=localhost:1151 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'

# Query
CORE_PEER_ADDRESS=localhost:1151 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'



#Peer6

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer14 --id.secret peer14pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer14:peer14pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/msp --csr.hosts peer14.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer14:peer14pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/tls --enrollment.profile tls --csr.hosts peer14.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer14.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer14org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:1251 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:1251 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:1251 peer lifecycle chaincode install basic.tar.gz

#invoke
CORE_PEER_ADDRESS=localhost:1251 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'

# Query
CORE_PEER_ADDRESS=localhost:1251 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'


#Peer7

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer15 --id.secret peer15pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer15:peer15pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/msp --csr.hosts peer15.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer15:peer15pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/tls --enrollment.profile tls --csr.hosts peer15.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer15.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer15org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:1351 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:1351 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:1351 peer lifecycle chaincode install basic.tar.gz

#invoke
CORE_PEER_ADDRESS=localhost:1351 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'


# Query
CORE_PEER_ADDRESS=localhost:1351 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'


#Peer8

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer16 --id.secret peer16pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer16:peer16pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/msp --csr.hosts peer16.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer16:peer16pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/tls --enrollment.profile tls --csr.hosts peer16.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer16.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer16org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:9251 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:9251 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:9251 peer lifecycle chaincode install basic.tar.gz

#invoke
CORE_PEER_ADDRESS=localhost:9251 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'



# Query
CORE_PEER_ADDRESS=localhost:9251 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

#Peer9

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer17 --id.secret peer17pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer17:peer17pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/msp --csr.hosts peer17.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer17:peer17pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/tls --enrollment.profile tls --csr.hosts peer17.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer17.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer17org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:1551 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:1551 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:1551 peer lifecycle chaincode install basic.tar.gz


#invoke
CORE_PEER_ADDRESS=localhost:1551 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'


# Query
CORE_PEER_ADDRESS=localhost:1551 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'


#Peer10

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer18 --id.secret peer18pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer18:peer18pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/msp --csr.hosts peer18.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer18:peer18pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/tls --enrollment.profile tls --csr.hosts peer18.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer18.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer18org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:7451 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:7451 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:7451 peer lifecycle chaincode install basic.tar.gz

#invoke
CORE_PEER_ADDRESS=localhost:7451 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'



# Query
CORE_PEER_ADDRESS=localhost:7451 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'


#Peer11


# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer19 --id.secret peer19pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer19:peer19pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/msp --csr.hosts peer19.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer19:peer19pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/tls --enrollment.profile tls --csr.hosts peer19.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer19.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer19org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:7351 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:7351 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:7351 peer lifecycle chaincode install basic.tar.gz
#invoke
CORE_PEER_ADDRESS=localhost:7351 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'

# Query
CORE_PEER_ADDRESS=localhost:7351 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'

#Peer12

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Register peer
fabric-ca-client register --caname ca-org1 --id.name peer20 --id.secret peer20pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Create directory for peer
mkdir -p organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com

# Enroll peer
fabric-ca-client enroll -u https://peer20:peer20pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/msp --csr.hosts peer20.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy config.yaml
cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/msp/config.yaml

# Enroll peer TLS
fabric-ca-client enroll -u https://peer20:peer20pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/tls --enrollment.profile tls --csr.hosts peer20.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

# Copy TLS certificates
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/tls/ca.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/tls/server.crt
cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer20.org1.example.com/tls/server.key

# Import docker
docker-compose -f compose/compose-peer20org1.yaml up -d

# Check channel
peer channel list
CORE_PEER_ADDRESS=localhost:7251 peer channel list

# Join channel
CORE_PEER_ADDRESS=localhost:7251 peer channel join -b channel-artifacts/mychannel.block

# Join ledger or chaincode
CORE_PEER_ADDRESS=localhost:7251 peer lifecycle chaincode install basic.tar.gz

#invoke
CORE_PEER_ADDRESS=localhost:7251 peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile "${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem" -C mychannel -n basic --peerAddresses localhost:7051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt" --peerAddresses localhost:9051 --tlsRootCertFiles "${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt" -c '{"function":"InitLedger","Args":[]}'

# Query
CORE_PEER_ADDRESS=localhost:7251 peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}'
