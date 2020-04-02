# Copyright (C) 2020 by the Georgia Tech Research Institute (GTRI)
# This software may be modified and distributed under the terms of
# the BSD 3-Clause license. See the LICENSE file for details.

defmodule ProjectIdentTest do
  use ExUnit.Case, async: false

  setup_all do
    {:ok, cwd} = File.cwd()
    {:ok, tmp_path} = Temp.path("lei-test")

    mix_type = %ProjectType{name: :mix, path: "**", files: ["mix.exs,mix.lock"]}
    python_type = %ProjectType{name: :python, path: "**", files: ["setup.py,*requirements.txt*"]}
    node_type = %ProjectType{name: :node, path: "**", files: ["package*.json"]}
    go_type = %ProjectType{name: :go_mod, path: "**", files: ["go.mod"]}
    cargo_type = %ProjectType{name: :cargo, path: "**", files: ["Cargo.toml"]}
    rubygem_type = %ProjectType{name: :rubygem, path: "**", files: ["Gemfile*,*.gemspec"]}
    maven_type = %ProjectType{name: :maven, path: "**", files: ["pom.xml"]}
    gradle_type = %ProjectType{name: :gradle, path: "**", files: ["build.gradle*"]}

    project_types = [
      mix_type,
      python_type,
      node_type,
      go_type,
      cargo_type,
      rubygem_type,
      maven_type,
      gradle_type
    ]

    [cwd: cwd, tmp_path: tmp_path, project_types: project_types]
  end

  doctest ProjectIdent

  test "is_python?(repo)", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} = GitModule.clone_repo("https://bitbucket.org/kitplummer/clikan", tmp_path)

    assert %{python: ["#{tmp_path}/clikan/setup.py"]} ==
             ProjectIdent.categorize_repo(repo, project_types)

    GitModule.delete_repo(repo)
  end

  test "is_node?(repo)", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/expressjs/express", tmp_path)

    assert %{node: ["#{tmp_path}/express/package.json"]} ==
             ProjectIdent.categorize_repo(repo, project_types)

    GitModule.delete_repo(repo)
  end

  test "is_go_mod?(repo)", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/go-kit/kit", tmp_path)

    assert %{
             go_mod: ["#{tmp_path}/kit/go.mod"]
           } == ProjectIdent.categorize_repo(repo, project_types)

    GitModule.delete_repo(repo)
  end

  test "is_cargo?(repo)", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/clap-rs/clap", tmp_path)

    assert %{
             cargo: [
               "#{tmp_path}/clap/Cargo.toml",
               "#{tmp_path}/clap/clap_derive/Cargo.toml",
               "#{tmp_path}/clap/clap_generate/Cargo.toml"
             ]
           } == ProjectIdent.categorize_repo(repo, project_types)

    GitModule.delete_repo(repo)
  end

  test "is_rubygem?(repo)", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/rubocop-hq/rubocop", tmp_path)

    assert %{
             rubygem: ["#{tmp_path}/rubocop/Gemfile", "#{tmp_path}/rubocop/rubocop.gemspec"]
           } == ProjectIdent.categorize_repo(repo, project_types)

    GitModule.delete_repo(repo)
  end

  test "is_maven?(repo)", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/snyk/snyk-maven-plugin", tmp_path)

    assert %{
             maven: [
               "#{tmp_path}/snyk-maven-plugin/pom.xml",
               "#{tmp_path}/snyk-maven-plugin/src/it/license-issues-module/pom.xml",
               "#{tmp_path}/snyk-maven-plugin/src/it/multi-module/child-module/pom.xml",
               "#{tmp_path}/snyk-maven-plugin/src/it/multi-module/pom.xml",
               "#{tmp_path}/snyk-maven-plugin/src/it/private-repo-module/pom.xml",
               "#{tmp_path}/snyk-maven-plugin/src/it/single-module/pom.xml"
             ]
           } == ProjectIdent.categorize_repo(repo, project_types)

    GitModule.delete_repo(repo)
  end

  test "is_gradle?(repo)", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} = GitModule.clone_repo("https://github.com/ReactiveX/RxKotlin", tmp_path)

    assert %{gradle: ["#{tmp_path}/RxKotlin/build.gradle.kts"]} ==
             ProjectIdent.categorize_repo(repo, project_types)

    GitModule.delete_repo(repo)
  end

  test "find_files", %{cwd: cwd} do
    {:ok, repo} = GitModule.get_repo(cwd)
    mix_type = %ProjectType{name: :mix, path: "", files: ["mix.exs", "mix.lock"]}

    assert ["#{cwd}/mix.exs", "#{cwd}/mix.lock"] ==
             ProjectIdent.find_files(repo, mix_type)
  end

  test "many build or package managers", %{tmp_path: tmp_path, project_types: project_types} do
    {:ok, repo} =
      GitModule.clone_repo(
        "https://github.com/xword/java-npm-gradle-integration-example",
        tmp_path
      )

    assert %{
             gradle: [
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/build.gradle",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/java-app/build.gradle",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/npm-app/build.gradle",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/build.gradle.kts",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/java-app/build.gradle.kts",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/npm-app/build.gradle.kts"
             ],
             node: [
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/npm-app/package-lock.json",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-groovy-dsl/npm-app/package.json",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/npm-app/package-lock.json",
               "#{tmp_path}/java-npm-gradle-integration-example/gradle-kotlin-dsl/npm-app/package.json"
             ]
           } == ProjectIdent.categorize_repo(repo, project_types)
  end
end
