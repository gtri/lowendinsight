defmodule GitModuleTest do

  use ExUnit.Case
  doctest GitModule


  defp teardown do
    File.rm "xmpp4rails"
    #assert {:ok} == delete
  end

  setup do
    on_exit(teardown())
  end

  setup_all do
    dir = File.cd "xmpp4rails"
    assert {:error, :enoent} == dir
    :ok
  end

  test "clone a repo" do
    response = Git.clone "https://github.com/kitplummer/xmpp4rails"
    assert {:ok} == response
  end

end
