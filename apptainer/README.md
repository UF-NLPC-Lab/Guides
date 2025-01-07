# Apptainer

Some of the other tutorials here use Apptainer, the (only) container runtime available on UF's compute cluster.
If you've used Docker or Podman before, some of Apptainer's functionality will look familiar, but overall Apptainer takes a lot of the good default behavior from Docker and reverses it, forcing you to specify several extra flags during the build and/or run process.

A few gotcha's to be aware of:

## File System Mounts
When you run a container with `apptainer run`, apptainer mounts your host filesystem into the container (the opposite of what a Docker user would expect). Run with `--containall` to stop this.

## System Files Not Writable
Apptainer is designed to keep you from writing as few system files as possible (whether you run with `--containall` or not).
You can get around this with  `--writable` or `--writable-tmpfs` option and a filesystem overlay, but the HPG admin has disabled overlays.

Whan you can instead do is convert your `.sif` image to a sandbox directory that contains an editable filesystem:

```bash
apptainer build --sandbox my_image_sandbox/ my_image.sif
apptainer run my_image_sandbox/
```

## Tmp Dirs in Build Process
When you run `module load apptainer`, the load process is configured to set the following environment variables:
- `APPTAINERENV_TMPDIR`
- `TMPDIR`
- `HPC_TMPDIR`

If you're running in the context of a slurm job, these will get set to whatever `SLURM_TMPDIR` is.
Otherwise a local `./tmp` dir will get created and used for those three variables.

Regardless, the `APPTAINERENV_TMPDIR` value will get passed to the container build process and will initialize `TMPDIR` in that container.
Sometimes packages installed via `apt-get` will fail to install because they still expect packages to be in `/tmp`, regardless of `TMPDIR`'s value. You can get around that as follows:

```bash
APPTAINERENV_TMPDIR=/tmp apptainer build image_name.sif mydefinition.def
```

