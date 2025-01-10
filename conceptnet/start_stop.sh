#!/bin/bash

HOST_USER=$(whoami)
PG_BIN=/usr/lib/postgresql/12/bin

$PG_BIN/pg_ctl -D pg_data/ -l pg.log stop
$PG_BIN/pg_ctl -D pg_data/ -l pg.log start
