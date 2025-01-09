# Bash Basics

Bash is the typical terminal used by Linux and similar operating systems.
To learn these commands, it's strongly recommended to manually type these out in a terminal, rather than just reading them or copying them.
Much of Bash (like programming in general) is just "muscle memory."

Make sure to do this in a Bash terminal, like on Hipergator or Windows Subystem for Linux, and not on Windows Command Prompt (it uses different commands).


## Hello-World Script

Make a file called script.sh with the following contents:
```bash
#!/bin/bash
THIS_IS_A_VARIABLE="World"
echo Hello $THIS_IS_A_VARIABLE
```
Then run the following:
```bash
chmod +x script.sh # Makes the script executable.
./script.sh        # Runs the script
```
Bash makes you do the `chmod` command so you don't accidently try to "run" a file that isn't an actual program (like a text file).

Notice when you set a variable, you don't use a $.
When you want to actually use the value of a variable though, you prefix its name with a $.

The `#!/bin/bash` indicates what interpreter should be used to run your script.
You are allowed to put different interpreters for other scripting and programming languages: Perl, Python, etc.

Assuming you have Python3 installed somewhere, make the following `script.py` file:
```bash
#!/usr/bin/env python3
print("Hello world")
```
Then run the following:
```
chmod +x script.py
./script.py
```

Be sure to use `#!/usr/bin/env python3` instead of something like `/usr/bin/python3`.
The former will work even when you're using a Conda environment or similar; the latter will not.

## Printing File Contents

```bash
cat README.md       # Prints all the lines of README.md
cat README.md a.txt # Prints all the lines of README.md, then all the lines of a.txt
head -10 README.md  # Prints the first 10 lines of README.md. Great for huge files.
tail -10 README.md  # Prints the last 10 lines of README.md. Also great for huge files.
```

## Command Piping 
Make a file called `food.txt` with the following contents:
```
carrots
broccoli
CARROTS
```
Then run the following commands:
```bash
cat food.txt | grep carrots    # Prints one line
cat food.txt | grep -i carrots # Prints two lines
ls           | grep food       # Prints food.txt
```

Normally a command gets its input from whatever you type with the keyboard.
The pipe symbol `|`  instead takes the printed output from one command, and uses it as input to the next command.

The Global Regular Expresion and Print (grep) command is a popular utility for searching text.
It prints every line of input that has a match for the pattern you give it. `-i` tells it to be case-insensitive.

## Bash Variables
Let's I have two files, programA.sh and programB.sh.

Make a file called programA.sh with the following contents:
```bash
#!/bin/bash
echo $VARIABLE_1 $VARIABLE_2 $VARIABLE_3
```

Then make a file called programB.sh with the following contents:
```bash
#!/bin/bash
export VARIABLE_1="Carrots"
VARIABLE_2="Broccoli"
VARIABLE_3="Cauliflour" ./programA.sh
echo $VARIABLE_1 $VARIABLE_2 $VARIABLE_3
```

Then run the following:
```bash
chmod +x programA.sh programB.sh
./programB.sh
```

You should get the following output:
```
Carrots Cauliflour
Carrots Broccoli
```

The first line of output is from programA.sh.
programA.sh only has access to `VARIABLE_1` and `VARIABLE_3`.
When one program calls another sub-program, to share its variables with the subprogram, it either has to use the `export` keyword with the variable assignment, or put the variable assignment on the same line that it calls the subprogram.

The second line of output is from programB.sh.
programB.sh has access to `VARIABLE_1` and `VARIABLE_2`.
"In-line" variables like `VARIABLE_3` only exist for the lifetime of the subprogram getting called; they disappear afterwards.

Notice that in both cases, if a variable doesn't exist, Bash will just substitute an empty string for it.

## Command Substition
Sometimes you want to use store text printed from one command inside a variable:

```bash
#!/bin/bash
MY_CURRENT_DIR=$(pwd)
cd ..
cd $MY_CURRENT_DIR # now you're back where you were before
```
or maybe as part of another command:
```bash
cd /home/$(whoami)
```
`pwd` prints the path to your current working directory, while `whoami` prints your username.

## For Loops
Bash for-loops are really handy if running multiple experiments with different hyperparameter settings.
It's good to structure your script such that it takes command line arguments, making it easy for you to do this.

```bash
#!/bin/bash

for model_type in BERT XLM
do
    for dataset in biomedical.txt legal.txt
    do
        for learning_rate in 0.001 0.005 0.01
        do
            hyperparams="--model $model_type --dataset $dataset --lr $lr"
            echo Using the hyperparameters "$hyperparams"
            # Commenting this out because I didn't actually make an experiment.sh
            # ./my_experiment.sh $hyperparams
        done
    done
done
Each for-loop creates a variable, and the tokens after `in` are the different values that will get assigned to that variable.
```

## Symbolic Links

Say you have a file or folder with a really long path and you don't want to type it out. You can make a symlink or shortcut:

```bash
ln -s /etc/path/to/some/program/in/another/folder/program
./program
# Removing a link does not remove the original file: 
rm program
# Make a link to the same file, but with a custom name
ln -s /etc/path/to/some/program/in/another/folder/program my_program
./my_program
```

```bash
# Folder
ln -s /path/to/some/distant/folder
ls folder
```
If you want to remove the link to a folder, be sure to do this
```bash
rm folder
```
and not this:
```bash
# BAD!!!
# Follows the link to the folder, then removes everything inside the folder you're linking to.
rm folder/* 
```
