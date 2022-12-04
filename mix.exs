# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule GithubModule.MixProject do
  use Mix.Project

  def project do
    [
      app: :lowendinsight,
      description: description(),
      version: "0.7.2",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "LowEndInsight",
      source_url: "https://github.com/gtri/lowendinsight",
      docs: [
        extras: ["README.md"]
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:httpoison_retry, "~> 1.1"},
      {:git_cli, "~> 0.3"},
      {:poison, "~> 4.0"},
      {:elixir_uuid, "~> 1.2"},
      {:ex_doc, "~> 0.24", runtime: false},
      {:credo, "~> 1.5", except: :prod, runtime: false},
      {:mix_audit, "~> 0.1", only: [:dev, :test], runtime: false},
      {:json_xema, "~> 0.6"},
      {:temp, "~> 0.4"},
      {:excoveralls, "~> 0.14", only: :test},
      {:yarn_parser, "~> 0.3"},
      {:sweet_xml, "~> 0.7.1"},
      {:sbom, "~> 0.6", only: :dev, runtime: false}
    ]
  end

  defp links() do
    %{"GitHub" => "https://github.com/gtri/lowendinsight"}
  end

  defp description() do
    "LowEndInsight is a simple 'bus-factor' risk analysis library for Open Source Software which is managed within a Git repository. Provide the git URL and the library will respond with a basic Elixir Map structure report."
  end

  defp package() do
    [
      licenses: ["BSD-3-Clause"],
      links: links()
    ]
  end
end
