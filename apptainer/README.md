# Apptainer

Some of the other tutorials here use Apptainer, the (only) container runtime available on UF's compute cluster.
If you've used Docker or Podman before, some of Apptainer's functionality will look familiar, but overall Apptainer takes a lot of the good default behavior from Docker and reverses it, forcing you to specify several extra flags during the build and/or run process.

Here we outline a few common "gotchas" and out to circumvent them:

## File System Mounts
When you run a container with `apptainer run`, apptainer mounts much of your host filesystem into the container (the opposite of what a Docker user would expect). Run with `--containall` to stop this.

## System Files Not Writable & Writable Overlays Disabled
Apptainer is designed to keep you from writing as few system files as possible (whether you run with `--containall` or not).
You can get around this with  `--writable` or `--writable-tmpfs` option and a filesystem overlay, but the HPG admin has disabled overlays.

Whan you can instead do is convert your `.sif` image to a sandbox directory that contains an editable filesystem:

```bash
apptainer build --sandbox my_image_sandbox/ my_image.sif
apptainer run --writable my_image_sandbox/ bash
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

## Fakeroot
This one I have no workaround for.

Apptainer is designed to never let you run as actual root. During the build proces, it uses the Linux `fakeroot` command to deceive commands like `apt-get` into thinking you're root.
Sometimes this isn't enough though.

If you want to run as fakeroot at runtime, pass the `--fakeroot` flag to the `run` command.
Again, being fakeroot sometimes isn't enough to accomplish what you want.

I think the motivation for this was, in Docker, you could create a file with root-only access inside a mounted partition from your host fileystem.
The sysadmins were probably worried novice users would pollute the host filesystem with a bunch of root-owned files and not know how to delete them.
If you're "fakeroot" though, those files will still show up on the host filesystem as being owned by you.
