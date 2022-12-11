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

  test "validate urls" do
    urls = ["https://github.com/kitplummer/gbtestee", "https://github.com/kitplummer/goa"]
    assert :ok == Helpers.validate_urls(urls)
    urls = ["://github.com/kitplummer/cliban"] ++ urls
    assert {:error, %{:message => "invalid URI", :urls => ["://github.com/kitplummer/cliban"]}} == Helpers.validate_urls(urls)
    urls = ["https//github.com/kitplummer/clikan"] ++ urls
    assert {:error, %{:message => "invalid URI", :urls => ["https//github.com/kitplummer/clikan","://github.com/kitplummer/cliban"]}} == Helpers.validate_urls(urls)
  end

  test "validate scheme" do
    assert {:error, "invalid URI scheme"} == Helpers.validate_url("blah://blah")
  end

  test "removes git+ only when it is a prefix in url" do
    assert "https://github.com/hmfng/modal.git" ==
             Helpers.remove_git_prefix("git+https://github.com/hmfng/modal.git")

    assert "git://github.com/hmfng/modal.git" ==
             Helpers.remove_git_prefix("git://github.com/hmfng/modal.git")
  end
end
