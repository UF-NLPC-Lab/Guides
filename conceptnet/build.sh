#!/bin/bash

set -x
HOST_GROUP=$(groups | awk '{print $1}')
APPTAINERENV_TMPDIR=/tmp apptainer build -F --build-arg HOST_USER=$(whoami) A.sif conceptnet.def

apptainer build -F --sandbox sandbox/ A.sif
