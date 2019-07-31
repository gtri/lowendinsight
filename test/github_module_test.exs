defmodule GithubModuleTest do
  use ExUnit.Case
  doctest GithubModule

  setup_all do
    c = Tentacat.Client.new(%{access_token: Application.fetch_env!(:lowendinsight, :access_token)})
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

  test "get last commit date" do
    assert GithubModule.get_last_commit_date("kitplummer/xmpp4rails") == {:ok, ~U[2009-01-07 03:23:20Z], 0}
  end

end
