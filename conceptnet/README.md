# ConceptNet Apptainer Environment


## Instructions

### Populating the Database
- Make sure this repo is cloned to your blue directory on hipergator. ConceptNet is over 30GB.
- Do this only in a slurm job. My container is ultimately getting its TMPDIR variable from Slurm. You can still do it with an interactive slurm job at [ood.rc.ufl.edu](ood.rc.ufl.edu).
  - The CN wiki says you need at least 30GB of RAM. I ran with 2 cores and 36GB of RAM, and the job took 10.5 hours.
- Run `module load apptainer`
- Run `make data`

### Querying the Database
