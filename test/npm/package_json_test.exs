# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule PackageJSONTest do
  use ExUnit.Case

  test "extracts dependencies from package.json" do
    {lib_map, deps_count} = Npm.Packagefile.parse!(File.read!("./test/fixtures/packagejson"))

    parsed_package_json = [
      {"simple-npm-package", "3.0.8"}
    ]

    assert deps_count == 1
    assert parsed_package_json == lib_map
  end

  test "extracts dependencies from package-lock.json" do
    {lib_map, deps_count} = Npm.Packagefile.parse!(File.read!("./test/fixtures/package-lockjson"))

    parsed_package_lock_json = [
      {"combined-stream", "1.0.8"}
    ]

    assert deps_count == 1
    assert parsed_package_lock_json == lib_map
  end
end
