defmodule GitHelperTest do
  use ExUnit.Case
  doctest GitHelper

 @moduledoc """
 This will test various functions in git_helper. However, since most of these functions
 are private, in order to test them you will need to make them public. I have added
 a tag :helper to all tests so that you may include or uninclude them accordingly.

 TODO: confirm that count can't be misconstrued and push the value so analysis can still be done
 """

  setup_all do
    correct_atr = "John R Doe <john@example.com> (1):\n messages for commits"
    incorrect_e = "John R Doe <asdfoi@2> (1):\n messages for commits"
    e_with_semi = "John R Doe <asdfjk@l;> (1):\n messages for commits"
    name_with_num = "098 567 45 <john@example.com> (10): \n messages for commits"
    empty_name = "<john@example.com> (1) \n messages for commits"
    name_angBr = "John < Doe <john@example.com> (1) \n messages for commmits"
    email_angBr = "John R Doe <john>example.com> (1) \n messages for commits"

    [
      correct_atr: correct_atr,
      incorrect_e: incorrect_e,
      e_with_semi: e_with_semi,
      name_with_num: name_with_num,
      empty_name: empty_name,
      name_angBr: name_angBr,
      email_angBr: email_angBr
    ]
  end

  setup do
    :ok
  end

  @tag :helper
  test "correct implementation", %{correct_atr: correct_atr} do
    assert {"John R Doe ", "john@example.com", "1"} = GitHelper.parse_header(correct_atr)
  end

  @tag :helper
  test "incorrect email", %{incorrect_e: incorrect_e} do
    assert {"John R Doe ", "asdfoi@2", "1"} = GitHelper.parse_header(incorrect_e)
  end

  @tag :helper
  test "semicolon error", %{e_with_semi: e_with_semi} do
    assert {"Could not process", "Could not process", "Could not process"} = GitHelper.parse_header(e_with_semi)
  end

  @tag :helper
  test "number error", %{name_with_num: name_with_num} do
    assert {"098 567 45 ", "john@example.com", "10"} = GitHelper.parse_header(name_with_num)
  end

  @tag :helper
  test "empty name error", %{empty_name: empty_name} do
    assert {"", "john@example.com", "1"}  = GitHelper.parse_header(empty_name)
  end

  @tag :helper
  test "name with opening angle bracket", %{name_angBr: name_angBr} do
    assert {"John ", " Doe <john@example.com", "1"} = GitHelper.parse_header(name_angBr)
  end

  @tag :helper
  test "email with closing angle bracket", %{email_angBr: email_angBr} do
    assert {"John R Doe ", "john>example.com", "1"} = GitHelper.parse_header(email_angBr)
  end
end
