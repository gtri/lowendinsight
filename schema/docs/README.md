# README

## Top-level Schemas

-   [LowEndInsight Analysis Data Schema](./data.md "A LowEndInsight dataset for an individual git repo") – `http://example.com/data.schema.json`
-   [LowEndInsight JSON Report (Wraps Data) Schema](./report.md "A LowEndInsight report (query response)") – `http://example.com/report.schema.json`

## Other Schemas

### Objects

-   [LowEndInsight Analysis Data](./data-properties-lowendinsight-analysis-data.md "The report data") – `http://example.com/data.schema.json#/properties/data`
-   [LowEndInsight Analysis Times](./report-properties-lowendinsight-report-metadata-properties-lowendinsight-analysis-times.md "Start, End and Duration times for LowEndInsight times") – `http://example.com/report.schema.json#/properties/metadata/properties/times`
-   [LowEndInsight Configuration Inputs](./data-properties-lowendinsight-analysis-data-properties-lowendinsight-configuration-inputs.md "Configuration criteria for LowEndInsight to use in defining analysis levels") – `http://example.com/data.schema.json#/properties/data/properties/config`
-   [LowEndInsight Per-Repo Analsyis Metadata](./data-properties-lowendinsight-per-repo-analsyis-metadata.md "Information about the report's generation") – `http://example.com/data.schema.json#/properties/header`
-   [LowEndInsight Per-Repo Analysis Results](./data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results.md "The LowEndInsight analysis data for a given repo") – `http://example.com/data.schema.json#/properties/data/properties/results`
-   [LowEndInsight Report Metadata](./report-properties-lowendinsight-report-metadata.md "Collection of rolled-up data about the LowEndInsight analysis process and results") – `http://example.com/report.schema.json#/properties/metadata`
-   [LowEndInsight Risk Level Counts](./report-properties-lowendinsight-report-metadata-properties-lowendinsight-risk-level-counts.md "Counts of hits against each risk level") – `http://example.com/report.schema.json#/properties/metadata/properties/risk_counts`
-   [LowEndSight Analysis Array of Reports](./report-properties-lowendsight-analysis-array-of-reports.md "Collection of repo analysis as a single document") – `http://example.com/report.schema.json#/properties/report`
-   [Project Types](./data-properties-lowendinsight-analysis-data-properties-project-types.md "Enumeration of project types within the repo, based on build tooling configuration found") – `http://example.com/data.schema.json#/properties/data/properties/project_types`
-   [Untitled object in LowEndInsight Analysis Data Schema](./data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-top-10-contributors-items.md) – `http://example.com/data.schema.json#/properties/data/properties/results/properties/top10_contributors/items`

### Arrays

-   [Functional Contributors per Repo](./data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-functional-contributors-per-repo.md "Collection of contributors labeled as 'functional' by LowEndInsight") – `http://example.com/data.schema.json#/properties/data/properties/results/properties/functional_contributor_names`
-   [LowEndInsight Analyzed Git Repos](./report-properties-lowendsight-analysis-array-of-reports-properties-lowendinsight-analyzed-git-repos.md "Array of repo's analyzed") – `http://example.com/report.schema.json#/properties/report/properties/repos`
-   [Top 10 Contributors](./data-properties-lowendinsight-analysis-data-properties-lowendinsight-per-repo-analysis-results-properties-top-10-contributors.md "Top 10 contributors by number of contributions") – `http://example.com/data.schema.json#/properties/data/properties/results/properties/top10_contributors`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `http://json-schema.org/draft-07/schema#`
