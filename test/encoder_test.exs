# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Lowendinsight.EncoderTest do
  use ExUnit.Case, async: true
  doctest Helpers

  test "encoder works for mix.exs" do
    mixfile =
      File.read!("./mix.exs")
      |> Mixfile.parse()

    lib_map = Encoder.mixfile_map(mixfile)

    lib_json =
      Encoder.mixfile_json(lib_map)
      |> Poison.decode!()

    assert "~> 1.1" == lib_json["uuid"]
  end
end
