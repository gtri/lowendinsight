defmodule RequirementsTest do
  use ExUnit.Case

  test "extracts dependencies from requirements.txt" do
    file_content =
      "#comment\nfurl==1.5\nquokka<=0.9\nnumpy>=2.6\nkeras!=5.6\npandas<4\npytorch~=3.0\ntensorflow*"

    {lib_map, deps_count} = Pypi.Requirements.parse!(file_content)

    parsed_requirements = [
      {"furl", "1.5"},
      {"quokka", "0.9"},
      {"numpy", "2.6"},
      {"keras", "5.6"},
      {"pandas", "4"},
      {"pytorch", "3.0"},
      {"tensorflow", ""}
    ]

    assert deps_count == 7
    assert parsed_requirements == lib_map
  end
end
