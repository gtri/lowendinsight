# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectIdentTest do
  use ExUnit.Case, async: false

  setup_all do
    on_exit(fn ->
      File.rm_rf("clikan")
      File.rm_rf("expres")
      File.rm_rf("kit")
      File.rm_rf("clap")
      File.rm_rf("rubocop")
      File.rm_rf("snyk-maven-plugin")
      File.rm_rf("RxKotlin")
      File.rm_rf("java-npm-gradle-integration-example")
    end)

    {:ok, cwd} = File.cwd
    [cwd: cwd]
  end

  doctest ProjectIdent

  test "is_python?(repo)" do
    {:ok, cwd} = File.cwd
    {:ok, repo} = GitModule.clone_repo("https://bitbucket.org/kitplummer/clikan")
    assert %{"python" => ["#{cwd}/clikan/setup.py"]} == ProjectIdent.is_python?(repo)
    assert %{"python" => ["#{cwd}/clikan/setup.py"]} == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_node?(repo)" do
    {:ok, cwd} = File.cwd
    {:ok, repo} = GitModule.clone_repo("https://github.com/expressjs/express")
    assert %{"node" => ["#{cwd}/express/package.json"]} == ProjectIdent.is_node?(repo)
    assert %{"node" => ["#{cwd}/express/package.json"]} == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_go_mod?(repo)", %{cwd: cwd} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/go-kit/kit")
    assert %{"go_mod" => ["#{cwd}/kit/go.mod"]} == ProjectIdent.is_go_mod?(repo)
    assert %{
      "go_mod" => ["#{cwd}/kit/go.mod"],
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_cargo?(repo)", %{cwd: cwd} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/clap-rs/clap")
    assert %{
      "cargo" => ["#{cwd}/clap/Cargo.toml",
      "#{cwd}/clap/clap_derive/Cargo.toml",
      "#{cwd}/clap/clap_generate/Cargo.toml"]} == ProjectIdent.is_cargo?(repo)
    assert %{
      "cargo" => ["#{cwd}/clap/Cargo.toml",
      "#{cwd}/clap/clap_derive/Cargo.toml",
      "#{cwd}/clap/clap_generate/Cargo.toml"]
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_rubygem?(repo)", %{cwd: cwd} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/rubocop-hq/rubocop")
    assert %{"rubygem" => ["#{cwd}/rubocop/Gemfile", "#{cwd}/rubocop/rubocop.gemspec"]} == ProjectIdent.is_rubygem?(repo)
    assert %{
      "rubygem" => ["#{cwd}/rubocop/Gemfile","#{cwd}/rubocop/rubocop.gemspec"]
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_maven?(repo)", %{cwd: cwd} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/snyk/snyk-maven-plugin")
    assert %{"maven" => ["#{cwd}/snyk-maven-plugin/pom.xml",
                         "#{cwd}/snyk-maven-plugin/src/it/license-issues-module/pom.xml",
                         "#{cwd}/snyk-maven-plugin/src/it/multi-module/child-module/pom.xml",
                         "#{cwd}/snyk-maven-plugin/src/it/multi-module/pom.xml",
                         "#{cwd}/snyk-maven-plugin/src/it/private-repo-module/pom.xml",
                         "#{cwd}/snyk-maven-plugin/src/it/single-module/pom.xml"]} == ProjectIdent.is_maven?(repo)
    assert %{
      "maven" => ["#{cwd}/snyk-maven-plugin/pom.xml",
        "#{cwd}/snyk-maven-plugin/src/it/license-issues-module/pom.xml",
        "#{cwd}/snyk-maven-plugin/src/it/multi-module/child-module/pom.xml",
        "#{cwd}/snyk-maven-plugin/src/it/multi-module/pom.xml",
        "#{cwd}/snyk-maven-plugin/src/it/private-repo-module/pom.xml",
        "#{cwd}/snyk-maven-plugin/src/it/single-module/pom.xml"],
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_gradle?(repo)", %{cwd: cwd} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/ReactiveX/RxKotlin")
    assert %{"gradle" => ["#{cwd}/RxKotlin/build.gradle.kts"]} == ProjectIdent.is_gradle?(repo)
    assert %{"gradle" => ["#{cwd}/RxKotlin/build.gradle.kts"]} == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "project_types?(repo)", %{cwd: cwd} do
    {:ok, repo} = GitModule.get_repo(cwd)
    assert %{"mix"=>["#{cwd}/mix.exs", "#{cwd}/mix.lock"]} == ProjectIdent.project_types?(repo)
  end

  test "many build or package managers", %{cwd: cwd} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/xword/java-npm-gradle-integration-example")
    assert %{
      "gradle" => ["#{cwd}/java-npm-gradle-integration-example/gradle-groovy-dsl/build.gradle",
       "#{cwd}/java-npm-gradle-integration-example/gradle-groovy-dsl/java-app/build.gradle",
       "#{cwd}/java-npm-gradle-integration-example/gradle-groovy-dsl/npm-app/build.gradle",
       "#{cwd}/java-npm-gradle-integration-example/gradle-kotlin-dsl/build.gradle.kts",
       "#{cwd}/java-npm-gradle-integration-example/gradle-kotlin-dsl/java-app/build.gradle.kts",
       "#{cwd}/java-npm-gradle-integration-example/gradle-kotlin-dsl/npm-app/build.gradle.kts"],
      "node" => ["#{cwd}/java-npm-gradle-integration-example/gradle-groovy-dsl/npm-app/package.json",
       "#{cwd}/java-npm-gradle-integration-example/gradle-kotlin-dsl/npm-app/package.json"]
    } == ProjectIdent.project_types?(repo)
  end

end
