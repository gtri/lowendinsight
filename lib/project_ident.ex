# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectIdent do

  @doc """
  is_mix?/1: takes in a Repository struct and returns true
  if the repo has a mix.exs file.
  NOTE: mix will install dependencies into deps/ so we're gonna
  ignore those, and only recognize the mix.exs/mix.lock at the
  root directory
  """
  def is_mix?(repo) do
    paths = Path.wildcard("#{repo.path}/{mix.exs,mix.lock}")
    %{"mix" => paths}
  end

  @doc """
  is_python?/1: takes in a Repository struct and returns true
  if there is the presence of a setup.py or *requirements.txt file.

  NOTE: this could be either a pip or conda project.
  """
  def is_python?(repo) do
    paths = Path.wildcard("#{repo.path}/**/{setup.py, *requirements.txt*}")
    %{"python" => paths}
  end

  @doc """
  is_node?/1: takes in a Repository struct and returns true
  if there is presence of a package.json file.

  NOTE: this could be a yarn or npm project.
  """
  def is_node?(repo) do
    paths = Path.wildcard("#{repo.path}/**/{package.json}")
    %{"node" => paths}
  end

  @doc """
  is_go_mod?/1: takes in a Repository struct and returns true
  if there is presence of a go.mod file.
  """
  def is_go_mod?(repo) do
    paths = Path.wildcard("#{repo.path}/**/{go.mod}")
    %{"go_mod" => paths}
  end

  @doc """
  is_cargo?/1: takes in a Repository struct and returns true
  if there is presence of a Cargo.toml file.
  """
  def is_cargo?(repo) do
    paths = Path.wildcard("#{repo.path}/**/{Cargo.toml}")
    %{"cargo" => paths}
  end

  @doc """
  is_rubygem?/1: takes in a Repository struct and returns true
  if there is presence of a Gemfile file.
  """
  def is_rubygem?(repo) do
    paths = Path.wildcard("#{repo.path}/**/{Gemfile*,*.gemspec}")
    %{"rubygem" => paths}
  end

  @doc """
  is_maven?/1: takes in a Repository struct and returns true
  if there is presence of a pom.xml
  """
  def is_maven?(repo) do
    paths = Path.wildcard("#{repo.path}/**/{pom.xml}")
    %{"maven" => paths}
  end

  @doc """
  is_gradle?/1: takes in a Repository struct and returns true
  if there is presence of a build.gradle file.
  """
  def is_gradle?(repo) do
    paths = Path.wildcard("#{repo.path}/**/{build.gradle*}")
    %{"gradle" => paths}
  end

  @doc """
  project_types?/1: takes in a Repository and will return a list
  of found project types within the repo.
  """
  def project_types?(repo) do
    projects = %{}
    mix = is_mix?(repo)
    projects = if Kernel.length(mix["mix"]) > 0 do
      Map.merge(projects, mix)
    else
      projects
    end

    python = is_python?(repo)
    projects = if Kernel.length(python["python"]) > 0 do
      Map.merge(projects, python)
    else
      projects
    end

    node = is_node?(repo)
    projects = if Kernel.length(node["node"]) > 0 do
      Map.merge(projects, node)
    else
      projects
    end

    go_mod = is_go_mod?(repo)
    projects = if Kernel.length(go_mod["go_mod"]) > 0 do
      Map.merge(projects, go_mod)
    else
      projects
    end

    cargo = is_cargo?(repo)
    projects = if Kernel.length(cargo["cargo"]) > 0 do
      Map.merge(projects, cargo)
    else
      projects
    end

    rubygem = is_rubygem?(repo)
    projects = if Kernel.length(rubygem["rubygem"]) > 0 do
      Map.merge(projects, rubygem)
    else
      projects
    end

    maven = is_maven?(repo)
    projects = if Kernel.length(maven["maven"]) > 0 do
      Map.merge(projects, maven)
    else
      projects
    end

    gradle = is_gradle?(repo)
    projects = if Kernel.length(gradle["gradle"]) > 0 do
      Map.merge(projects, gradle)
    else
      projects
    end

    projects
  end

end

