defmodule Npm.Packagelockfile do

    @spec parse!(binary) :: {[any], non_neg_integer}
    def parse!(content) do
        deps =
            content
            |> Jason.decode
            |> extract_deps
        
        # {deps, length(deps)} # length of all instead of direct dependencies?
    end

    defp extract_deps({:ok, %{"dependencies" => deps}}), do: Map.keys(deps)
end