#e GithubModule

**TODO: Add description**

## Installation

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
Erlang/OTP 22 [erts-10.4.4] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe] [dtrace]

Interactive Elixir (1.9.0) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> AnalyzerModule.analyze "https://github.com/kitplummer/xmpp4rails", "lib"
"{\"repo\":\"https://github.com/kitplummer/xmpp4rails\",\"contributor_count\":1,\"contributor_risk\":\"critical\",\"commit_currency_weeks\":558,\"commit_currency_risk\":\"critical\"}"
```

Possibly a tip:

```
docker run -i --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp elixir iex -S mix
```

From iex you can access to the library functions.

There is also a `mix` task that you can use to access the
`AnalyzeModule.analyze(url, client)` function.

```
mix analyze https://github.com/kitplummer/xmpp4rails, mix
```

## Docs?

This is really a TODO note for me: Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lowendinsight](https://hexdocs.pm/lowendinsight).


### A Note about the metrics used
* Recent commit size: This is a measure of how large the most recent commit is in relatino to the size of the codebase. The idea being that a large recent commit is much more likely to be bug filled than a relatively small commit.
* Functional Contributors: A functional contributor is one that contributes above a certain percentage of commits equal to or greater than their "fair" share. Simply put, a contributor is counted as a functional contributor if the proportion of their commits to the total commits is greater than or equal to 1 / the total number of committers.  If everyone committed the same amount, everyone would be a functional contributor.

## TODO(ing)

* Refactoring to work thru Analyze, and Report
* Maintain access to other functions
