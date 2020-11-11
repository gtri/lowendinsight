# LowEndInsight Analysis Data Schema Schema

```txt
http://example.com/data.schema.json
```

A LowEndInsight dataset for an individual git repo.


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                               |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | ------------------------------------------------------------------------ |
| Can be instantiated | Yes        | Unknown status | No           | Forbidden         | Allowed               | none                | [data.schema.json](../../out/v1/data.schema.json "open original schema") |

## LowEndInsight Analysis Data Schema Type

`object` ([LowEndInsight Analysis Data Schema](data.md))

# LowEndInsight Analysis Data Schema Definitions

## Definitions group risk-level

Reference this group by using

```json
{"$ref":"http://example.com/data.schema.json#/definitions/risk-level"}
```

| Property | Type | Required | Nullable | Defined by |
| :------- | ---- | -------- | -------- | :--------- |

# LowEndInsight Analysis Data Schema Properties

| Property          | Type     | Required | Nullable       | Defined by                                                                                                                                                      |
| :---------------- | -------- | -------- | -------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [data](#data)     | Merged   | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data.md "http&#x3A;//example.com/data.schema.json#/properties/data")                |
| [header](#header) | `object` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata.md "http&#x3A;//example.com/data.schema.json#/properties/header") |

## data

The report data


`data`

-   is required
-   Type: `object` ([LowEndInsight Analysis Data](data-properties-lowendinsight-analysis-data.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-analysis-data.md "http&#x3A;//example.com/data.schema.json#/properties/data")

### data Type

`object` ([LowEndInsight Analysis Data](data-properties-lowendinsight-analysis-data.md))

any of

-   [LowEndInsight Results](data-properties-lowendinsight-analysis-data-anyof-lowendinsight-results.md "check type definition")
-   [LowEndInsight Error](data-properties-lowendinsight-analysis-data-anyof-lowendinsight-error.md "check type definition")

## header

Information about the report's generation.


`header`

-   is optional
-   Type: `object` ([LowEndInsight Per-Repo Analsyis Metadata](data-properties-lowendinsight-per-repo-analsyis-metadata.md))
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata.md "http&#x3A;//example.com/data.schema.json#/properties/header")

### header Type

`object` ([LowEndInsight Per-Repo Analsyis Metadata](data-properties-lowendinsight-per-repo-analsyis-metadata.md))
