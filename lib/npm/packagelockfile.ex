defmodule Npm.Packagelockfile do

  @moduledoc """
    Provides package-lock.json dependency parser
  """
  @doc """
  parse!: parses package-lock.json dependencies, returning a map of those
  dependencies along with the count of total dependencies.
  """
  @spec parse!(binary) :: {[any], non_neg_integer}
  def parse!(content) do
    deps =
      content
      |> Jason.decode()
      |> extract_deps()
      |> Enum.to_list()
      |> Enum.map(fn {dependency, info} -> {dependency, info["version"]} end)

    {deps, length(deps)}
  end

  defp extract_deps({:ok, %{"dependencies" => deps}}), do: deps
end