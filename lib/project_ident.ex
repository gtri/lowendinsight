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
    Enum.count(Path.wildcard("#{repo.path}/mix.exs")) > 0
  end

  @spec is_pip?(atom | %{path: any}) :: boolean
  def is_pip?(repo) do
    Enum.count(Path.wildcard("#{repo.path}/{setup.py, *requirements.txt*}")) > 0
  end
end
