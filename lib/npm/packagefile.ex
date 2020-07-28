defmodule Npm.Packagefile do

  @moduledoc """
    Provides package.json dependency parser
  """
  @doc """
  parse!: parses package.json dependencies, returning a list of those
  dependencies along with the count of total dependencies.
  """
  @spec parse!(binary) :: {[any], non_neg_integer}
  def parse!(content) do
    deps =
      content
      |> Jason.decode()
      |> extract_deps
      |> Enum.to_list()

    {deps, length(deps)}
  end

  defp extract_deps({:ok, %{"dependencies" => deps}}), do: deps
end
