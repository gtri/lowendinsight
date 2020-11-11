defmodule Contributor do
  defstruct name: "",
            email: "",
            count: 0,
            merges: 0,
            commits: []

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          count: integer,
          merges: integer,
          commits: [String.t()]
        }
end
