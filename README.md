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
    "DisplayLabel": "Id",
    "DataType": "ftInteger",
    "Size": 0,
    "Key": false,
    "Origin": "",
    "Required": true,
    "Visible": true
  },
  {
    "FieldName": "NAME",
    "DisplayLabel": "Name",
    "DataType": "ftString",
    "Size": 100,
    "Key": false,
    "Origin": "",
    "Required": true,
    "Visible": true
  },
  {
    "FieldName": "COUNTRY",
    "DisplayLabel": "Country",
    "DataType": "ftString",
    "Size": 60,
    "Key": false,
    "Origin": "",
    "Required": false,
    "Visible": false
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
        "DisplayLabel": "Id",
        "DataType": "ftInteger",
        "Size": 0,
        "Key": false,
        "Origin": "",
        "Required": true,
        "Visible": true
      },
      {
        "FieldName": "NAME",
        "DisplayLabel": "Name",
        "DataType": "ftString",
        "Size": 100,
        "Key": false,
        "Origin": "",
        "Required": true,
        "Visible": true
      },
      {
        "FieldName": "COUNTRY",
        "DisplayLabel": "Country",
        "DataType": "ftString",
        "Size": 60,
        "Key": false,
        "Origin": "",
        "Required": false,
        "Visible": false
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
  JSON = 
    '{
       "NAME": "Vinicius Sanchez",
       "COUNTRY": "Brazil"
    }';
var
  JSONObject: TJSONObject;
begin
  JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSON),0) as TJSONObject;
  qrySample.LoadFromJSONObject(JSONObject);
end;
``` 

#### Load from JSON Array
```
const 
  JSON = 
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
  JSONArray := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSON),0) as TJSONArray;
  qrySample.LoadFromJSONArray(JSONArray);
end;
``` 

#### Merge (Edit current record)
```
const 
  JSON = 
    '{
       "NAME": "Vinicius",
       "COUNTRY": "United States"
    }';
var
  JSONObject: TJSONObject;
begin
  JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSON),0) as TJSONObject;
  qrySample.MergeFromJSONObject(JSONObject);
end;
``` 

#### Validate JSON

Scroll through all DataSet fields by checking the fields that are required. If the field is required and has not been entered in JSON, it is added in the Array.

```
const 
  JSON_VALIDATE = 
    '{
       "COUNTRY": "Brazil"
    }';
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSON_VALIDATE),0) as TJSONObject;
  mmJSONArrayValidate.Lines.Text := mtJSON.ValidateJSON(JSON, TLanguageType.ptBR).ToString;
end;
``` 

Returns:

``` 
[
  {
    "field": "ID",
    "error": "Id não foi informado(a)"
  },
  {
    "field": "NAME",
    "error": "Name não foi informado(a)"
  }
]
``` 

The default language is English (TLanguageType.enUS);

``` 
mmJSONArrayValidate.Lines.Text := mtJSON.ValidateJSON(JSON).ToString;

Returns:

[
  {
    "field": "ID",
    "error": "Id not defined"
  },
  {
    "field": "NAME",
    "error": "Name not defined"
  }
]
``` 

### Samples - DataSet

![Imgur](https://i.imgur.com/6tfb4Lp.png)

### Samples - JSON

![Imgur](https://i.imgur.com/K9VtCzK.png)