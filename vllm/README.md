# VLLM 

## Configure Your Environment Variables

Go through the [Hipergator Tutorial](../hipergator-setup/README.md) and make sure you have followed my environment var instructions for:
- [Triton](../hipergator-setup/README.md#triton)
- [FlashInfer](../hipergator-setup/README.md#flashinfer)
- [`XDG`](../hipergator-setup/README.md#xdg-dirs)

If you've done this, that should circumvent any `/scratch` errors with Torch Inductor.

## Cleanup After `/scratch` Errors
If you had issues with `/scratch`, that's probably because you didn't set up the environment variables like instructed.
You probably need to remove all the default cache dirs (because those cached files will still reference that `/scratch` dir):

```bash
# If you have your environment vars set up
rm -rf ~/.cache/vllm
rm -rf ~/.cache/flashinfer
rm -rf ~/.triton
```
You don't have to delete the torchinductor cache dir, since that old `/scratch` dir got deleted.

If you did set up the environment variables already, remove the directories they point to:
```bash
rm -rf $XDG_CACHE_HOME/vllm
rm -rf $FLASHINFER_WORKSPACE_BASE
rm -rf $TRITON_HOME
```

