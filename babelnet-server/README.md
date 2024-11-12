# Using BabelNet

## Obtaining the BabelNet Indices

You're better off asking Ethan to set the file permissions on his copy of the indices, so we don't waste directory space downloading it twice.
If you do want to download BabelNet's indices yourself, I'd recommend doing the following:

1. Make an account on Sapienza NLP's [resource portal](http://nlp.uniroma1.it/resources/)
2. Submit a request for BabelNet's indicies
3. Wait for approval
4. Once approved, you can download the 45 GB zip file (70 GB unzipped). To download them, it's best to do the following:
5. Go to https://ood.rc.ufl.edu/
6. Go to "Interactive Apps > Hipergator Desktop"
7. Start a job with 1 core, 2GB memory, and 24 hours time limit
8. Open a terminal in the Desktop and run `module load ubuntu` to load the web browser apps
9. Open FireFox
10. DO NOT SKIP THIS: Go to FireFox's settings and configure your default downloads dir to be `/blue/bonniejdorr/$(whoami)`. By default the download will in `/home/$(whoami)/Downloads` and fill your home directory quota
11. Go to the resource portal and log in
12. Start the file download
13. Close your interactive Hipergator session. It will still run even if you aren't connected.
14. Periodically check to see if the download is done. Once done, terminate the interactive session.
15. To unzip the BabelNet indices, create a slurm script using 1 core and 2GB memory that just does `tar -xjvf babelnet-5.0-index.tar.bz2` or similar. The unzip job will take 1-2 hours so you don't want to waste login node resources on it

## Building the BabelNet Container Image

The BabelNet team distributes a docker image for serving the BabelNet indices, but Hipergator only supports apptainer, not Docker.

Fortunately you can build an apptainer version pretty easily:

1. Add `export APPTAINER_CACHEDIR=/blue/bonniejdorr/$(whoami)/apptainer_cache` to your `/home/$(whoami)/.bashrc file. This keeps apptainer from filling up your home directory quota with cache files
2. Go to your blue dir so the image file you build doesn't fill your home directory quota either: `cd /blue/bonniejdorr/$(whoami)`
3. `apptainer build babelnet-rpc.sif docker://babelscape/babelnet-rpc`

## Using the Server

1. `module load conda`
2. `conda env create -f environment.yml`
3. Modify the `sample_slurm.sh` script to meet your needs. Do make sure that whatever directory you run your python code in has the `babelnet_conf.yml` file.
4. sbatch sample_slurm.sh

I strongly discourage trying to do any significant logic in your script other than querying BabelNet and saving the results to be used later in another script.
Because the BabelNet Python API only supports Python 3.8, you can't use any up-to-date versions of Torch, Hugging Face, etc., in your code.

## Other Useful Resources
- [BabelNet API Docs](https://babelnet.org/guide)
- [BabelNet Python API](https://babelnet.org/pydoc/1.1/index.html)
