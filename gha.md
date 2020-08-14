# Lowendinsight GitHub Action
This is an action for Lowendinsight, a simple "bus-factor" risk analysis library for Open Source Software which is managed by the Georgia Tech Research Institute (GTRI). In its current state, this action works against both NPM and Mix based projects, currently existing in the develop branch of Lowendinsight. When run against a GitHub repository, a `.json` file will be generated of the format `lei--Y-m-d--H-M-S.json` and pushed to that repository's root directory by default.

## Usage
```yaml
name: LEI
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: actions/checkout@master
      with:
        persist-credentials: false # otherwise, the token used is the GITHUB_TOKEN, instead of your personal token
        fetch-depth: 0 # otherwise, you will fail to push refs to dest repo
    - name: Generate Report
      uses: gtri/lowendinsight@gha
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

| name | value | default | description |
| ---- | ----- | ------- | ----------- |
| github_token | string | | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}`. |
| branch | string | 'master' | Destination branch to push changes. |
| force | boolean | false | Determines if force push is used. |
| tags | boolean | false | Determines if `--tags` is used. |
| directory | string | '.' | Directory to change to before pushing. |
| repository | string | '' | Repository name. Default or empty repository name represents current github repository. If you want to push to other repository, you should make a [personal access token]

## Privacy
This action does not, nor will it ever, collect user data.  Any repository used is Lowendinsight's analysis is cloned and deleted without any information being collected by GTRI nor sent to a third party.