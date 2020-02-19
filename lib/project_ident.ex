# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectIdent do

  @doc """
  is_mix?/1: takes in a Repository struct and returns true
  if the repo has a mix.exs file.
  """
  @spec is_mix?(atom | %{path: any}) :: boolean
  def is_mix?(repo) do
    paths = Path.wildcard("#{repo.path}/mix.exs")
    %{"mix" => paths}
  end

  @doc """
  is_python?/1: takes in a Repository struct and returns true
  if there is the presence of a setup.py or *requirements.txt file.

  NOTE: this could be either a pip or conda project.
  """
  @spec is_python?(atom | %{path: any}) :: boolean
  def is_python?(repo) do
    paths = Path.wildcard("#{repo.path}/{setup.py, *requirements.txt*}")
    %{"python" => paths}
  end

  @doc """
  is_node?/1: takes in a Repository struct and returns true
  if there is presence of a package.json file.

  NOTE: this could be a yarn or npm project.
  """
  @spec is_node?(atom | %{path: any}) :: boolean
  def is_node?(repo) do
    Enum.count(Path.wildcard("#{repo.path}/{package.json}")) > 0
  end

  @doc """
  is_go_mod?/1: takes in a Repository struct and returns true
  if there is presence of a go.mod file.
  """
  @spec is_go_mod?(atom | %{path: any}) :: boolean
  def is_go_mod?(repo) do
    Enum.count(Path.wildcard("#{repo.path}/{go.mod}")) > 0
  end

  @doc """
  is_cargo?/1: takes in a Repository struct and returns true
  if there is presence of a Cargo.toml file.
  """
  @spec is_cargo?(atom | %{path: any}) :: boolean
  def is_cargo?(repo) do
    Enum.count(Path.wildcard("#{repo.path}/{Cargo.toml}")) > 0
  end

  @doc """
  is_rubygem?/1: takes in a Repository struct and returns true
  if there is presence of a Gemfile file.
  """
  @spec is_rubygem?(atom | %{path: any}) :: boolean
  def is_rubygem?(repo) do
    Enum.count(Path.wildcard("#{repo.path}/{Gemfile}")) > 0
  end

  @doc """
  is_maven?/1: takes in a Repository struct and returns true
  if there is presence of a pom.xml
  """
  @spec is_maven?(atom | %{path: any}) :: boolean
  def is_maven?(repo) do
    Enum.count(Path.wildcard("#{repo.path}/**/{pom.xml}")) > 0
  end

  @doc """
  is_gradle?/1: takes in a Repository struct and returns true
  if there is presence of a build.gradle file.
  """
  @spec is_gradle?(atom | %{path: any}) :: boolean
  def is_gradle?(repo) do
    Enum.count(Path.wildcard("#{repo.path}/**/{build.gradle*}")) > 0
  end

  @doc """
  project_types?/1: takes in a Repository and will return a list
  of found project types within the repo.
  """
  @spec project_types?(atom | %{path: any}) :: Map
  def project_types?(repo) do
    projects = %{}
    mix = is_mix?(repo)
    projects = Map.merge(projects, mix)
    python = is_python?(repo)
    projects = Map.merge(projects, python)
    projects
  end

end

