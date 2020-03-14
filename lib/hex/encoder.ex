# Copyright (c) 2016 Andrew Nesbitt

# MIT License

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

defmodule Encoder do
  @moduledoc """
    Provides map to json encoder
  """

  @spec mixfile_json(map) :: charlist
  def mixfile_json(dependencies) do
    dependencies
    |> libraries
    |> Poison.encode!()
  end

  def mixfile_map(dependencies) do
    dependencies
    |> libraries
  end

  defp libraries(dependencies) do
    dependencies |> Enum.reduce(%{}, &library/2)
  end

  defp library({name, version}, acc) when is_bitstring(version) do
    Map.put(acc, name, version)
  end

  defp library({name, details}, acc) do
    Map.put(acc, name, extract_version(details))
  end

  defp library({_, _, [name, version, _]}, acc) do
    Map.put(acc, name, version)
  end

  defp extract_version(details) do
    item = Enum.into(details, %{})
    Map.get(item, :tag) || Map.get(item, :branch) || "HEAD"
  end

  @spec lockfile_json(map) :: charlist
  def lockfile_json(dependencies) do
    dependencies
    |> deps
    |> Poison.encode!()
  end

  def lockfile_map(dependencies) do
    dependencies
    |> deps
  end

  defp deps(deps) do
    deps
    |> Enum.reduce(%{}, fn {source, lib, version}, acc ->
      Map.put(acc, lib, %{source: source, version: version})
    end)
  end
end
