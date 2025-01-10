# ConceptNet Apptainer Environment


## Instructions

### Populating the Database
- Make sure this repo is cloned to your blue directory on hipergator. ConceptNet is over 30GB.
- Do this only in a slurm job. My container is ultimately getting its TMPDIR variable from Slurm. You can still do it with an interactive slurm job at [ood.rc.ufl.edu](ood.rc.ufl.edu).
- Run `module load apptainer`
- Run `make data`

### Querying the Database
