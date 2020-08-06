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

defmodule Hex.Mixfile do
  @behaviour Parser

  @moduledoc """
    Provides mix.exs dependency parser
    From: https://github.com/librariesio/mix-deps-json/blob/master/lib/mixfile.ex
  """

  @impl Parser
  def parse!(content) do
    deps =
      content
      |> Code.string_to_quoted()
      |> extract_module()
      |> extract_calls()
      |> extract_deps()
      |> Enum.to_list()

    {deps, length(deps)}
  end

  @impl Parser
  def file_names(), do: ["mix.exs"]

  defp extract_module({:ok, {:defmodule, _, content}}), do: content

  defp extract_calls([_ | [[do: {:__block__, _, calls}] | _]]), do: calls

  defp extract_deps({:defp, _, [{:deps, _, _}, [do: dependencies]]}, _), do: dependencies

  defp extract_deps(_, tail), do: extract_deps(tail)

  defp extract_deps([head | tail]), do: extract_deps(head, tail)
end