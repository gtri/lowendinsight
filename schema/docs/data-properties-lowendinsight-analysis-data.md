# LowEndInsight Analysis Data Schema

```txt
http://example.com/data.schema.json#/properties/data
```

The report data


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | -------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [data.schema.json\*](../../out/v1/data.schema.json "open original schema") |

## data Type

`object` ([LowEndInsight Analysis Data](data-properties-lowendinsight-analysis-data.md))

any of

-   [LowEndInsight Results](data-properties-lowendinsight-analysis-data-anyof-lowendinsight-results.md "check type definition")
-   [LowEndInsight Error](data-properties-lowendinsight-analysis-data-anyof-lowendinsight-error.md "check type definition")

# LowEndInsight Analysis Data Properties

| Property                        | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                             |
| :------------------------------ | -------- | -------- | -------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [config](#config)               | `object` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-configuration-inputs.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/config")       |
| [error](#error)                 | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-error-message.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/error")                             |
| [git](#git)                     | `object` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-git-data.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/git")                                    |
| [repo](#repo)                   | `string` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-source-git-repo.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/repo")                            |
| [repo_size](#repo_size)         | `string` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-repo_size.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/repo_size")                             |
| [project_types](#project_types) | `object` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-project-types.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/project_types")                     |
| [results](#results)             | `object` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results") |
| [risk](#risk)                   | `string` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-rolled-up-risk-for-a-repo.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/risk")    |

## config

Configuration criteria for LowEndInsight to use in defining analysis levels.


`config`

-   is optional
-   Type: `object` ([LowEndInsight Configuration Inputs](data-properties-lowendinsight-analysis-data-properties-lowendinsight-configuration-inputs.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-configuration-inputs.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/config")

### config Type

`object` ([LowEndInsight Configuration Inputs](data-properties-lowendinsight-analysis-data-properties-lowendinsight-configuration-inputs.md))

## error

If LowEndInsight is unable to analyze a repo, it will respond with this error field.


`error`

-   is optional
-   Type: `string` ([Error message](data-properties-lowendinsight-analysis-data-properties-error-message.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-error-message.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/error")

### error Type

`string` ([Error message](data-properties-lowendinsight-analysis-data-properties-error-message.md))

### error Examples

```json
"Unable to analyze the repo (https://github.com/kitplummer/blah), is this a valid Git repo URL?"
```

```json
"Unable to analyze the repo (https://github.com/kitplummer/blah), LowEndInsight configuration not found."
```

## git

Collection of git-centric data


`git`

-   is required
-   Type: `object` ([Git data](data-properties-lowendinsight-analysis-data-properties-git-data.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-git-data.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/git")

### git Type

`object` ([Git data](data-properties-lowendinsight-analysis-data-properties-git-data.md))

## repo

The git repo url being analyzed by LowEndInsight.


`repo`

-   is required
-   Type: `string` ([Source Git Repo](data-properties-lowendinsight-analysis-data-properties-source-git-repo.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-source-git-repo.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/repo")

### repo Type

`string` ([Source Git Repo](data-properties-lowendinsight-analysis-data-properties-source-git-repo.md))

## repo_size

Space consumed by the source repo.


`repo_size`

-   is required
-   Type: `string`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-repo_size.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/repo_size")

### repo_size Type

`string`

## project_types

Enumeration of project types within the repo, based on build tooling configuration found.


`project_types`

-   is required
-   Type: `object` ([Project Types](data-properties-lowendinsight-analysis-data-properties-project-types.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-project-types.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/project_types")

### project_types Type

`object` ([Project Types](data-properties-lowendinsight-analysis-data-properties-project-types.md))

## results

The LowEndInsight analysis data for a given repo.


`results`

-   is optional
-   Type: `object` ([LowEndInsight Per-Repo Analysis Results](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results")

### results Type

`object` ([LowEndInsight Per-Repo Analysis Results](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results.md))

## risk

The risk associated with analysis on a given repository, highest level risk identified.


`risk`

-   is required
-   Type: `string` ([LowEndInsight Rolled-Up Risk for a Repo](data-properties-lowendinsight-analysis-data-properties-lowendinsight-rolled-up-risk-for-a-repo.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-rolled-up-risk-for-a-repo.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/risk")

### risk Type

`string` ([LowEndInsight Rolled-Up Risk for a Repo](data-properties-lowendinsight-analysis-data-properties-lowendinsight-rolled-up-risk-for-a-repo.md))
