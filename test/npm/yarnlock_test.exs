# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule YarnlockTest do
  use ExUnit.Case

  test "extracts dependencies from yarn.lock" do
    {lib_map, deps_count} = Npm.Yarnlockfile.parse!(File.read!("./test/fixtures/yarnlock"))

    parsed_yarn = [{"assert-plus", "1.0.0"}]

    assert deps_count == 1
    assert parsed_yarn == lib_map
  end
end
