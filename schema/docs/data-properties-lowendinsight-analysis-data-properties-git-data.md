# Git data Schema

```txt
http://example.com/data.schema.json#/properties/data/properties/git
```

Collection of git-centric data


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | -------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [data.schema.json\*](../../out/v1/data.schema.json "open original schema") |

## git Type

`object` ([Git data](data-properties-lowendinsight-analysis-data-properties-git-data.md))

# Git data Properties

| Property                          | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                              |
| :-------------------------------- | -------- | -------- | -------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [default_branch](#default_branch) | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-git-data-properties-default-branch.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/git/properties/default_branch") |
| [hash](#hash)                     | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-git-data-properties-current-hash.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/git/properties/hash")             |

## default_branch

The remote repository's default branch


`default_branch`

-   is optional
-   Type: `string` ([Default branch](data-properties-lowendinsight-analysis-data-properties-git-data-properties-default-branch.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-git-data-properties-default-branch.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/git/properties/default_branch")

### default_branch Type

`string` ([Default branch](data-properties-lowendinsight-analysis-data-properties-git-data-properties-default-branch.md))

## hash

The repository's current hash


`hash`

-   is optional
-   Type: `string` ([Current hash](data-properties-lowendinsight-analysis-data-properties-git-data-properties-current-hash.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data-properties-git-data-properties-current-hash.md "http&#x3A;//example.com/data.schema.json#/properties/data/properties/git/properties/hash")

### hash Type

`string` ([Current hash](data-properties-lowendinsight-analysis-data-properties-git-data-properties-current-hash.md))
