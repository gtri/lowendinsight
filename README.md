# LowEndInsight

![build status](https://github.com/kitplummer/lowendinsight/workflows/default_elixir_ci/badge.svg?branch=master)

LowEndInsight is a simple "bus-factor" risk analysis library for Open
Source Software which is managed within a Git repository.  Provide the
git URL and the library will respond with a basic Elixir Map structure report.

If you are at all concerned about risks associated with upstream
dependency requirements LowEndInsight can provide valuable, and
actionable information around the likelihood of critical issues being
resolved, if ever reported.  For example, a repo with a single
contributor isn't necessarily bad, but it should be considered with some
level of risk.  Are you or your organization willing to assume ownership
(fork) of the repository to resolve issues yourself?  Or if there hasn't
been a commit against the source repository, in some significant
amount of time, can you assume that it is inactive, or just stable?

Again, the intent of LowEndInsight isn't to say that any upstream Open
Source dependency is bad, just that the risks should be smartly weighed,
and a deeper understanding of the implications should be gained during
the decision to use.  LowEndInsight provides a simple mechanism for
investigating and applying basic governance (based on your definition of
the tolerance level) and responds with a useful report for integrating
into your existing automation.  Or you can easily use LowEndInsight as
an ad-hoc reporting tool.
```
✗ mix analyze https://github.com/kitplummer/xmpp4rails | jq
{
  "metadata": {
    "repo_count": 1,
    "risk_counts": {
      "critical": 1
    },
    "times": {
      "duration": 1,
      "end_time": "2020-01-08T01:50:20.098278Z",
      "start_time": "2020-01-08T01:50:19.552588Z"
    }
  },
  "report": {
    "repos": [
      {
        "data": {
          "commit_currency_risk": "critical",
          "commit_currency_weeks": 573,
          "config": {
            "high_currency_level": 52,
            "critical_contributor_level": 2,
            "medium_large_commit_level": 0.05,
            "medium_currency_level": 26,
            "high_functional_contributors_level": 3,
            "medium_contributor_level": 5,
            "high_large_commit_level": 0.15,
            "high_contributor_level": 3,
            "critical_functional_contributors_level": 2,
            "critical_currency_level": 104,
            "critical_large_commit_level": 0.3,
            "medium_functional_contributors_level": 5
          },
          "contributor_count": 1,
          "contributor_risk": "critical",
          "functional_contributor_names": [
            "Kit Plummer"
          ],
          "functional_contributors": 1,
          "functional_contributors_risk": "critical",
          "large_recent_commit_risk": "low",
          "recent_commit_size_in_percent_of_codebase": 0.003683241252302026,
          "repo": "https://github.com/kitplummer/xmpp4rails",
          "risk": "critical"
        },
        "header": {
          "duration": 1,
          "end_time": "2020-01-08T01:50:20.084189Z",
          "library_version": "",
          "source_client": "mix task",
          "start_time": "2020-01-08T01:50:19.562877Z",
          "uuid": "3a0ea2f2-31b9-11ea-b537-784f434ce29a"
        }
      }
    ],
    "uuid": "3a0ed3a8-31b9-11ea-9cff-784f434ce29a"
  }
}
```

## Installation

NOTE: the library is not currently deployed to Hex, while awaiting approvals to
OSS.

[LowEndInsight available in Hex](https://hex.pm/packages/lowendinsight), the package can be installed
by adding `lowendinsight` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lowendinsight, "~> 0.2.1"}
  ]
end
```

NOTE: check hex.pm for the latest version.

## Running

You either need to have Elixir and Erlang installed locally or possibly
a container to run stuff in.

### REPL

```
iex -S mix
```

This will get you the `iex` prompt:

```
Interactive Elixir (1.9.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> AnalyzerModule.analyze "https://github.com/kitplummer/xmpp4rails", "iex"
{:ok,
 %{
   data: %{
     commit_currency_risk: "critical",
     commit_currency_weeks: 573,
     config: [
       high_contributor_level: 3,
       medium_currency_level: 26,
       medium_contributor_level: 5,
       medium_large_commit_level: 0.05,
       critical_large_commit_level: 0.3,
       medium_functional_contributors_level: 5,
       critical_functional_contributors_level: 2,
       high_functional_contributors_level: 3,
       high_large_commit_level: 0.15,
       critical_currency_level: 104,
       critical_contributor_level: 2,
       high_currency_level: 52
     ],
     contributor_count: 1,
     contributor_risk: "critical",
     functional_contributor_names: ["Kit Plummer"],
     functional_contributors: 1,
     functional_contributors_risk: "critical",
     large_recent_commit_risk: "low",
     recent_commit_size_in_percent_of_codebase: 0.003683241252302026,
     repo: "https://github.com/kitplummer/xmpp4rails",
     risk: "critical"
   },
   header: %{
     duration: 0,
     end_time: "2020-01-08T01:51:54.633837Z",
     library_version: "",
     source_client: "iex",
     start_time: "2020-01-08T01:51:54.069485Z",
     uuid: "726a728e-31b9-11ea-bfa9-784f434ce29a"
   }
 }}
```

Possibly a tip (if you're running Docker):

You can pass in this lib and configuration settings, into a base Elixir container.

```
docker run --rm -v $PWD:/app -w /app -it -e LEI_CRITICAL_CURRENCY_LEVEL=60 elixir:latest bash -c "mix local.hex;mix deps.get;iex -S mix"
```

From iex you can access to the library functions.

There is also an Elixir `mix` task that you can use to access the
`AnalyzeModule.analyze(url, client)` function.

```
mix analyze https://github.com/kitplummer/xmpp4rails, mix
```

## Docs?

This is the library piece of the puzzle.  There is a brewing API/service
interface that will expose this library to HTTP(S) POSTs.  Stay tuned,
it'll be open sourced shortly following this library.

The library is written in Elixir.

`mix docs` will generate static docs available within the project in the `docs/` subfolder.

### A Note about the metrics used
* Recent commit size: This is a measure of how large the most recent commit is in relatino to the size of the codebase. The idea being that a large recent commit is much more likely to be bug filled than a relatively small commit.
* Functional Contributors: A functional contributor is one that contributes above a certain percentage of commits equal to or greater than their "fair" share. Simply put, a contributor is counted as a functional contributor if the proportion of their commits to the total commits is greater than or equal to 1 / the total number of committers.  If everyone committed the same amount, everyone would be a functional contributor.
* `risk` is a top-level key that contains the "rolled up" risk, the
  highest value pulled from any of the discrete analysis items.

### Configuration

LowEndInsight allows for customization of the risk levels, to determine "low", "medium", "high" and "critical" acceptance.  The library reads this configuration from config.exs here, or as providing in environment variables.

```
## Contributor in terms of discrete users
  ## NOTE: this currently doesn't discern same user with different email
  critical_contributor_level: String.to_integer(System.get_env("LEI_CRITICAL_CONTRIBUTOR_LEVEL") || "2"),
  high_contributor_level: System.get_env("LEI_HIGH_CONTRIBUTOR_LEVEL") || 3,
  medium_contributor_level: System.get_env("LEI_CRITICAL_CONTRIBUTOR_LEVEL") || 5,

  ## Commit currency in weeks - is the project active.  This by itself
  ## may not indicate anything other than the repo is stable. The reason
  ## we're reporting it is relative to the likelihood vulnerabilities
  ## getting fix in a timely manner
  critical_currency_level: String.to_integer(System.get_env("LEI_CRITICAL_CURRENCY_LEVEL") || "104"),
  high_currency_level: String.to_integer(System.get_env("LEI_HIGH_CURRENCY_LEVEL") || "52"),
  medium_currency_level: String.to_integer(System.get_env("LEI_MEDIUM_CURRENCY_LEVEL") || "26"),

  ## Percentage of changes to repo in recent commit - is the codebase
  ## volatile in terms of quantity of source being changed
  critical_large_commit_level: String.to_float(System.get_env("LEI_CRITICAL_LARGE_COMMIT_LEVEL") || "0.30"),
  high_large_commit_level: String.to_float(System.get_env("LEI_HIGH_LARGE_COMMIT_LEVEL") || "0.15"),
  medium_large_commit_level: String.to_float(System.get_env("LEI_MEDIUM_LARGE_COMMIT_LEVEL") || "0.05"),

  ## Bell curve contributions - if there are 30 contributors
  ## but 90% of the contributions are from 2...
  critical_functional_contributors_level: String.to_integer(System.get_env("LEI_CRITICAL_FUNCTIONAL_CONTRIBUTORS_LEVEL") || "2"),
  high_functional_contributors_level: String.to_integer(System.get_env("LEI_HIGH_FUNCTIONAL_CONTRIBUTORS_LEVEL") || "3"),
  medium_functional_contributors_level: String.to_integer(System.get_env("LEI_MEDIUM_FUNCTIONAL_CONTRIBUTORS_LEVEL") || "5")
```

To override with an environment variable you just need to have it set:

```
LEI_CRITICAL_CURRENCY_PAR_LEVEL=60 mix analyze https://github.com/kitplummer/xmpp4rails
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

## License

BSD 3-Clause.  See https://opensource.org/licenses/BSD-3-Clause or LICENSE file for details.
