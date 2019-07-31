defmodule GithubModuleTest do
  use ExUnit.Case
  doctest GithubModule

  setup_all do
    c = Tentacat.Client.new(%{access_token: "2985bf2c1ff4b41863aef325b2ed527a120b6bc0"})
    {:ok, client: c}
  end

  test "split a slug" do
    {:ok, org, repo} = GithubModule.split_slug("kitplummer/xmpp4rails")
    assert org == "kitplummer"
    assert repo == "xmpp4rails"
  end

  test "try to split a bad slug" do
    {:error, val} = GithubModule.split_slug("kitplummerxmpp4rails")
    assert val == "bad_slug"
  end

  test "return error when slug does not exist in target service" do
    assert GithubModule.get_contributors_count("kitplummer/blah") == {:error, "repo not found"}
  end

  test "get contributors count when 0" do
    assert GithubModule.get_contributors_count("kitplummer/xmpp4rails") == {:ok, 0}
  end

  test "get contributors count when not 0" do
    assert GithubModule.get_contributors_count("kitplummer/ovmtb2") == {:ok, 2}
  end

  test "get last commit delta" do
    assert GithubModule.get_last_commit_delta("kitplummer/xmpp4rails") == {:ok, 3000}
  end

end
