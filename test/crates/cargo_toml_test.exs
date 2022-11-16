# Copyright (C) 2022 by Kit Plummer
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule CargoTomlTest do
  use ExUnit.Case

  test "extracts dependencies from Cargo.toml" do
    {:ok, {lib_map, deps_count}} = Crates.Cargofile.parse!(File.read!("./test/fixtures/cargofile"))

    parsed_cargofile =  [{"anyhow", "1.0"}, {"assert_cmd", "2.0"}, {"chrono", "0.4"}, {"clokwerk", "0.3.5"}, {"env_logger", "0.9"}, {"git2", "0.13"}, {"log", "0.4"}, {"openssl-sys", "0.9"}, {"predicates", "2.1"}, {"run_script", "0.9"}, {"structopt", "0.3"}, {"url", "2.2"}, {"uuid", "0.8.2"}]

    assert deps_count == 13
    assert parsed_cargofile == lib_map
  end
end
