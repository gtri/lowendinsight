defmodule Parser do
  @callback parse!(String.t()) :: {:ok, term} | {:error, String.t()}
  @callback file_names() :: [String.t()]
end
