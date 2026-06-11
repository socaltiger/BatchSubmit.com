# Jenner compatibility tests

This directory was added by a pull request from the
[Jenner](https://jenneranalytics.com) project. Each `tNNN_*` subdirectory
contains one SAS script taken from this repository, paired with the output
Jenner produced when it ran that script. The goal is to show that
Jenner — a SAS-compatible engine with an HTTP API — runs code that looks
like yours.

## What's in here

```
jenner-check/
├── README.md            # this file
├── run_jenner.sas       # runner for base SAS (PROC HTTP)
├── run_jenner.sh        # runner for mac/linux (bash + curl)
├── run_jenner.bat       # runner for Windows
└── tNNN_<name>/
    ├── script.sas       # the script under test (from this repo)
    ├── autoexec.sas     # per-bundle setup (parameters, options)
    ├── expected.json    # stable fields pinned from a passing run
    ├── expected/        # human-readable snapshot of that run
    │   ├── log.txt      #   the run log
    │   ├── output.txt   #   the listing output
    │   └── files.md     #   links to generated files/datasets
    └── meta.json        # provenance: source file, commit, notes
```

Scripts that BatchSubmit normally parameterizes through its `.par`
files (for example `QuadEquation.sas`) get the same `&parmN` macro
variables set in their bundle's `autoexec.sas` — the scripts themselves
are unmodified.

## How to run

From this directory, with bash and curl (macOS / Linux):

```bash
./run_jenner.sh --all            # run every bundle
./run_jenner.sh t002_quadequation # or just one
```

From base SAS:

```sas
%include 'run_jenner.sas';
%jenner_check_all();
```

Or POST any single script straight to the API:

```bash
curl -X POST https://api.jenneranalytics.com/v1/run \
  -F "script=@t002_quadequation/script.sas" -F "timeout=60"
```
