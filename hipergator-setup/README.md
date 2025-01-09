# Hipergator Setup

I recommend at least reading through [bash-basics](../bash-basics) first, even if you don't do the exercises.

## Blue and Orange Directories
You should store as little in your `/home/<username>` directory as possible, because you have a 30GB quota for that.
HPG offers blue and orange disk storage, and our lab at least as fairly high quotas.

Make symbolic links to them in your home directory, as that will make things easier for you:
```bash
cd ~
ln -s /blue/bonniejdorr/$(whoami) blue_dir
ln -s /orange/bonniejdorr/$(whoami) orange_dir
```
In general, only use orange storage for files you aren't going to look at for a while (like model checkpoints from past experiments).

A lot of applications will store data under your home directory by default.
Here's how to change the defaults for a few common ones we use:
```bash
# Natural Language Toolkit's data downloads
echo 'export NLTK_DATA=$HOME/blue_dir/datasets/nltk_data' >> ~/.bashrc
# Hugging face's downloads
echo 'export HF_HOME=$HOME/blue_dir/huggingface' >> ~/.bashrc
# Apptainer's caches
echo 'export APPTAINER_CACHEDIR=$HOME/blue_dir/apptainer_cache' >> ~/.bashrc
# Pip's caches
echo 'export PIP_CACHE_DIR=$HOME/blue_dir/pip_cache' >> ~/.bashrc
```

Conda is a bit more complicated as you need to change some command config files.
Add the following lines to your `~/.condarc` file:
```bash
pkgs_dirs:
  - /home/<type your username>/blue_dir/conda/pkgs
env_dirs:
  - /home/<type your username>/blue_dir/conda/envs
```
These lines were drawn from HPG's [excellent documentation](https://help.rc.ufl.edu/doc/Managing_Python_environments_and_Jupyter_kernels).

To check your (and the lab's) usage of the various storage directories, run the following commands:
```bash
home_quota
blue_quota
orange_quota
```
