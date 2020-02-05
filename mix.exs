# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GithubModule.MixProject do
  use Mix.Project

  def project do
    [
      app: :lowendinsight,
      description: description(),
      version: "0.3.2",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "LowEndInsight",
      source_url: "https://bitbucket.org/kitplummer/lowendinsight",
      docs: [
        extras: ["README.md"]
      ],
      test_coverage: [tool: ExCoveralls]
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
      {:poison, "~> 3.1"},
      {:uuid, "~> 1.1"},
      {:ex_doc, "~> 0.21"},
      {:credo, "~> 0.10", except: :prod, runtime: false},
      {:json_xema, "~> 0.3"},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end

  defp links() do
    %{"Bitbucket" => "https://bitbucket.org/kitplummer/lowendinsight"}
  end

  defp description() do
    "LowEndInsight is a simple 'bus-factor' risk analysis library for Open Source Software which is managed within a Git repository. Provide the git URL and the library will respond with a basic Elixir Map structure report."
  end

  defp package() do
    [
      licenses: ["BSD-3"],
      links: links()
    ]
  end
end
