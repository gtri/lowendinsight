# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule LockfileTest do
  use ExUnit.Case

  test "extracts dependencies from mix.lock" do
    {lib_map, deps_count} = Hex.Lockfile.parse!(File.read!("./test/fixtures/lockfile"))

    parsed_lockfile = [
      {:hex, :cowboy, "1.0.4"},
      {:hex, :cowlib, "1.0.2"},
      {:git, "https://github.com/tim/erlang-oauth.git",
       "bd19896e31125f99ff45bb5850b1c0e74b996743"},
      {:hex, :plug, "1.1.6"},
      {:hex, :poison, "2.1.0"},
      {:hex, :ranch, "1.2.1"}
    ]

    assert deps_count == 6
    assert parsed_lockfile == lib_map
  end
end