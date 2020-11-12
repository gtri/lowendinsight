# LowEndInsight Report Metadata Schema

```txt
http://example.com/report.schema.json#/properties/metadata
```

Collection of rolled-up data about the LowEndInsight analysis process and results.


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                     |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | ------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [report.schema.json\*](../../out/v1/report.schema.json "open original schema") |

## metadata Type

`object` ([LowEndInsight Report Metadata](report-properties-lowendinsight-report-metadata.md))

# LowEndInsight Report Metadata Properties

| Property                    | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                                              |
| :-------------------------- | -------- | -------- | -------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [repo_count](#repo_count)   | `number` | Required | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata-properties-repo_count.md "http&#x3A;//example.com/report.schema.json#/properties/metadata/properties/repo_count")                       |
| [risk_counts](#risk_counts) | `object` | Required | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata-properties-lowendinsight-risk-level-counts.md "http&#x3A;//example.com/report.schema.json#/properties/metadata/properties/risk_counts") |
| [times](#times)             | `object` | Required | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata-properties-lowendinsight-analysis-times.md "http&#x3A;//example.com/report.schema.json#/properties/metadata/properties/times")          |

## repo_count




`repo_count`

-   is required
-   Type: `number`
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata-properties-repo_count.md "http&#x3A;//example.com/report.schema.json#/properties/metadata/properties/repo_count")

### repo_count Type

`number`

## risk_counts

Counts of hits against each risk level


`risk_counts`

-   is required
-   Type: `object` ([LowEndInsight Risk Level Counts](report-properties-lowendinsight-report-metadata-properties-lowendinsight-risk-level-counts.md))
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata-properties-lowendinsight-risk-level-counts.md "http&#x3A;//example.com/report.schema.json#/properties/metadata/properties/risk_counts")

### risk_counts Type

`object` ([LowEndInsight Risk Level Counts](report-properties-lowendinsight-report-metadata-properties-lowendinsight-risk-level-counts.md))

## times

Start, End and Duration times for LowEndInsight times.


`times`

-   is required
-   Type: `object` ([LowEndInsight Analysis Times](report-properties-lowendinsight-report-metadata-properties-lowendinsight-analysis-times.md))
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata-properties-lowendinsight-analysis-times.md "http&#x3A;//example.com/report.schema.json#/properties/metadata/properties/times")

### times Type

`object` ([LowEndInsight Analysis Times](report-properties-lowendinsight-report-metadata-properties-lowendinsight-analysis-times.md))
