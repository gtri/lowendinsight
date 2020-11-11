defmodule Hex.Library do
  defstruct name: "",
            source_name: "",
            source_type: "",
            version: "",
            source_hash: "",
            type: [],
            dependencies: [],
            repo: "",
            repo_hash: ""

  @type t :: %__MODULE__{
          name: String.t(),
          source_name: String.t(),
          source_type: String.t(),
          version: String.t(),
          type: [atom],
          dependencies: [],
          repo: [String.t()],
          repo_hash: String.t()
        }
end
