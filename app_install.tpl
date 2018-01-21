#!/bin/bash

sudo wget https://dl.google.com/go/go1.9.2.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.9.2.linux-amd64.tar.gz

sudo mkdir /usr/local/go/src/test-go/

#export GOROOT=/usr/local/go
export GOPATH=/usr/local/go/src/test-go
export PATH=/usr/local/go/bin

#sudo go build /usr/local/go/src/test-go/test-go.go

#./test-go &
