defmodule MixfileTest do
  use ExUnit.Case

  test "extracts dependencies from mix.exs" do
    {lib_map, deps_count} = Hex.Mixfile.parse!(File.read!("./test/fixtures/mixfile"))
    parsed_mixfile = [oauth: [github: "tim/erlang-oauth"], poison: "~> 1.3.1", plug: "~> 0.11.0"]

    assert deps_count == 3
    assert parsed_mixfile == lib_map
  end
end
