#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=4gb
#SBATCH --time=8:00:00
#SBATCH --job-name=bn_query
#SBATCH --mail-type=FAIL,END

####################### Set These Yourself ###################################

# Directory that you got after unzipping the BabelNet .tar.bz2 file
BABELNET_HOSTPATH=/path/to/BabelNet-5.0/

# Apptainer BabelNet RPC image
BABELNET_IMAGE=/path/to/babelnet-rpc.sif


################################### Leave These Alone ################################################

INSTANCE_NAME=babelnet
LOG_PREFIX=/home/`whoami`/.apptainer/instances/logs/`hostname`/`whoami`/$INSTANCE_NAME
LOG_OUT=${LOG_PREFIX}.out
LOG_ERR=${LOG_PREFIX}.err
rm -f $LOG_OUT $LOG_ERR

module load apptainer
apptainer instance run --containall --bind $BABELNET_HOSTPATH:/root/babelnet $BABELNET_IMAGE $INSTANCE_NAME
echo "See $LOG_OUT and $LOG_ERR for container output"
echo "Sleeping 10 minutes for the server to start. Don't have a better solution than this right now"
sleep 10m

################################### Add Your Own Logic Here ###########################################

module load conda
conda activate babelnet
python sample_query.py 

######################################################################################################

apptainer instance stop $INSTANCE_NAME
