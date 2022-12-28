defmodule Contributor do
  defstruct name: "",
            email: "",
            count: 0,
            merges: 0,
            last_contribution_date: "",
            commits: []

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          count: integer,
          merges: integer,
          last_contribution_date: String.t(),
          commits: [String.t()]
        }
end
