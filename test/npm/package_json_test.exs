# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule PackageJSONTest do
  use ExUnit.Case

  test "extracts dependencies from package.json" do
    {lib_map, deps_count} = Npm.Packagefile.parse!(File.read!("./test/fixtures/packagejson"))

    parsed_package_json = [
      {"async", "2.1.4"},
      {"benchmark", "2.1.3"},
      {"chalk", "1.1.3"},
      {"request", "2.88.0"}
    ]

    assert deps_count == 4
    assert parsed_package_json == lib_map
  end

  test "extracts dependencies from package-lock.json" do
    {lib_map, deps_count} = Npm.Packagefile.parse!(File.read!("./test/fixtures/package-lockjson"))

    parsed_package_lock_json = [
      {"ajv", "6.10.2"},
      {"assert-plus", "1.0.0"},
      {"bcrypt-pbkdf", "1.0.2"},
      {"combined-stream", "1.0.8"}
    ]

    assert deps_count == 4
    assert parsed_package_lock_json == lib_map
  end
end
