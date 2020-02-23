# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectIdentTest do
  use ExUnit.Case, async: false

  setup_all do
    {:ok, cwd} = File.cwd
    {:ok, tmp_path} = Temp.path "lei-test"

    [cwd: cwd, tmp_path: tmp_path]
  end

  doctest ProjectIdent

  test "is_python?(repo)", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://bitbucket.org/kitplummer/clikan", tmp_path)
    assert %{"python" => ["#{tmp_path}/clikan/setup.py"]} == ProjectIdent.is_python?(repo)
    assert %{"python" => ["#{tmp_path}/clikan/setup.py"]} == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_node?(repo)", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/expressjs/express", tmp_path)
    assert %{"node" => ["#{tmp_path}/express/package.json"]} == ProjectIdent.is_node?(repo)
    assert %{"node" => ["#{tmp_path}/express/package.json"]} == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_go_mod?(repo)", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/go-kit/kit", tmp_path)
    assert %{"go_mod" => ["#{tmp_path}/kit/go.mod"]} == ProjectIdent.is_go_mod?(repo)
    assert %{
      "go_mod" => ["#{tmp_path}/kit/go.mod"],
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_cargo?(repo)", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/clap-rs/clap", tmp_path)
    assert %{
      "cargo" => ["#{tmp_path}/clap/Cargo.toml",
      "#{tmp_path}/clap/clap_derive/Cargo.toml",
      "#{tmp_path}/clap/clap_generate/Cargo.toml"]} == ProjectIdent.is_cargo?(repo)
    assert %{
      "cargo" => ["#{tmp_path}/clap/Cargo.toml",
      "#{tmp_path}/clap/clap_derive/Cargo.toml",
      "#{tmp_path}/clap/clap_generate/Cargo.toml"]
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_rubygem?(repo)", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/rubocop-hq/rubocop", tmp_path)
    assert %{"rubygem" => ["#{tmp_path}/rubocop/Gemfile", "#{tmp_path}/rubocop/rubocop.gemspec"]} == ProjectIdent.is_rubygem?(repo)
    assert %{
      "rubygem" => ["#{tmp_path}/rubocop/Gemfile","#{tmp_path}/rubocop/rubocop.gemspec"]
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_maven?(repo)", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/snyk/snyk-maven-plugin", tmp_path)
    assert %{"maven" => ["#{tmp_path}/snyk-maven-plugin/pom.xml",
                         "#{tmp_path}/snyk-maven-plugin/src/it/license-issues-module/pom.xml",
                         "#{tmp_path}/snyk-maven-plugin/src/it/multi-module/child-module/pom.xml",
                         "#{tmp_path}/snyk-maven-plugin/src/it/multi-module/pom.xml",
                         "#{tmp_path}/snyk-maven-plugin/src/it/private-repo-module/pom.xml",
                         "#{tmp_path}/snyk-maven-plugin/src/it/single-module/pom.xml"]} == ProjectIdent.is_maven?(repo)
    assert %{
      "maven" => ["#{tmp_path}/snyk-maven-plugin/pom.xml",
        "#{tmp_path}/snyk-maven-plugin/src/it/license-issues-module/pom.xml",
        "#{tmp_path}/snyk-maven-plugin/src/it/multi-module/child-module/pom.xml",
        "#{tmp_path}/snyk-maven-plugin/src/it/multi-module/pom.xml",
        "#{tmp_path}/snyk-maven-plugin/src/it/private-repo-module/pom.xml",
        "#{tmp_path}/snyk-maven-plugin/src/it/single-module/pom.xml"],
    } == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "is_gradle?(repo)", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/ReactiveX/RxKotlin", tmp_path)
    assert %{"gradle" => ["#{tmp_path}/RxKotlin/build.gradle.kts"]} == ProjectIdent.is_gradle?(repo)
    assert %{"gradle" => ["#{tmp_path}/RxKotlin/build.gradle.kts"]} == ProjectIdent.project_types?(repo)
    GitModule.delete_repo(repo)
  end

  test "project_types?(repo)", %{cwd: cwd} do
    {:ok, repo} = GitModule.get_repo(cwd)
    assert %{"mix"=>["#{cwd}/mix.exs", "#{cwd}/mix.lock"]} == ProjectIdent.project_types?(repo)
  end

  test "many build or package managers", %{tmp_path: tmp_path} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/xword/java-npm-gradle-integration-example", tmp_path)
    assert %{
      "gradle" => ["#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/build.gradle",
       "#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/java-app/build.gradle",
       "#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/npm-app/build.gradle",
       "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/build.gradle.kts",
       "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/java-app/build.gradle.kts",
       "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/npm-app/build.gradle.kts"],
      "node" => ["#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/npm-app/package.json",
       "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/npm-app/package.json"]
    } == ProjectIdent.project_types?(repo)
  end

end
