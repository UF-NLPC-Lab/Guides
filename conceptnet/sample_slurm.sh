#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=24gb
#SBATCH --time=4:00:00
#SBATCH --job-name=cn_query
#SBATCH --mail-type=FAIL,END

################################### Leave These Alone ################################################

module load apptainer
make start

################################### Add Your Own Logic Here ###########################################

# You don't have to run your python script in the container.
# As long as you have a conda environment or similar with psycopg2 installed, you can run your script
# from outside the container
apptainer run --writable sandbox ./sample_query.py

#################################### Leave Alone ###########################################
make stop
