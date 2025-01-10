# Apptainer

Some of the other tutorials here use Apptainer, the (only) container runtime available on UF's compute cluster.
If you've used Docker or Podman before, some of Apptainer's functionality will look familiar, but overall Apptainer takes a lot of the good default behavior from Docker and reverses it.

This guide is primarily intended for someone already with a working familiarity with another container system.
Here we outline a few common pitfalls and, where possible, solutions.

## Apptainer Doesn't Actually "Contain" Much
When you run a container with `apptainer run`, apptainer by default mounts your `/home/<username>` directory and several system directories (see [their list](https://apptainer.org/docs/user/main/bind_paths_and_mounts.html#system-defined-bind-paths)).
The processes in your container are also exposed to the host (which does make it nice if you want to kill a container process from your host with `kill -9`).

You can add the [--contain](https://apptainer.org/docs/user/main/bind_paths_and_mounts.html#contain-containall) to get rid of the filesystem mount, but that also creates an in-RAM filesystem for parts of your container. You may run out of room depending on the kind of job you're doing.

But in general, don't use `--contain`; Apptainer isn't a real container environment.
You should think of Apptainer the way you think of loading an lmod module (i.e. `module load conda`).
The only advantage it offers is letting you install 3rd party software that you couldn't otherwise.

## Directories that Should be Mounted
Apptainer will try to mount directories like `/blue`, `/orange`, and `/scratch` into your container, but will fail because it expects these directories to also exist inside the container filesytem.

To get around this, add the following line to the `%post` section of your definition file:
```bash
mkdir -p /blue /orange /scratch
```
As long as those directories exist, the appropriate bindings for them should get set up at runtime automatically.

## The Temp Directory Not Being Available
When you run `module load apptainer`, the load process is configured to set the following environment variables:
- `APPTAINERENV_TMPDIR`
- `TMPDIR`
- `HPC_TMPDIR`

Unfortunately, due to Apptainer's mounting process, these dirs won't always exist in the container filesystem.
Solve that by adding this to the beginning of the `%post` section of your definition file:
```bash
mkdir -p $TMPDIR
```

If you're running in the context of a slurm job, these will get set to whatever `SLURM_TMPDIR` is.
They'll have some path of the form `/scratch/local/<slurm job id>`
Assuming you've followed the instructions for mounting `/scratch, /blue, and /orange`, you shouldn't need to do anything else.

If you're not running in a slurm job, a local `./tmp` dir will get created and used for APPTAINERENV_TMPDIR.
In this case you're going to need to set APPTAINERENV_TMPDIR yourself, and bind that local directory to the container filesystem:
```bash
APPTAINERENV_TMPDIR=`pwd`/tmp apptainer run --bind `pwd`/tmp:/tmp my_container.sif my_program
```

## System Files Not Writable & Writable Overlays Disabled
Apptainer is designed to keep you from writing as few system files as possible.
The typical way to circumevent this is a filesystem overlay, but the HPG admins have disabled overlays.

Whan you can instead do is convert your `.sif` image to a sandbox directory that contains an editable filesystem:

```bash
apptainer build --sandbox my_image_sandbox/ my_image.sif
apptainer run --writable my_image_sandbox/ bash
```

## Root Privileges
You never actually run as "real" root in an Apptainer container.
During the build process, apptainer uses the Linux `fakeroot` command to deceive commands like `apt-get` into thinking you're root.
On the host filesystem, any files you made as fakeroot in the container will still show up with your regular username.

I think the motivation for this was, in Docker, you could create a file with root-only access inside a mounted partition from your host fileystem.
The sysadmins were probably worried novice users would pollute the host filesystem with a bunch of root-owned files and not know how to delete them.

If you want to run as fakeroot at runtime, pass the `--fakeroot` flag to the `run` command.
In general though, you should be able to install everything you need to during the build process.
