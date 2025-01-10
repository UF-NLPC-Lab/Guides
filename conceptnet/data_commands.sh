#!/bin/bash

HOST_USER=$(whoami)

rm -rf pg_data && mkdir pg_data
initdb pg_data/
pg_ctl -D pg_data/ -l pg.log start
psql -d postgres -c "create database $HOST_USER"
psql -c "create database conceptnet5"

VENV_PATH=`pwd`/local_env
python3 -m venv $VENV_PATH
source $VENV_PATH/bin/activate
# venv doesn't have wheel installed by default, and it's needed to install some other packages. Not sure why python's topological sort can't pick up on that
# Also got an import error for ipadic while building conceptnet.
python3 -m pip install wheel ipadic

pushd conceptnet5
mkdir -p data/
./build.sh
popd

pg_ctl stop -D pg_data/
