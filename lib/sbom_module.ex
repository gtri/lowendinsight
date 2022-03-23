# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule SbomModule do
  @moduledoc """
  Scan for a SBOM and validate.
  """

  def has_sbom?(repo) do
    path = repo.path
    File.exists?(path <> "/bom.xml") or has_spdx?(repo)
  end

  def has_spdx?(repo) do
    boms = Path.wildcard(repo.path <> "/**/*spdx*")
    !Enum.empty?(boms)
  end

end
