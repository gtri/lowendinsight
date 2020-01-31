# LowEndInsight Risk Classifiers Schema

```txt
http://example.com/data.schema.json#/definitions/risk-level
```

Risk Ratings - Based on NIST CVSS Severity Classifications


| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                        |
| :------------------ | ---------- | -------------- | ----------------------- | :---------------- | --------------------- | ------------------- | --------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Forbidden             | none                | [data.schema.json\*](../../out/schema/v1/data.schema.json "open original schema") |

## risk-level Type

unknown ([LowEndInsight Risk Classifiers](data-definitions-lowendinsight-risk-classifiers.md))

## risk-level Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value        | Explanation |
| :----------- | ----------- |
| `"critical"` |             |
| `"high"`     |             |
| `"medium"`   |             |
| `"low"`      |             |
