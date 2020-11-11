# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule MixfileTest do
  use ExUnit.Case

  test "extracts dependencies from mix.exs" do
    {lib_map, deps_count} = Hex.Mixfile.parse!(File.read!("./test/fixtures/mixfile"))
    parsed_mixfile = [oauth: [github: "tim/erlang-oauth"], poison: "~> 1.3.1", plug: "~> 0.11.0"]

    assert deps_count == 3
    assert parsed_mixfile == lib_map
  end
end
