# DataSet Serialization for Delphi
This component is a JSON serializer for the DataSet component of Delphi. Allows you to convert JSON to DataSet and DataSet in JSON.
 
### Installation: 

#### Using Boss
 * [**Boss**](https://github.com/HashLoad/boss) - Dependency Manager for Delphi

```
boss install github.com/viniciussanchez/dataset-serialize
```

#### Or

Add the following folders to your project:

```
../dataset-serialize/src
../dataset-serialize/src/core
../dataset-serialize/src/helpers
../dataset-serialize/src/interfaces
../dataset-serialize/src/providers
../dataset-serialize/src/types
```

### Getting Started
You need to use DataSet.Serialize.Helper
```
uses DataSet.Serialize.Helper;
```

#### DataSet to JSON Object
```
var
  JSONObject: TJSONObject;
begin
  JSONObject := qrySample.ToJSONObject;
end;
``` 

Returns:

``` 
{
  "ID": 1,
  "NAME": "Vinicius Sanchez",
  "COUNTRY": "Brazil"
}
``` 

#### DataSet to JSON Array
```
var
  JSONArray: TJSONArray;
begin
  JSONArray := qrySample.ToJSONArray;
end;
``` 

Returns:

``` 
[
  {
    "ID": 1,
    "NAME": "Vinicius Sanchez",
    "COUNTRY": "Brazil"
  },
  {
    "ID": 2,
    "NAME": "Vinicius Sanchez",
    "COUNTRY": "Brazil"
  }
]
``` 

#### Save the field structure
```
var
  JSONArray: TJSONArray;
begin
  JSONArray := qrySample.SaveStructure;
end;
``` 

Returns:

``` 
[
  {
    "FieldName": "ID",
    "DataType": "ftInteger",
    "Size": 0,
    "Key": false,
    "Origin": ""
  },
  {
    "FieldName": "NAME",
    "DataType": "ftString",
    "Size": 100,
    "Key": false,
    "Origin": ""
  },
  {
    "FieldName": "COUNTRY",
    "DataType": "ftString",
    "Size": 60,
    "Key": false,
    "Origin": ""
  }
]
``` 

#### Load the field structure
```
const 
  STRUCTURE = 
    '[
      {
        "FieldName": "ID",
        "DataType": "ftInteger",
        "Size": 0,
        "Key": false,
        "Origin": ""
      },
      {
        "FieldName": "NAME",
        "DataType": "ftString",
        "Size": 100,
        "Key": false,
        "Origin": ""
      },
      {
        "FieldName": "COUNTRY",
        "DataType": "ftString",
        "Size": 60,
        "Key": false,
        "Origin": ""
      }
    ]';
var
  JSONArray: TJSONArray;
begin
  JSONArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(STRUCTURE),0) as TJSONArray;
  qrySample.LoadStructure(JSONArray);
end;
``` 

#### Load from JSON Object
```
const 
  STRUCTURE = 
    '{
       "NAME": "Vinicius Sanchez",
       "COUNTRY": "Brazil"
    }';
var
  JSONObject: TJSONObject;
begin
  JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(STRUCTURE),0) as TJSONObject;
  qrySample.LoadFromJSONObject(JSONObject);
end;
``` 

#### Load from JSON Array
```
const 
  STRUCTURE = 
    '[
       {
         "NAME": "Vinicius Sanchez",
         "COUNTRY": "Brazil"
       },
       {
         "NAME": "Mateus Vicente",
         "COUNTRY": "Brazil"
       }
    ]';
var
  JSONArray: TJSONArray;
begin
  JSONArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(STRUCTURE),0) as TJSONArray;
  qrySample.LoadFromJSONArray(JSONArray);
end;
``` 

#### Merge (Edit current record)
```
const 
  STRUCTURE = 
    '{
       "NAME": "Vinicius",
       "COUNTRY": "United States"
    }';
var
  JSONObject: TJSONObject;
begin
  JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(STRUCTURE),0) as TJSONObject;
  qrySample.MergeFromJSONObject(JSONObject);
end;
``` 

### Samples - DataSet

![Imgur](https://i.imgur.com/6tfb4Lp.png)

### Samples - JSON

![Imgur](https://i.imgur.com/Wor3XXC.png)