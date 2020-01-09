# LowEndInsight Per-Repo Analysis Results Schema

```txt
http://example.com/data.schema.json#/properties/data/properties/results
```

The LowEndInsight analysis data for a given repo.


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                        |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | --------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [data.schema.json\*](../../out/schema/v1/data.schema.json "open original schema") |

## results Type

`object` ([LowEndInsight Per-Repo Analysis Results](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results.md))

# LowEndInsight Per-Repo Analysis Results Properties

| Property                                                                                | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                                                                                                                       |
| :-------------------------------------------------------------------------------------- | -------- | -------- | -------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [commit_currency_risk](#commit_currency_risk)                                           | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/commit_currency_risk")                                           |
| [commit_currency_weeks](#commit_currency_weeks)                                         | `number` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-weeks.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/commit_currency_weeks")                                         |
| [contributor_count](#contributor_count)                                                 | `number` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-count.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/contributor_count")                                                 |
| [contributor_risk](#contributor_risk)                                                   | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/contributor_risk")                                                   |
| [functional_contributor_names](#functional_contributor_names)                           | `array`  | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors-per-repo.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/functional_contributor_names")                       |
| [functional_contributors](#functional_contributors)                                     | `number` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/functional_contributors")                                     |
| [functional_contributors_risk](#functional_contributors_risk)                           | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/functional_contributors_risk")                           |
| [large_recent_commit_risk](#large_recent_commit_risk)                                   | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-large-recent-commit-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/large_recent_commit_risk")                                   |
| [recent_commit_size_in_percent_of_codebase](#recent_commit_size_in_percent_of_codebase) | `number` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-recent-commit-size-in-percent-of-codebase.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/recent_commit_size_in_percent_of_codebase") |

## commit_currency_risk

Risk associated with the currency of the source repo activity.


`commit_currency_risk`

-   is optional
-   Type: `string` ([Commit Currency Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-risk.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/commit_currency_risk")

### commit_currency_risk Type

`string` ([Commit Currency Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-risk.md))

## commit_currency_weeks

How long since the last commit to this repo (in weeks).


`commit_currency_weeks`

-   is optional
-   Type: `number` ([Commit Currency Weeks](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-weeks.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-weeks.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/commit_currency_weeks")

### commit_currency_weeks Type

`number` ([Commit Currency Weeks](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-commit-currency-weeks.md))

## contributor_count

Number of unique contributors to this repo


`contributor_count`

-   is optional
-   Type: `number` ([Contributor Count](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-count.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-count.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/contributor_count")

### contributor_count Type

`number` ([Contributor Count](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-count.md))

## contributor_risk

Risk associated with the number of contributors to this repo.


`contributor_risk`

-   is optional
-   Type: `string` ([Contributor Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-risk.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/contributor_risk")

### contributor_risk Type

`string` ([Contributor Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-contributor-risk.md))

## functional_contributor_names

Collection of contributors labeled as 'functional' by LowEndInsight.


`functional_contributor_names`

-   is optional
-   Type: `string[]`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors-per-repo.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/functional_contributor_names")

### functional_contributor_names Type

`string[]`

## functional_contributors

Number of functional contributors.


`functional_contributors`

-   is optional
-   Type: `number` ([Functional Contributors](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/functional_contributors")

### functional_contributors Type

`number` ([Functional Contributors](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors.md))

## functional_contributors_risk

Risk associated with the number of functional contributors.


`functional_contributors_risk`

-   is optional
-   Type: `string` ([Functional Contributors Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors-risk.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/functional_contributors_risk")

### functional_contributors_risk Type

`string` ([Functional Contributors Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors-risk.md))

## large_recent_commit_risk

Risk associated with the amount of change within recent commits - volatility.


`large_recent_commit_risk`

-   is optional
-   Type: `string` ([Large Recent Commit Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-large-recent-commit-risk.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-large-recent-commit-risk.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/large_recent_commit_risk")

### large_recent_commit_risk Type

`string` ([Large Recent Commit Risk](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-large-recent-commit-risk.md))

## recent_commit_size_in_percent_of_codebase

Percent of codebase changed by recent commits.


`recent_commit_size_in_percent_of_codebase`

-   is optional
-   Type: `number` ([Recent Commit Size in Percent of Codebase](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-recent-commit-size-in-percent-of-codebase.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-recent-commit-size-in-percent-of-codebase.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/results/properties/recent_commit_size_in_percent_of_codebase")

### recent_commit_size_in_percent_of_codebase Type

`number` ([Recent Commit Size in Percent of Codebase](data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-recent-commit-size-in-percent-of-codebase.md))
