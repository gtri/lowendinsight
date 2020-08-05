# LowEndInsight

![build status](https://github.com/gtri/lowendinsight/workflows/default_elixir_ci/badge.svg?branch=develop) ![Hex.pm](https://img.shields.io/hexpm/v/lowendinsight) [![Coverage Status](https://coveralls.io/repos/github/gtri/lowendinsight/badge.svg?branch=develop)](https://coveralls.io/github/gtri/lowendinsight?branch=develop)

CAVEAT: Version 0.6.0 includes breaking changes to the analyze function -> upgrading from 0.5.0 to 0.6.0 will require you to pass in a couple
extra arguments to the analyze function:

```
AnalyzerModule.analyze(["https://github.com/gtri/lowendinsight","https://github.com/gtri/lowendinsight-get"], "iex", DateTime.utc_now(), %{types: true})
```

In version 0.6.0 the `DateTime.utc_now()` and new `options` field `%{types: true}` are required.

<img src="lei_bus_128.png" style="float: left;margin-right: 10px;margin-top: 10px;"> LowEndInsight is a simple "bus-factor" risk analysis library for Open
Source Software which is managed within a Git repository.  Provide the
git URL and the library will respond with a basic Elixir Map structure report. (There is a desire to make this a struct.)

If you are at all concerned about risks associated with upstream
dependency requirements LowEndInsight can provide valuable, and
actionable information around the likelihood of critical issues being
resolved, if ever reported.  For example, a repo with a single
contributor isn't necessarily bad, but it should be considered with some
level of risk.  Are you or your organization willing to assume ownership
(fork) of the repository to resolve issues yourself?  Or if there hasn't
been a commit against the source repository, in some significant
amount of time, can you assume that it is inactive, or just stable?

While, in terms of DevSecOps, we are moving towards automation of vulnerability scanning, this doesn't tell the whole picture.  First problem is that not all vulnerabilities are found, nor are all reported.  So perhaps some risk reduction should be applied at the dependency inclusion steps.

Again, the intent of LowEndInsight isn't to say that any upstream Open
Source dependency is bad, just that the risks should be smartly weighed,
and a deeper understanding of the implications should be gained during
the decision to use.  LowEndInsight provides a simple mechanism for
investigating and applying basic governance (based on a definition of
the tolerance level, which you can easily override) and responds with a useful report for integrating into your existing DevSecOps automation.  Or, you can easily use LowEndInsight as an ad-hoc reporting tool, running it manually as part of an [ADR](https://github.com/joelparkerhenderson/architecture_decision_record).
```
✗ mix lei.analyze https://github.com/facebook/react | jq
{
  "state": "complete",
  "report": {
    "uuid": "4d1e2b08-7b68-11ea-9ca1-88e9fe666193",
    "repos": [
      {
        "header": {
          "uuid": "4d1dbee8-7b68-11ea-93b9-88e9fe666193",
          "start_time": "2020-04-10T20:15:34.912972Z",
          "source_client": "mix task",
          "repo": "https://github.com/facebook/react",
          "library_version": "",
          "end_time": "2020-04-10T20:17:28.867848Z",
          "duration": 114
        },
        "data": {
          "risk": "low",
          "results": {
            "top10_contributors": [
              {
                "name": "Paul O’Shannessy",
                "merges": 959,
                "email": "paul@oshannessy.com",
                "contributions": 1777
              },
              {
                "name": "Dan Abramov",
                "merges": 86,
                "email": "dan.abramov@gmail.com",
                "contributions": 1356
              },
              {
                "name": "Sophie Alpert",
                "merges": 392,
                "email": "git@sophiebits.com",
                "contributions": 1265
              },
              {
                "name": "Brian Vaughn",
                "merges": 101,
                "email": "bvaughn@fb.com",
                "contributions": 995
              },
              {
                "name": "Sebastian Markbåge",
                "merges": 141,
                "email": "sebastian@calyptus.eu",
                "contributions": 803
              },
              {
                "name": "Jim Sproch",
                "merges": 327,
                "email": "jsproch@fb.com",
                "contributions": 456
              },
              {
                "name": "Brian Vaughn",
                "merges": 65,
                "email": "brian.david.vaughn@gmail.com",
                "contributions": 363
              },
              {
                "name": "Dominic Gannaway",
                "merges": 6,
                "email": "trueadm@users.noreply.github.com",
                "contributions": 336
              },
              {
                "name": "Pete Hunt",
                "merges": 126,
                "email": "floydophone@gmail.com",
                "contributions": 332
              },
              {
                "name": "Andrew Clark",
                "merges": 2,
                "email": "acdlite@fb.com",
                "contributions": 264
              }
            ],
            "recent_commit_size_in_percent_of_codebase": 0.00032,
            "large_recent_commit_risk": "low",
            "functional_contributors_risk": "low",
            "functional_contributors": 84,
            "functional_contributor_names": [
              "yiminghe",
              "Marshall Roch",
              "Flarnie Marchan",
              "Daniel Lo Nigro",
              "Philipp Spieß",
              "Edvin Erikson",
              "Mateusz Burzyński",
              "Pete Hunt",
              "petehunt",
              "Ingvar Stepanyan",
              "Jordan Walke",
              "Jim",
              "chico",
              "Rauno Freiberg",
              "Stefan Dombrowski",
              "Keyan Zhang",
              "Benjamin Woodruff",
              "Nicolas Gallagher",
              "CommitSyncScript",
              "Joe Critchley",
              "Simen Bekkhus",
              "fisherwebdev",
              "Andrey Popp",
              "Lee Byron",
              "Shim Won",
              "Christoph Pojer",
              "Lucas Cordeiro",
              "Bartosz Kaszubowski",
              "Sasha Aickin",
              "Heaven",
              "Charles Marsh",
              "Kohei TAKATA",
              "Cheng Lou",
              "Dustan Kasten",
              "Dominic Gannaway",
              "Ivan Zotov",
              "Sophie Alpert",
              "Josh Duck",
              "Tim Yung",
              "Sunil Pai",
              "Timothy Yung",
              "Thomas Aylott",
              "Isaac Salier-Hellendag",
              "iamchenxin",
              "Raphael Amorim",
              "Brian Vaughn",
              "Jinwoo Oh",
              "Ivan Babak",
              "Nathan Hunzaker",
              "Paul O’Shannessy",
              "Alex Smith",
              "Paul O'Shannessy",
              "Sebastian Markbage",
              "Tom Occhino",
              "Jan Kassens",
              "Kunal Mehta",
              "Luna Ruan",
              "Baraa Hamodi",
              "Christopher Chedeau",
              "Ben Newman",
              "jim",
              "Clement Hoang",
              "Hristo Kanchev",
              "Scott Feeney",
              "Connor McSheffrey",
              "Brandon Dail",
              "Paul Shen",
              "Nate Hunzaker",
              "Vjeux",
              "Jared Forsyth",
              "Eli White",
              "cpojer",
              "Andrew Clark",
              "Toru Kobayashi",
              "Dan",
              "Jeff Morrison",
              "Sebastian Markbåge",
              "Dan Abramov",
              "Rick Beerendonk",
              "Andreas Svensson",
              "Fabio M. Costa",
              "yungsters",
              "Ben Alpert",
              "Jason Quense"
            ],
            "contributor_risk": "low",
            "contributor_count": 1505,
            "commit_currency_weeks": 0,
            "commit_currency_risk": "low"
          },
          "repo_size": "185M",
          "repo": "https://github.com/facebook/react",
          "project_types": {
            "node": [
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/art/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/attribute-behavior/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/concurrent/time-slicing/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/dom/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/eslint/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/eslint/proxy/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/expiration/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/fiber-debugger/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/flight/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/browserify/dev/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/browserify/prod/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/brunch/dev/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/brunch/prod/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/rjs/dev/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/rjs/prod/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/systemjs-builder/dev/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/systemjs-builder/prod/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/webpack-alias/dev/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/webpack-alias/prod/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/webpack/dev/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/packaging/webpack/prod/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/fixtures/ssr/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/create-subscription/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/dom-event-testing-library/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/eslint-plugin-react-hooks/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/jest-mock-scheduler/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/jest-react/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/legacy-events/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-art/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-cache/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-client/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-debug-tools/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-devtools-core/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-devtools-extensions/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-devtools-inline/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-devtools-shared/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-devtools-shared/src/node_modules/react-window/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-devtools-shell/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-devtools/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-dom/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-flight-dom-relay/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-flight-dom-webpack/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-interactions/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-is/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-native-renderer/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-noop-renderer/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-reconciler/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-refresh/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-server/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react-test-renderer/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/react/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/scheduler/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/shared/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/packages/use-subscription/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/scripts/bench/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/scripts/eslint-rules/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/scripts/perf-counters/package.json",
              "/tmp/lei-1586549734-63434-1b1so9e/react/scripts/release/package.json"
            ]
          },
          "git": {
            "hash": "8e13f099ab0c820c6f97547ad08244340e074266",
            "default_branch": "refs/remotes/origin/master"
          },
          "config": {
            "medium_large_commit_level": 0.2,
            "medium_functional_contributors_level": 5,
            "medium_currency_level": 26,
            "medium_contributor_level": 5,
            "high_large_commit_level": 0.3,
            "high_functional_contributors_level": 3,
            "high_currency_level": 52,
            "high_contributor_level": 3,
            "critical_large_commit_level": 0.4,
            "critical_functional_contributors_level": 2,
            "critical_currency_level": 104,
            "critical_contributor_level": 2,
            "base_temp_dir": "/tmp"
          }
        }
      }
    ]
  },
  "metadata": {
    "times": {
      "start_time": "2020-04-10T20:15:34.901638Z",
      "end_time": "2020-04-10T20:17:28.885951Z",
      "duration": 114
    },
    "risk_counts": {
      "low": 1
    },
    "repo_count": 1
  }
}
```

NOTE: that the "file://" is also supporting, but presumes that the directory provided
is a valid Git clone.  Analysis of a file://-based repo will not conclude with the
directory structure being removed.

## Installation

[LowEndInsight available in Hex](https://hex.pm/packages/lowendinsight), the package can be installed
by adding `lowendinsight` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lowendinsight, "~> 0.5"}
  ]
end
```

NOTE: check hex.pm for the latest version.

## Running

You either need to have Elixir and Erlang installed locally or possibly
a container to run stuff in.

### Mix Task for Scanning in a Mix-based Project

It is also possible to drop this in as a library dependency to your Mix-based Elixir project.  Simply add
the library to your project's dependencies:

```
defp deps do
  [
    {:lowendinsight, "~> 0.5", except: :prod, runtime: false}
  ]
end
```

Then run `mix deps.get`, and `mix lei.scan`.  This will produce a report for the dependencies (and transitive dependencies) specified in your Mix definition.

You'll get a full report:

```
➜  lei_scanner_test mix lei.scan
{
  "state": "complete",
  "report": {
    "uuid": "3084c312-65ab-11ea-b49b-88e9fe666193",
    "repos": [
      {
        "header": {
          "uuid": "2fc3853a-65ab-11ea-849f-88e9fe666193",
          "start_time": "2020-03-14T04:20:47.357888Z",
          "source_client": "mix.scan",
          "library_version": "",
          "end_time": "2020-03-14T04:20:50.335877Z",
          "duration": 3
        },
        "data": {
          "risk": "low",
...
```

It is also possible to scan against a different repo locally by
passing the absolute path to the directory where it is cloned:

```
mix lei.scan /some/path/to/a/git/repo
```
### Scanning in a NPM-Based Project
Lowendinsight can now be run against NPM-Based projects. To do so, simply clone the repository and run the following from lowendinsight's root directory.
```
mix deps.get
mix lei.scan /some/path/to/a/git/repo
```
It is important to note that though lowendinsight works on NPM-based projects, scanning still requires a local installation of Mix.

At the least, the above requires an existing `package.json` file in order to scan the first-degree dependencies of an NPM-based project.  A complete scan of both first-degree and transitive dependencies requires a `package-lock.json` file. In other words, due to how NPM handles dependencies, a complete scan of a repository can only be accomplished if all of its dependencies are listed in `package-lock.json`.

In the scope of `package.json`, dependencies listed in both `devDependencies` and `dependencies` are scanned. Future iterations of lowendinsight could offer the ability to disable `devDependencies` from being scanned.

### Mix Task for Generating a Dependencies JSON List

```
mix lei.dependencies /some/path/to/a/Mix-based-project
```

### Governance/Parameter Configuration

The library uses a baseline configuration for each of the metrics calculated.  If you want to set your own, all you need to do is add the `:lowendinsight` configuration as mentioned below in the *Configuration* section.  Tuning of these defaults will likely happen over time, as analysis continues to run on a large scale.  The analysis will be made available here soon.

### REPL

```
iex -S mix
```

This will get you the `iex` prompt:

```
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> AnalyzerModule.analyze "https://github.com/kitplummer/xmpp4rails", "iex", %{types: false}
{:ok,
 %{
   data: %{
     config: %{
       base_temp_dir: "/tmp",
       critical_contributor_level: 2,
       critical_currency_level: 104,
       critical_functional_contributors_level: 2,
       critical_large_commit_level: 0.4,
       high_contributor_level: 3,
       high_currency_level: 52,
       high_functional_contributors_level: 3,
       high_large_commit_level: 0.3,
       medium_contributor_level: 5,
       medium_currency_level: 26,
       medium_functional_contributors_level: 5,
       medium_large_commit_level: 0.2
     },
     git: %{
       default_branch: "refs/remotes/origin/master",
       hash: "f47ee5f5ef7fb4dbe3d5d5f54e278ea941cb0332"
     },
     project_types: %{},
     repo: "https://github.com/kitplummer/xmpp4rails",
     repo_size: "292K",
     results: %{
       commit_currency_risk: "critical",
       commit_currency_weeks: 584,
       contributor_count: 1,
       contributor_risk: "critical",
       functional_contributor_names: ["Kit Plummer"],
       functional_contributors: 1,
       functional_contributors_risk: "critical",
       large_recent_commit_risk: "low",
       recent_commit_size_in_percent_of_codebase: 0.00368,
       top10_contributors: [%{"Kit Plummer" => 7}]
     },
     risk: "critical"
   },
   header: %{
     duration: 0,
     end_time: "2020-03-22T23:45:06.563532Z",
     library_version: "",
     repo: "https://github.com/kitplummer/xmpp4rails",
     source_client: "iex",
     start_time: "2020-03-22T23:45:06.078198Z",
     uuid: "28a109ba-6c97-11ea-be3d-88e9fe666193"
   }
 }}
```

Here's the command that you would paste in to the `iex` REPL as an example:

```
AnalyzerModule.analyze "https://github.com/kitplummer/xmpp4rails", "iex", %{types: false}
```

### Docker

You can pass in this lib and configuration settings, into a base Elixir container.  From the root directory of a clone of this repo run this:

```
docker run --rm -v $PWD:/app -w /app -it -e LEI_CRITICAL_CURRENCY_LEVEL=60 elixir:latest bash -c "mix local.hex;mix deps.get;iex -S mix"
```

From iex you can access to the library functions.

```
Erlang/OTP 22 [erts-10.6.3] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Interactive Elixir (1.10.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> AnalyzerModule.analyze(["https://github.com/kitplummer/xmpp4rails"], "iex", DateTime.utc_now(), %{types: true})
{:ok,
 %{
   metadata: %{
     repo_count: 1,
     risk_counts: %{"critical" => 1},
     times: %{
       duration: 1,
       end_time: "2020-02-08T04:35:35.109053Z",
       start_time: "2020-02-08T04:35:34.078971Z"
     }
   },
   report: %{
     repos: [
       %{
...
}
```

### Mix Tasks for Analyzing Repos

There is also an Elixir `mix` task that you can use to access the
`AnalyzeModule.analyze(url, client)` function.  So if have this repo cloned:

*mix lei.analyze*

```
mix lei.analyze https://github.com/kitplummer/xmpp4rails | jq
```

This will return:

```json
{
  "state": "complete",
  "report": {
    "uuid": "86ac4538-4a28-11ea-897f-82dd17abe001",
    "repos": [
      {
        "header": {
          "uuid": "86ac38f4-4a28-11ea-89c1-82dd17abe001",
          "start_time": "2020-02-08T04:07:29.736126Z",
          "source_client": "mix task",
...
}
```

There also is a batch/bulk processor:

*mix lei.bulk_analyze*

```
mix lei.bulk_analyze "./test/scan_list_test" | jq
```

The expected file is a simple list of URLs, one per line like this:

```
https://github.com/gtri/lowendinsight
https://github.com/gtri/lowendinsight-get
```

### GitHub Action
Lowendinsight can also be added to a GitHub workflow as an action. In its current state, it works against both NPM and Mix based projects. This action currently exists in the develop branch. The following is an example usage:

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

#### Inputs

| name | value | default | description |
| ---- | ----- | ------- | ----------- |
| github_token | string | | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}`. |
| branch | string | 'master' | Destination branch to push changes. |
| force | boolean | false | Determines if force push is used. |
| tags | boolean | false | Determines if `--tags` is used. |
| directory | string | '.' | Directory to change to before pushing. |
| repository | string | '' | Repository name. Default or empty repository name represents current github repository. If you want to push to other repository, you should make a [personal access token]

#### Privacy
This action does not, nor will it ever, collect user data.  Any repository used is Lowendinsight's analysis is cloned and deleted without any information being collected by GTRI nor sent to a third party.


### LowEndInsight REST-y API

Also, there is a sister project that wraps this library and provides an HTTP-based interface.

https://github.com/gtri/lowendinsight-get

## Docs

API available at: https://hexdocs.pm/lowendinsight/readme.html#content

This is the library piece of the puzzle.  As mentioned above there is an HTTP API available as well.

The library is written in Elixir.

`mix docs` will generate static docs available locally within the repo's root, in the `docs/` subdirectory.

### JSON Schema

LowEndInsight makes available the API's schema in JSON form, which can be found in the `schema/` subdirectory. In addition, the schema docs are available in `schema/docs` as Markdown.

### A Note about the metrics used
* Recent commit size: This is a measure of how large the most recent commit is in relatino to the size of the codebase. The idea being that a large recent commit is much more likely to be bug filled than a relatively small commit.
* Functional Contributors: A functional contributor is one that contributes above a certain percentage of commits equal to or greater than their "fair" share. Simply put, a contributor is counted as a functional contributor if the proportion of their commits to the total commits is greater than or equal to 1 / the total number of committers.  If everyone committed the same amount, everyone would be a functional contributor.
* Currency is a bit of insight into the activity of the source repo.  This value as a measure of risk, again, isn't to state that the repo is bad. The project simply could be stable. But, it could also mean that the project is unmaintained and that as an attribute of the decision making process around whether to not consume should be considered.
* `risk` is a top-level key that contains the "rolled up" risk, the
  highest value pulled from any of the discrete analysis items.

### Configuration

LowEndInsight allows for customization of the risk levels, to determine "low", "medium", "high" and "critical" acceptance.  The library reads this configuration from config.exs (or dev|test|prod.exs) as seen here, or as providing in environment variables.

```
config :lowendinsight,
  ## Contributor in terms of discrete users
  ## NOTE: this currently doesn't discern same user with different email
  critical_contributor_level:
    String.to_integer(System.get_env("LEI_CRITICAL_CONTRIBUTOR_LEVEL") || "2"),
  high_contributor_level: System.get_env("LEI_HIGH_CONTRIBUTOR_LEVEL") || 3,
  medium_contributor_level: System.get_env("LEI_CRITICAL_CONTRIBUTOR_LEVEL") || 5,

  ## Commit currency in weeks - is the project active.  This by itself
  ## may not indicate anything other than the repo is stable. The reason
  ## we're reporting it is relative to the likelihood vulnerabilities
  ## getting fix in a timely manner
  critical_currency_level:
    String.to_integer(System.get_env("LEI_CRITICAL_CURRENCY_LEVEL") || "104"),
  high_currency_level: String.to_integer(System.get_env("LEI_HIGH_CURRENCY_LEVEL") || "52"),
  medium_currency_level: String.to_integer(System.get_env("LEI_MEDIUM_CURRENCY_LEVEL") || "26"),

  ## Percentage of changes to repo in recent commit - is the codebase
  ## volatile in terms of quantity of source being changed
  critical_large_commit_level:
    String.to_float(System.get_env("LEI_CRITICAL_LARGE_COMMIT_LEVEL") || "0.40"),
  high_large_commit_level:
    String.to_float(System.get_env("LEI_HIGH_LARGE_COMMIT_LEVEL") || "0.30"),
  medium_large_commit_level:
    String.to_float(System.get_env("LEI_MEDIUM_LARGE_COMMIT_LEVEL") || "0.20"),

  ## Bell curve contributions - if there are 30 contributors
  ## but 90% of the contributions are from 2...
  critical_functional_contributors_level:
    String.to_integer(System.get_env("LEI_CRITICAL_FUNCTIONAL_CONTRIBUTORS_LEVEL") || "2"),
  high_functional_contributors_level:
    String.to_integer(System.get_env("LEI_HIGH_FUNCTIONAL_CONTRIBUTORS_LEVEL") || "3"),
  medium_functional_contributors_level:
    String.to_integer(System.get_env("LEI_MEDIUM_FUNCTIONAL_CONTRIBUTORS_LEVEL") || "5"),

  ## Jobs per available core for defining max concurrency.  This value
  ## will be used to set the max_concurrency value.
  jobs_per_core_max: String.to_integer(System.get_env("LEI_JOBS_PER_CORE_MAX") || "2")
```

To override with an environment variable you just need to have it set:

```
LEI_CRITICAL_CURRENCY_PAR_LEVEL=60 mix lei.scan
```

If you receive an error in the report with the following (or similar missing environment configuration variable) - the required configuration for LowEndInsight hasn't been made available:

```
could not fetch application environment :critical_contributor_level for application :lowendinsight because the application was not loaded/started. If your application depends on :lowendinsight at runtime, make sure to load/start it or list it under :extra_applications in your mix.exs file
```

## Contributing

Thanks for considering, we need your contributions to help this project come to fruition.

Here are some important resources:

  * Bugs? [Issues](https://bitbucket.org/kitplummer/lowendinsight/issues/new) is where to report them

### Style

The repo includes auto-formatting, please run `mix format` to format to
the standard style prescribed by the Elixir project:

https://hexdocs.pm/mix/Mix.Tasks.Format.html
https://github.com/christopheradams/elixir_style_guide

Code docs for functions are expected.  Examples are a bonus:

https://hexdocs.pm/elixir/writing-documentation.html

### Testing

Required. Please write ExUnit test for new code you create.

Use `mix test --cover` to verify that you're maintaining coverage.


### Github Actions

Just getting this built-out.  But the bitbucket-pipeline config is still
here too.

### Submitting changes

Please send a [Pull Request](https://bitbucket.org/kitplummer/lowendinsight/pull-requests/) with a clear list of what you've done and why. Please follow Elixir coding conventions (above in Style) and make sure all of your commits are atomic (one feature per commit).

Always write a clear log message for your commits. One-line messages are fine for small changes, but bigger changes should look like this:

    $ git commit -m "A brief summary of the commit
    >
    > A paragraph describing what changed and its impact."

### JSON Schema

The JSON schema found in `schema` is and should be used to validate the main analysis interfaces' input and expected outputs. Any modifications in implementations should also be made to the schemas and verified/validated by tests.

There is an external tool used to do the schema docs conversion: `jsonschema2md -d schema/ -o schema/docs`. If you make a modification to the schema please run the tool to update the docs with the submission.

`jsonschema2md` is a Node.js tool.

## License

BSD 3-Clause.  See https://opensource.org/licenses/BSD-3-Clause or LICENSE file for details.

There is code in this project [`mixfile.ex` and `encoder.ex`], taken from [mix-deps-json](https://github.com/librariesio/mix-deps-json), that is copyright:

Copyright (c) 2016 Andrew Nesbitt.

Blatant attribution: https://github.com/andrew

And licensed with the MIT license.  See the [mix-deps-json](https://github.com/librariesio/mix-deps-json) for more details.

For a bit of insight into the licensing part of inclusion within another licensed repo, there's [this](https://softwareengineering.stackexchange.com/questions/121998/mit-vs-bsd-vs-dual-license), which is really interesting.

The logic for pulling the code in versus the project as a dependency is that `mix-deps-json` is really a server I the transitive dependencies aren't worth the weight.
