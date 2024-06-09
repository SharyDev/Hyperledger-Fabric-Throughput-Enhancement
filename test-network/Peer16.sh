#!/bin/bash

# Set environment variables
export PATH=$PATH:${PWD}/../bin
export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

# Define an array with peer names
peers=("peer16" "peer17")

# Loop through the array to handle registration, enrollment, and Docker container startup
for peer in "${peers[@]}"
do
    # Register the peer
    fabric-ca-client register --caname ca-org1 --id.name $peer --id.secret ${peer}pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

    # Create directory for the peer
    mkdir -p organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com

    # Enroll the peer
    fabric-ca-client enroll -u https://${peer}:${peer}pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/msp --csr.hosts ${peer}.org1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

    # Copy config file
    cp ${PWD}/organizations/peerOrganizations/org1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/msp/config.yaml

    # Enroll TLS certificates for the peer
    fabric-ca-client enroll -u https://${peer}:${peer}pw@localhost:7054 --caname ca-org1 -M ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/tls --enrollment.profile tls --csr.hosts ${peer}.org1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem

    # Copy TLS certificates
    cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/tls/ca.crt
    cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/tls/server.crt
    cp ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/org1.example.com/peers/${peer}.org1.example.com/tls/server.key

    # Start Docker container for the peer
    docker-compose -f compose/compose-${peer}org1.yaml up -d
done

