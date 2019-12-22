# Copyright (C) 2018 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

use Mix.Config

config :lowendinsight,
  ## Token for accessing Github
  ## NOTE: Development of the hub API inquiries is on hold for now.
  access_token: "",

  ## Contributor in terms of discrete users
  ## NOTE: this currently doesn't discern same user with different email
  critical_contributor_par_level: String.to_integer(System.get_env("LEI_CRITICAL_CONTRIBUTOR_PAR_LEVEL") || "2"),
  high_contributor_par_level: System.get_env("LEI_HIGH_CONTRIBUTOR_PAR_LEVEL") || 3,
  medium_contributor_par_level: System.get_env("LEI_CRITICAL_CONTRIBUTOR_PAR_LEVEL") || 5,

  ## Commit currency in weeks - is the project active.  This by itself
  ## may not indicate anything other than the repo is stable. The reason
  ## we're reporting it is relative to the likelihood vulnerabilities
  ## getting fix in a timely manner
  critical_currency_par_level: String.to_integer(System.get_env("LEI_CRITICAL_CURRENCY_PAR_LEVEL") || "104"),
  high_currency_par_level: String.to_integer(System.get_env("LEI_HIGH_CURRENCY_PAR_LEVEL") || "52"),
  medium_currency_par_level: String.to_integer(System.get_env("LEI_MEDIUM_CURRENCY_PAR_LEVEL") || "26"),

  ## Percentage of changes to repo in recent commit - is the codebase
  ## volatile in terms of quantity of source being changed
  critical_large_commit_level: String.to_float(System.get_env("LEI_CRITICAL_LARGE_COMMIT_LEVEL") || "0.30"),
  high_large_commit_level: String.to_float(System.get_env("LEI_HIGH_LARGE_COMMIT_LEVEL") || "0.15"),
  medium_large_commit_level: String.to_float(System.get_env("LEI_MEDIUM_LARGE_COMMIT_LEVEL") || "0.05"),

  ## Bell curve contributions - if there are 30 contributors
  ## but 90% of the contributions are from 2...
  high_functional_contributors_risk: String.to_integer(System.get_env("LEI_HIGH_FUNCTIONAL_CONTRIBUTORS_RISK") || "2"),
  medium_functional_contributors_risk: String.to_integer(System.get_env("LEI_MEDIUM_FUNCTIONAL_CONTRIBUTORS_RISK") || "4"),
  low_functional_contributors_risk: String.to_integer(System.get_env("LEI_LOW_FUNCTIONAL_CONTRIBUTORS_RISK") || "5")
