# LowEndSight Analysis Array of Reports Schema

```txt
http://example.com/report.schema.json#/properties/report
```

Collection of repo analysis as a single document.


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                     |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | ------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [report.schema.json\*](../../out/v1/report.schema.json "open original schema") |

## report Type

`object` ([LowEndSight Analysis Array of Reports](report-properties-lowendsight-analysis-array-of-reports.md))

# LowEndSight Analysis Array of Reports Properties

| Property        | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                               |
| :-------------- | -------- | -------- | -------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [repos](#repos) | `array`  | Required | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports-properties-lowendinsight-analyzed-git-repos.md "http&#x3A;//example.com/report.schema.json#/properties/report/properties/repos") |
| [state](#state) | `string` | Optional | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports-properties-lowendinsight-analysis-status.md "http&#x3A;//example.com/report.schema.json#/properties/report/properties/state")    |
| [uuid](#uuid)   | `string` | Optional | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports-properties-uuid.md "http&#x3A;//example.com/report.schema.json#/properties/report/properties/uuid")                              |

## repos

Array of repo's analyzed.


`repos`

-   is required
-   Type: unknown\[]
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports-properties-lowendinsight-analyzed-git-repos.md "http&#x3A;//example.com/report.schema.json#/properties/report/properties/repos")

### repos Type

unknown\[]

## state

Status of the analysis.


`state`

-   is optional
-   Type: `string` ([LowEndInsight Analysis Status](report-properties-lowendsight-analysis-array-of-reports-properties-lowendinsight-analysis-status.md))
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports-properties-lowendinsight-analysis-status.md "http&#x3A;//example.com/report.schema.json#/properties/report/properties/state")

### state Type

`string` ([LowEndInsight Analysis Status](report-properties-lowendsight-analysis-array-of-reports-properties-lowendinsight-analysis-status.md))

## uuid




`uuid`

-   is optional
-   Type: `string`
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports-properties-uuid.md "http&#x3A;//example.com/report.schema.json#/properties/report/properties/uuid")

### uuid Type

`string`

### uuid Constraints

**pattern**: the string must match the following regular expression: 

```regexp
[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
```

[try pattern](https://regexr.com/?expression=%5B0-9a-f%5D%7B8%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B12%7D "try regular expression with regexr.com")
