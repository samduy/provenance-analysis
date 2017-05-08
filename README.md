# Manual
## 0. Prerequisites

You will need a GitHub-API OAUTH token key to use in this program.
Please go to <https://developer.github.com/v3/oauth/> and get your own key, and save it to a file named `token` under the root directory of this program.

## 1. To start analysing

After download all the files from this repo, you only need to run:

```
$ make DIR="/path/to/directories/you/want/to/scan /another/dir"
```

E.g:
```
$ make DIR="/"
```

Or:
```
$ make DIR="/usr/lib /usr/share"
```

Or, simply run:
```
$ make
```
(The default directories will be scanned).

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
