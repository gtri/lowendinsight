# LowEndInsight JSON Report (Wraps Data) Schema Schema

```txt
http://example.com/report.schema.json
```

A LowEndInsight report (query response).


| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                   |
| :------------------ | ---------- | -------------- | ------------ | :---------------- | --------------------- | ------------------- | ---------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [report.schema.json](../../out/v1/report.schema.json "open original schema") |

## LowEndInsight JSON Report (Wraps Data) Schema Type

`object` ([LowEndInsight JSON Report (Wraps Data) Schema](report.md))

# LowEndInsight JSON Report (Wraps Data) Schema Properties

| Property              | Type     | Required | Nullable       | Defined by                                                                                                                                                                  |
| :-------------------- | -------- | -------- | -------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [state](#state)       | `string` | Required | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-analysis-state.md "http&#x3A;//example.com/report.schema.json#/properties/state")           |
| [report](#report)     | `object` | Required | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports.md "http&#x3A;//example.com/report.schema.json#/properties/report") |
| [metadata](#metadata) | `object` | Required | cannot be null | [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata.md "http&#x3A;//example.com/report.schema.json#/properties/metadata")       |

## state

State of the analysis work.


`state`

-   is required
-   Type: `string` ([LowEndInsight Analysis State](report-properties-lowendinsight-analysis-state.md))
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-analysis-state.md "http&#x3A;//example.com/report.schema.json#/properties/state")

### state Type

`string` ([LowEndInsight Analysis State](report-properties-lowendinsight-analysis-state.md))

## report

Collection of repo analysis as a single document.


`report`

-   is required
-   Type: `object` ([LowEndSight Analysis Array of Reports](report-properties-lowendsight-analysis-array-of-reports.md))
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendsight-analysis-array-of-reports.md "http&#x3A;//example.com/report.schema.json#/properties/report")

### report Type

`object` ([LowEndSight Analysis Array of Reports](report-properties-lowendsight-analysis-array-of-reports.md))

## metadata

Collection of rolled-up data about the LowEndInsight analysis process and results.


`metadata`

-   is required
-   Type: `object` ([LowEndInsight Report Metadata](report-properties-lowendinsight-report-metadata.md))
-   cannot be null
-   defined in: [LowEndInsight JSON Report (Wraps Data) Schema](report-properties-lowendinsight-report-metadata.md "http&#x3A;//example.com/report.schema.json#/properties/metadata")

### metadata Type

`object` ([LowEndInsight Report Metadata](report-properties-lowendinsight-report-metadata.md))
