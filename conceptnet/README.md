# ConceptNet Apptainer Environment

## Populating the Database
- Make sure this repo is cloned to your blue directory on hipergator. ConceptNet is over 30GB.
- Do this only in a slurm job. My container is ultimately getting its TMPDIR variable from Slurm. Interactive jobs still use slurm; you can make one at [ood.rc.ufl.edu](ood.rc.ufl.edu).
  - The CN wiki says you need at least 30GB of RAM. I ran with 2 cores and 36GB of RAM, and the job took 10.5 hours.
- Run `module load apptainer`
- Run `make data`

## Starting the Database
Run `make start` to start an apptainer process hosting ConceptNet on 127.0.0.1:5432. Run `make stop` to shut it down.

## Exploring the Database

Do the following if you want to manually explore the database a bit:
```
module load apptainer
apptainer run --writable sandbox psql
$ \c conceptnet5                      # Switches to the conceptnet database
$ \dt                                 # Lists tables
$ SELECT COUNT(*) from relations;     # Don't forget the semicolon
$ \q                                  # Exit
```

## Using in a Slurm Script
See our [sample_slurm.sh](sample_slurm.sh) for reference.
