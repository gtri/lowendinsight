# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GithubModule.MixProject do
  use Mix.Project

  def project do
    [
      app: :lowendinsight,
      version: "0.2.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "LowEndInsight",
      source_url: "https://bitbucket.org/kitplummer/lowendinsight",
      docs: [
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tentacat, "~> 1.0"},
      {:git_cli, "~> 0.3"},
      {:json, "~> 1.3"},
      {:uuid, "~> 1.1"},
      {:ex_doc, "~> 0.21"}
    ]
  end
end
