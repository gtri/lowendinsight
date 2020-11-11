# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectType do
  alias __MODULE__

  defstruct name: nil, path: nil, files: []

  def types_to_string(project_type) do
    types = Enum.join(project_type.files, ",")
    "{" <> types <> "}"
  end
end
