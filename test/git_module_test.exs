defmodule GitModuleTest do
  use ExUnit.Case
  doctest GitModule

  setup do
    on_exit(
      fn ->
        File.rm_rf "xmpp4rails"
        File.rm_rf "lita-cron"
      end
    )
  end

  test "get contributor list 1" do
    count = GitModule.get_contributor_count "https://github.com/kitplummer/xmpp4rails"
    assert 1 == count
  end

  test "get contributor list 3" do
    count = GitModule.get_contributor_count "https://github.com/kitplummer/lita-cron"
    assert 3 == count
  end

  test "get contributor list bad repo" do
    count = GitModule.get_contributor_count "https://github.com/kitplummer/blah"
    assert {:error, "Repository not found"} == count
  end




end
