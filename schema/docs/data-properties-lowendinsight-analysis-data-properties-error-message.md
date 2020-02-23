# Error message Schema

```txt
http://example.com/data.schema.json#/properties/data/properties/error
```

If LowEndInsight is unable to analyze a repo, it will respond with this error field.


| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                 |
| :------------------ | ---------- | -------------- | ----------------------- | :---------------- | --------------------- | ------------------- | -------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [data.schema.json\*](../../out/v1/data.schema.json "open original schema") |

## error Type

`string` ([Error message](data-properties-lowendinsight-analysis-data-properties-error-message.md))

## error Examples

```json
"Unable to analyze the repo (https://github.com/kitplummer/blah), is this a valid Git repo URL?"
```

```json
"Unable to analyze the repo (https://github.com/kitplummer/blah), LowEndInsight configuration not found."
```
