#!/bin/bash

HOST_USER=$(whoami)
service postgresql start
/usr/lib/postgresql/12/bin/createuser -U postgres -d $HOST_USER
psql -U postgres -c "create database $HOST_USER"
psql -c "create database conceptnet5"

cd /conceptnet5
# TODO: try and move this to the .def file
python3 -m venv ./local_env
source ./local_env/bin/activate
# venv doesn't have wheel installed by default, and it's needed to install some other packages. Not sure why python's topological sort can't pick up on that
python3 -m pip install wheel
python3 -m pip install -e '.[vectors]'

mkdir data
#./build.sh
