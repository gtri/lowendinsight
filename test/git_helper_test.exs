defmodule GitHelperTest do
  use ExUnit.Case
  doctest GitHelper

 @moduledoc """
 This will test various functions in git_helper. However, since most of these functions
 are private, in order to test them you will need to make them public. I have added
 a tag :helper to all tests so that you may include or uninclude them accordingly.
 """

  setup_all do
    correct_atr = "James R Richardson <jronmi@hotmail.com> (1):\n asdfj"
    incorrect_e = "James R Richardson <asdfoi2> (1):\n asdoin sd"
    e_with_semi = "James R Richardson <asdfjkl;> (1):\n asdfjkl"
    name_with_num = "James 9 Richardson <jronmi@hotmail.com> (10): /n asdl"

    [
      correct_atr: correct_atr,
      incorrect_e: incorrect_e,
      e_with_semi: e_with_semi,
      name_with_num: name_with_num
    ]
  end

  setup do
    :ok
  end

  @tag :helper
  test "correct implementation", %{correct_atr: correct_atr} do
    assert {"James R Richardson ", "jronmi@hotmail.com", "1"} = GitHelper.parse_header(correct_atr)
  end

  @tag :helper
  test "incorrect email", %{incorrect_e: incorrect_e} do
    assert {"James R Richardson ", "asdfoi2", "1"} = GitHelper.parse_header(incorrect_e)
  end

  @tag :helper
  test "semicolon error", %{e_with_semi: e_with_semi} do
    assert {"James R Richardson ", "asdfjkl;", "1"} = GitHelper.parse_header(e_with_semi)
  end

  @tag :helper
  test "number error", %{name_with_num: name_with_num} do
    assert {"James 9 Richardson ", "jronmi@hotmail.com", "10"} = GitHelper.parse_header(name_with_num)
  end
end
