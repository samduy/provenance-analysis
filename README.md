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

## 3. View the result

By default, the final result will be printed out at the end of the analysis.
You can also view it again in the file named `report` in working directory.

### The format of the output result
#### Manual 
| Path | Name | Source | Updated | Active | Local version | Latest version | 
| :--- | :--- | :--- | :--- | :--- | :--- |:--- |
| /path/to/package1 | Package1 | Github | Y | Y | 1.0.2 | 1.0.2 | 
| /path/to/package2 | Package2 | Pip | N | Y | 0.0.2 | 1.0.5 |

#### APT 
| Path | Name |  Updated | Local version | Latest version | 
| :--- | :--- | :--- | :--- | :--- | 
| /path/to/package3 | Package3 |  Y | 1.0.2 | 1.0.2 | 
| /path/to/package4| Package4| N | 0.0.2 | 1.0.5 |

#### PIP
| Path | Name |  Updated | Local version | Latest version | 
| :--- | :--- | :--- | :--- | :--- | 
| /path/to/package5 | Package5 |  Y | 1.0.2 | 1.0.2 | 
| /path/to/package6| Package6| N | 0.0.2 | 1.0.5 |

## 4. Running log

In case something wrong happens and the analysis stops. You can check the error messages in a file named `.error.log`
```bash
$ tail -f .error.log
```

# Appendix
## Program name
Program Provenance Analysis: PROCERATO

The name of the project was inspired by:

* The word "PROvenance"
* The name of a dinosaur from Middle Jurassic: PROCERATOSAURUS (https://en.wikipedia.org/wiki/Proceratosaurus)
