# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectIdentTest do
  use ExUnit.Case, async: true

  doctest ProjectIdent
  test "is_elixir?(repo)" do
    {:ok, cwd} = File.cwd
    {:ok, repo} = GitModule.get_repo(cwd)
    assert true == ProjectIdent.is_elixir?(repo)
  end

end
