# Untitled string in LowEndInsight JSON Report (Wraps Data) Schema Schema

```txt
http://example.com/report.schema.json#/properties/report/properties/uuid
```




| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                     |
| :------------------ | ---------- | -------------- | ----------------------- | :---------------- | --------------------- | ------------------- | ------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [report.schema.json\*](../../out/v1/report.schema.json "open original schema") |

## uuid Type

`string`

## uuid Constraints

**pattern**: the string must match the following regular expression: 

```regexp
[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}
```

[try pattern](https://regexr.com/?expression=%5B0-9a-f%5D%7B8%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B4%7D-%5B0-9a-f%5D%7B12%7D "try regular expression with regexr.com")
