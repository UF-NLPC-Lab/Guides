#!/bin/bash

HOST_USER=$(whoami)
service postgresql start
/usr/lib/postgresql/12/bin/createuser -U postgres -d $HOST_USER
psql -U postgres -c "create database $HOST_USER"
psql -c "create database conceptnet5"
