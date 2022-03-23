# Copyright (C) 2022 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule Lowendinsight.SbomModuleTest do
  use ExUnit.Case, async: true
  doctest SbomModule

  test "has sbom?" do
    {:ok, repo} = GitModule.get_repo(".")
    assert true == SbomModule.has_sbom?(repo)
  end

  test "has spdx?" do
    {:ok, repo} = GitModule.get_repo(".")
    assert false == SbomModule.has_spdx?(repo)
  end

end
