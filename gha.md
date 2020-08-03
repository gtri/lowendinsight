# Lowendinsight GitHub Action
This is an action for Lowendinsight, a simple "bus-factor" risk analysis library for Open Source Software which is managed by the Georgia Tech Research Institute (GTRI). In its current state, this action works against both NPM and Mix based projects, currently existing in the develop branch of Lowendinsight.

## Usage

```yaml
name: lowendinsight

on: [push, pull_request]

jobs:
  request:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: gtri/lowendinsight@develop
```

Note that this action does not require any inputs.  Simply call it from a GitHub workflow and it will run an analysis on the GitHub repository where that workflow exists.

## Privacy
This action does not, nor will it ever, collect user data.  Any repository used is Lowendinsight's analysis is cloned and deleted without any information being collected by GTRI nor sent to a third party.