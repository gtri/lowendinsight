defmodule YarnlockTest do
  use ExUnit.Case

  test "extracts dependencies from yarn.lock" do
    {lib_map, deps_count} = Npm.Yarnlockfile.parse!(File.read!("./test/fixtures/yarnlock"))

    parsed_yarn = [{"ajv", "6.12.3"}, {"asn1", "0.2.4"}, {"assert-plus", "1.0.0"}]

    assert deps_count == 3
    assert parsed_yarn == lib_map
  end
end