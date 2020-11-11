# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Lowendinsight.Hex.EncoderTest do
  use ExUnit.Case, async: true

  test "encoder works for mix.exs" do
    {deps, count} =
      File.read!("./test/fixtures/mixfile")
      |> Hex.Mixfile.parse!()

    lib_map = Hex.Encoder.mixfile_map(deps)

    lib_json =
      Hex.Encoder.mixfile_json(lib_map)
      |> Poison.decode!()

    assert 3 == count
    assert "~> 1.3.1" == lib_json["poison"]
  end

  test "encoder works for mix.lock" do
    {deps, count} =
      File.read!("./test/fixtures/lockfile")
      |> Hex.Lockfile.parse!()

    assert 6 == length(deps)
    trans_map = Hex.Encoder.lockfile_map(deps)
    assert length(deps) == count
    assert true == Map.has_key?(trans_map, :cowboy)
    assert "1.0.4" == trans_map[:cowboy][:version]
  end

  test "get dependency tree as json" do
    json =
      File.read!("./test/fixtures/lockfile")
      |> Hex.Lockfile.parse!(true)
      |> Hex.Encoder.lockfile_json()

    lockfile = Poison.Parser.parse!(json, %{})
    f = List.first(lockfile)
    assert Map.has_key?(f, "name") == true
  end

  test "get mix.lock dependency tree as json" do
    deps =
      File.read!("./mix.lock")
      |> Hex.Lockfile.parse!(true)
      |> Hex.Encoder.lockfile_json()

    json = Poison.decode!(deps)
    bunt = List.first(json)

    assert "bunt" == bunt["name"]
  end
end
