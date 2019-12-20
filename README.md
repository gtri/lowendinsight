# LowEndInsight

![build status](https://github.com/kitplummer/lowendinsight/workflows/Elixir%20CI/badge.svg?branch=master)

LowEndInsight is a simple "bus-factor" risk analysis library for Open
Source Software which is managed within a Git repository.  Provide the
git URL and the library will respond with a basic Elixir Map structure report.

If you are at all concerned about risks associated with upstream
dependency requirements LowEndInsight can provide valuable, and
actionable information around the likelihood of critical issues being
resolved, if ever reported.  For example, a repo with a single
contributor isn't necessarily bad, but it should be considered with some
level of risk.  Are you or your organization willing to assume ownership
(fork) the repository to resolve issues yourself?  Or if there hasn't
been a commit, action against the source repository, in some significant
amount of time, can you assume that it is inactive, or just stable?

```
✗ mix analyze https://github.com/kitplummer/xmpp4rails | jq
{
  "data": {
    "repos": [
      {
        "data": {
          "commit_currency_risk": "critical",
          "commit_currency_weeks": 566,
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
          "duration": 0,
          "end_time": "2019-11-14 13:28:48.543895Z",
          "source_client": "mix task",
          "start_time": "2019-11-14 13:28:48.081742Z",
          "uuid": "b0b9921a-06e2-11ea-9a3c-784f434ce29a"
        }
      }
    ]
  },
  "metadata": {
    "repo_count": 1,
    "risk_counts": {
      "critical": 1
    }
  }
}
```

## Installation

NOTE: the library is not currently deployed to Hex, while awaiting approvals to
OSS.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lowendinsight` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:lowendinsight, "~> 0.1.0"}
  ]
end
```

## Running

You either need to have Elixir and Erlang installed locally or possibly
a container to run stuff in.

### REPL

```
iex -S mix
```

This will get you the `iex` prompt:

```
Interactive Elixir (1.9.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> AnalyzerModule.analyze "https://github.com/kitplummer/xmpp4rails", "lib"
{:ok,
 %{
   data: %{
     commit_currency_risk: "critical",
     commit_currency_weeks: 566,
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
     duration: 1,
     end_time: "2019-11-14 13:30:42.187082Z",
     source_client: "lib",
     start_time: "2019-11-14 13:30:41.076329Z",
     uuid: "f4762608-06e2-11ea-ad1c-784f434ce29a"
   }
 }}
```

Possibly a tip (if you're running Docker):

You can pass in this lib, into a base Elixir container.

```
docker run -i --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp elixir iex -S mix
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
