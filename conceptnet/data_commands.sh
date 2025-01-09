#!/bin/bash

HOST_USER=$(whoami)
PG_BIN=/usr/lib/postgresql/12/bin
cd /conceptnet5

rm -rf pg_data && mkdir pg_data
$PG_BIN/initdb pg_data/
$PG_BIN/pg_ctl -D pg_data/ -l pg.log start
psql -d postgres -c "create database $HOST_USER"
psql -c "create database conceptnet5"

python3 -m venv ./local_env
source ./local_env/bin/activate
# venv doesn't have wheel installed by default, and it's needed to install some other packages. Not sure why python's topological sort can't pick up on that
python3 -m pip install wheel
python3 -m pip install -e '.[vectors]'

./build.sh

$PG_BIN/pg_ctl stop -D pg_data/
