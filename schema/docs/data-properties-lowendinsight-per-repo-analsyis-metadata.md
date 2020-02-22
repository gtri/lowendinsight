# LowEndInsight Per-Repo Analsyis Metadata Schema

```txt
http://example.com/data.schema.json#/properties/header
```

Information about the report's generation.


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | -------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [data.schema.json\*](../../out/v1/data.schema.json "open original schema") |

## header Type

`object` ([LowEndInsight Per-Repo Analsyis Metadata](data-properties-lowendinsight-per-repo-analsyis-metadata.md))

# LowEndInsight Per-Repo Analsyis Metadata Properties

| Property                            | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                            |
| :---------------------------------- | -------- | -------- | -------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [duration](#duration)               | `number` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-duration.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/duration")               |
| [end_time](#end_time)               | `string` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-end_time.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/end_time")               |
| [start_time](#start_time)           | `string` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-start_time.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/start_time")           |
| [uuid](#uuid)                       | `string` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-uuid.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/uuid")                       |
| [library_version](#library_version) | `string` | Required | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-library_version.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/library_version") |
| [source_client](#source_client)     | `string` | Optional | cannot be null | [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-source_client.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/source_client")     |

## duration

Time it took to complete the analysis of this repo (in seconds).


`duration`

-   is required
-   Type: `number`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-duration.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/duration")

### duration Type

`number`

## end_time

ISO8601 Date string for the end of analysis.


`end_time`

-   is required
-   Type: `string`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-end_time.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/end_time")

### end_time Type

`string`

## start_time

ISO8601 Date string for the start of analysis.


`start_time`

-   is required
-   Type: `string`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-start_time.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/start_time")

### start_time Type

`string`

## uuid

Unique identifier for this given analysis.


`uuid`

-   is required
-   Type: `string`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-uuid.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/uuid")

### uuid Type

`string`

### uuid Constraints

**pattern**: the string must match the following regular expression: 

```regexp
[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
```

[try pattern](https://regexr.com/?expression=%5B0-9a-f%5D%7B8%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B12%7D "try regular expression with regexr.com")

## library_version

The version of the LowEndInsight library that analyzed this repo.


`library_version`

-   is required
-   Type: `string`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-library_version.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/library_version")

### library_version Type

`string`

## source_client

Identifier of what instigated this analysis.


`source_client`

-   is optional
-   Type: `string`
-   cannot be null
-   defined in: [LowEndInsight Analysis Data Schema](data-properties-lowendinsight-per-repo-analsyis-metadata-properties-source_client.md "http&#x3A;//example.com/data.schema.json#/properties/header/properties/source_client")

### source_client Type

`string`
