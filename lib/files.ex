# Copyright (C) 2022 by Kit Plummer
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Lowendinsight.Files do

  @spec analyze_files(binary) :: %{
          binary_files: list,
          binary_files_count: non_neg_integer,
          has_contributing: boolean,
          has_license: boolean,
          has_readme: boolean,
          total_file_count: non_neg_integer
        }
  def analyze_files(path) do
    binaries = find_binary_files(path)
    res = Map.merge(binaries, get_total_file_count(path))
    res = Map.merge(res, has_readme?(path))
    res = Map.merge(res, has_license?(path))
    Map.merge(res, has_contributing?(path))
  end

  @spec find_binary_files(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: %{binary_files: list, binary_files_count: non_neg_integer}
  def find_binary_files(path) do
    # binary_files =
    #   File.cd!(path, fn ->
    #     System.cmd("grep", ["-rIL", "."])
    #   end)
    #   |> elem(0)
    #   |> String.split("\n")
    #   |> Enum.reject(& String.contains?(&1, ".git/")|| &1 == "")

    # %{binary_files: binary_files, binary_files_count: Enum.count(binary_files)}
    %{}
  end

  @spec get_total_file_count(binary) :: %{total_file_count: non_neg_integer}
  def get_total_file_count(path) do
    all_files =
      Path.wildcard(path <> "/**")
      |> Enum.reject(& String.contains?(&1, ".git/")|| &1 == "")
    total_file_count = Enum.count(all_files)
    %{total_file_count: total_file_count}
  end

  @spec has_readme?(binary) :: %{has_readme: boolean}
  def has_readme?(path) do
    readmes =
      Path.wildcard(path <> "/readme*") ++ Path.wildcard(path <> "/README*")
    %{has_readme: !Enum.empty?(readmes)}
  end

  @spec has_license?(binary) :: %{has_license: boolean}
  def has_license?(path) do
    licenses =
      Path.wildcard(path <> "/license*") ++ Path.wildcard(path <> "/LICENSE*")
    %{has_license: !Enum.empty?(licenses)}
  end

  @spec has_contributing?(binary) :: %{has_contributing: boolean}
  def has_contributing?(path) do
    contributings =
      Path.wildcard(path <> "/contributing*") ++ Path.wildcard(path <> "/CONTRIBUTING*")
    %{has_contributing: !Enum.empty?(contributings)}
  end
end
