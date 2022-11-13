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

defmodule Hex.Lockfile do
  @behaviour Parser

  @moduledoc """
    Provides mix.lock dependency parser
    From: https://github.com/librariesio/mix-deps-json/blob/master/lib/lockfile.ex
  """

  @impl Parser
  def parse!(content) do
    deps =
      content
      |> Code.string_to_quoted(file: "mix.lock", warn_on_unnecessary_quotes: false)
      |> extract_deps()

    {:ok, {deps, length(deps)}}
  end

  def parse!(content, _do_no_extract) do
    deps =
      content
      |> Code.string_to_quoted(file: "mix.lock", warn_on_unnecessary_quotes: false)
      |> extract_deps_full()

    deps
  end

  @impl Parser
  def file_names(), do: ["mix.lock"]

  defp extract_deps_full({:ok, {_, _, deps}}), do: deps

  defp extract_deps({:ok, {_, _, deps}}), do: extract_deps(deps)

  defp extract_deps(deps), do: Enum.map(deps, &extract_dep/1)

  defp extract_dep({_, {_, _, [source, lib, version, _, _, _]}}), do: {source, lib, version}

  defp extract_dep({_, {_, _, [source, lib, version, _]}}), do: {source, lib, version}

  defp extract_dep({_, {_, _, [source, lib, version]}}), do: {source, lib, version}

  defp extract_dep({_, {_, _, [source, lib, version, _, _, _, _]}}), do: {source, lib, version}

  defp extract_dep({_, {_, _, [source, lib, version, _, _, _, _, _]}}), do: {source, lib, version}
end
