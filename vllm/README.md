
## Configure your environment variables

Make sure you set your various XDG_ directories to fall under your blue directory like you were told in the [Hipergator Tutorial](../hipergator-setup/README.md)

Configure your torchinductor cache dir to point to blue, rather than the default of TMPDIR (this is what causes `/scratch/` path issues with vllm if you've encountered those):
```
echo 'export TORCHINDUCTOR_CACHE_DIR=$HOME/blue_dir/torchinductor_$(whoami)' >> ~/.bashrc
echo 'export TRITON_HOME=$HOME/blue_dir/' >> ~/.bashrc
```



## Defaults for those Cache Dirs
If you had issues with /scratch, you probably need to remove all the default cache dirs, then follow my instructions for setting the environment variables above.

- ~/vllm
- ~/.triton

Don't have to delete the torchinductor cache dir, since that old /scratch dir got deleted.
