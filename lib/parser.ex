# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Parser do
  @callback parse!(String.t()) :: {:ok, term} | {:error, String.t()}
  @callback file_names() :: [String.t()]
end
