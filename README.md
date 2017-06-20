# Manual
## 0. Prerequisites

### GitHub API (Mandatory)
You will need a GitHub-API OAUTH token key in order to use this program.
Please go to <https://github.com/settings/tokens> and get your own key, and save it to a file named `token` under the root directory of this program.

(More on [GitHub OAUTH](https://developer.github.com/v3/oauth/))

### Update APT (Optional)
```bash
$ sudo apt-get update
```

### Install some dependant modules (Optional)

* [tabulate](https://pypi.python.org/pypi/tabulate): For nicer table result.
```bash
pip install tabulate
```

## 1. To start analysing

After download all the files from this repo, you only need to run:

```
$ make
```
By default the whole machine (`"/"`) will be scanned.

If you want to scan specific director(y|ies) only, please specify in the `make` command as following:
```
$ make DIR="/home /usr/"
```

**IMPORTANT**: Make sure you have your GitHub key ready, you will be prompted to provide it in case you haven't done it before.

## 2. To clean all the result

```
$ make clean-all
```

# Appendix
## Program name
Program Provenance Analysis: PROCERATO

The name of the project was inspired by:

* The word "PROvenance"
* The name of a dinosaur from Middle Jurassic: PROCERATOSAURUS (https://en.wikipedia.org/wiki/Proceratosaurus)
