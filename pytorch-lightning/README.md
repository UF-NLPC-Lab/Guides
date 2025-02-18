# PyTorch Lightning

PyTorch Lightning is a library built on top of PyTorch that I use for most of my ML experimentation.
It's great for typical supervised learning tasks, but I can't speak to how easy it is to use for other ML tasks (GANs, reinforcement learning, etc.).

Our best example of how to use PyTorch Lightning is currently our [gatbert](https://github.com/UF-NLPC-Lab/gatbert) repo,
and we use it for the basis of our illustrations here. We prefer to only put information in that repo's README relevant to researchers outside our lab who just want to run the code.
You, on the other hand, are presumably a developer in the NLP&C Lab and need some additional background.

From the gatbert repo, do the following:
```bash
module load conda
conda activate gatbert
python -m gatbert fit --help
```

You'll see a large array of configurable parameters, most of which you or I will never use.
PyTorch Lightning is designed to minimize the amount of code changes you need to make to run different experiments by letting you change CLI or YAML parameters.

## YAML File Organization

I generally try to divide my Lightning parameters into the following YAML files:
- `base.yaml`: A file containing high-level parameters common to all my experiments (learning rate, logging directory, patience for early stopping, etc.) 
- `*_data.yaml`: File representing a specific dataset I want to test my model with
- `*_model.yaml`: File representing a specific model I weant to test

## Making a Slurm Script

Here is a sample Slurm script for running experiments.
We're going to address each of these elements in turn:

```bash
#!/bin/bash

#SBATCH --partition=gpu
#SBATCH --gres=gpu:a100:1
#SBATCH --time=6:00:00
#SBATCH --job-name=train_stance
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=12gb
#SBATCH --mail-user=youremail@ufl.edu
#SBATCH --mail-type=FAIL,END

# Commands recommended by HPG staff
date; pwd; hostname
export XDG_RUNTIME_DIR=${SLURM_TMPDIR}

# Set up the conda environment
module load conda
conda activate gatbert

# If you're not submitting this script from the repo dir itself,
# make sure you change to the repo dir
pushd /path/to/repo/gatbert

# Good to log what commit was used for reference later in your SLURM logs.
# Make sure you've actually committed your latest changes though.
git log -1

function run_exp()
{
    # Better to have a somewhat descriptive log dir name, rather than the default version_1, version_2, etc.
	version=v$(date +"%Y%m%d%H%M%S")
	CLI_ARGS="-c $BASE_CONFIG --classifier $MODEL --data $DATA_CONFIG --trainer.logger.init_args.version $version $EXTRA_ARGS"

	# Always print the config once first, for logging purposes.
	python -m gatbert.fit_and_test $CLI_ARGS --print_config

    # Then actually run the experiment
	python -m gatbert.fit_and_test $CLI_ARGS
}

BASE_CONFIG=/path/to/base.yaml

DATA_CONFIG=/path/to/graph_data.yaml
MODEL="gatbert.stance_classifier.HybridClassifier"
run_exp

MODEL="gatbert.stance_classifier.ExternalClassifier"
EXTRA_ARGS="--model.num_graph_layers 2"
run_exp

MODEL="gatbert.stance_classifier.ConcatClassifier"
EXTRA_ARGS="--model.num_graph_layers 2"
run_exp

DATA_CONFIG=$EXP_DIR/raw_data.yaml
MODEL="gatbert.stance_classifier.TextClassifier"
unset EXTRA_ARGS
run_exp
```

Notice we don't run `python -m gatbert fit` like you might see in Lightning's tutorials.
I've set up a custom main method that does training followed by evaluation, to make it easier to run small debugging experiments like these.
`-m gatbert fit` and `-m gatbert.fit_and_test` do take the same command-line arguments.

Also notice I don't specify a model config.
The `--classifier` in this case implicitly sets one of our model parameters (see [Argument Linking](#argument-linking)).
I set the rest of my model parameters with CLI parameters like `--model.num_graph_layers`.
In this case it's easier to specify just two parameters manually rather than make a new config file.

## Data and Results Storage

In general, all your datasets and your (immediate) experimental results should be stored in HPG's `/blue` storage.
For the former, this means putting the data somewhere under `/blue/` and the setting file paths inside your data YAML file appropriately.
For the latter, this means setting `logger.init_args.save_dir` in your [base.yaml](sample_configs/base.yaml) to some directory within `/blue`.

After your experiments have finished, I recommend moving the results dirs that were created to be under `/orange` storage, unless you plan on using the model checkpoints sometime soon.

## Argument Linking

First read [Lightning's tutorial](https://lightning.ai/docs/pytorch/stable/cli/lightning_cli_expert.html#argument-linking).

I typically use argument linking when setting a parameter for my neural module affects my data module, or vice versa.

Here is a good example pulled from gatbert:
```python
class CustomCLI(LightningCLI):
    def add_arguments_to_parser(self, parser):
        parser.add_argument("--pretrained_model", default=DEFAULT_MODEL)
        parser.link_arguments("pretrained_model", "model.pretrained_model")
        parser.link_arguments("pretrained_model", "data.init_args.tokenizer")

        parser.add_argument("--classifier", type=type[StanceClassifier], default=TextClassifier)
        parser.link_arguments("classifier", "model.classifier")
        parser.link_arguments("classifier", "data.init_args.classifier")
```

In this case, what `--pretrained_model` I use from Hugging Face should determine both one of my neural module's parameters and the tokenizer I use for my data.

Similarly, I have custom preprocessing logic set up for my different `*Classifier` types for converting raw text to tensors in the format they expect.
The neural module needs to know what type of Classifier it's wrapping, but my data module also needs to know what type of classifier it's preprocessing the data for.

I can specify these new top-level parameters on the CLI:
```bash
python -m gatbert.fit_and_test --pretrained_model bert-base-uncased --classifier gatbert.stance_classifier.TextClassifier
```
or as top-level parameters in my `base.yaml` file:
```yaml
pretrained_model: bert-base-uncaseed
classifier: gatbert.stance_classifier.TextClassifier
```