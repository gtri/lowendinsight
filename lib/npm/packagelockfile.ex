defmodule Npm.Packagelockfile do
  @spec parse!(binary) :: {[any], non_neg_integer}
  def parse!(content) do
    deps =
      content
      |> Jason.decode()
      |> extract_deps
      |> Enum.to_list()
      |> Enum.map(fn {dependency, info} -> {dependency, info["version"]} end)

    {deps, length(deps)}
  end

  defp extract_deps({:ok, %{"dependencies" => deps}}), do: deps
end
