#!/bin/bash

HOST_USER=$(whoami)
service postgresql start
/usr/lib/postgresql/12/bin/createuser -U postgres -d $HOST_USER
psql -U postgres -c "create database $HOST_USER"
psql -c "create database conceptnet5"

cd /conceptnet5
mkdir data
python3 -m pip install -e '.[vectors]'
./build.sh
