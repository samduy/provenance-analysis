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

### Install some dependant modules (Optional, but recommended)

* [dicttoxml](https://pypi.python.org/pypi/dicttoxml): For outputing results in XML format.
```bash
pip install dicttoxml
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

##### Updated 20170921
By default, the final result will be saved to an XML file named `report.xml` in working directory.
This XML file supports XSL transformation so that it can be viewed as HTML with CSS style.

To view the result, please open the file with Firefox or any web browser.
```bash
$ firefox ./report.xml
```

### An example of output result

[Result table] ./result_table.jpg

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
