# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Lowendinsight.HelpersTest do
  use ExUnit.Case, async: true
  doctest Helpers

  test "converter works?" do
    Helpers.convert_config_to_list(Application.get_all_env(:lowendinsight))
    |> Poison.encode!()
  end

  test "validate path url" do
    {:ok, cwd} = File.cwd()
    assert :ok == Helpers.validate_url("file://#{cwd}")
    assert {:error, "invalid URI path"} == Helpers.validate_url("file:///blah")
  end

  test "validate scheme" do
    assert {:error, "invalid URI scheme"} == Helpers.validate_url("blah://blah")
  end
end
