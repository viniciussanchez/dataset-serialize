# DataSet Serialize for Delphi
![Delphi Supported Versions](https://img.shields.io/badge/Delphi%20Supported%20Versions-XE3..10.3%20Rio-blue.svg)
![Platforms](https://img.shields.io/badge/Supported%20platforms-Win32%20and%20Win64-red.svg)

DataSet Serialize is a set of features to make working with JSON and DataSet simple. It has features such as exporting or importing records into a DataSet, validate if JSON has all required attributes (previously entered in the DataSet), exporting or importing the structure of DataSet fields in JSON format. In addition to managing nested JSON through master detail or using TDataSetField (you choose the way that suits you best). All this using class helpers, which makes it even simpler and easier to use.
 
## Prerequisites
 * `[Optional]` For ease I recommend using the [**Boss**](https://github.com/HashLoad/boss) (Dependency Manager for Delphi) for installation, simply by running the command below on a terminal (Windows PowerShell for example):
```
boss install github.com/viniciussanchez/dataset-serialize
```

## Manual Installation
If you choose to install manually, simply add the following folders to your project, in *Project > Options > Resource Compiler > Directories and Conditionals > Include file search path*
```
../dataset-serialize/src
../dataset-serialize/src/core
../dataset-serialize/src/helpers
../dataset-serialize/src/providers
../dataset-serialize/src/types
```

## Getting Started
All features offered by DataSet Serialize are located in the class helper in unit `DataSet.Serialize.Helper`. To get your project started, simply add your reference where your functionality is needed. Here's an example:
```pascal
uses DataSet.Serialize.Helper;
```
Let's now look at each feature, its rules and peculiarities, to deliver the best to all users.

## DataSet to JSON
Creating a JSON object with information from a DataSet record seems like a very simple task for Delphi users. But that task just got easier. DataSet Serialize has two functions for this, namely `ToJSONObject` and `ToJSONArray`. Let's look at the use of the functions:

```pascal
var
  LJSONArray: TJSONArray;
  LJSONObject: TJSONObject;  
begin
  LJSONObject := qrySamples.ToJSONObject;
  LJSONArray := qrySamples.ToJSONArray;  
end;
```  
What is the difference between the two functions? `ToJSONObject` will only convert the current DataSet record to a `TJSONObject`. `ToJSONArray` will convert to a `TJSONArray` all the records of the DataSet and not just the selected record.

## Rules and peculiarities
* **ToJSONObject**
  * If the DataSet is empty or not assigned, a blank JSON object (`{}`) will be returned;
  * The field that does not have the visible (`True`) property will be ignored. The same is true if its value is null or empty;
  * The attribute name in JSON will always be the field name in lower case, even if the field name is in upper case;
  * If the field is of type `TDataSetField`, a nested JSON is generated (JSONObject if it is just a child record, or JSONArray if it is more than one). The most suitable way for this type of situation is to create a master detail;
* **ToJSONArray**
  * If the DataSet is empty or not assigned, a blank JSON array (`[]`) will be returned;  
  * Follows the same rules as `ToJSONObject`;

#### Save the field structure
```pascal
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
    "Required": false,
    "Visible": true,
    "ReadOnly": true,
    "AutoGenerateValue": "arAutoInc"
  },
  {
    "FieldName": "NAME",
    "DisplayLabel": "Name",
    "DataType": "ftString",
    "Size": 100,
    "Key": false,
    "Origin": "",
    "Required": true,
    "Visible": true,
    "ReadOnly": false,
    "AutoGenerateValue": "arNone"
  }
]
``` 

#### Load the field structure
```pascal
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
        "Visible": true,
        "ReadOnly": true,
        "AutoGenerateValue": "arAutoInc"
      },
      {
        "FieldName": "NAME",
        "DisplayLabel": "Name",
        "DataType": "ftString",
        "Size": 100,
        "Key": false,
        "Origin": "",
        "Required": true,
        "Visible": true,
        "ReadOnly": false,
        "AutoGenerateValue": "arNone"
      }
    ]';
begin
  qrySample.LoadStructure(STRUCTURE);
end;
``` 

#### Load from JSON
```pascal
const 
  JSON = '{"NAME":"Vinicius Sanchez","COUNTRY":"Brazil"}'; // or JSONArray
begin
  qrySample.LoadFromJSON(JSON);
end;
``` 

#### Merge (Edit current record)
```pascal
const 
  JSON = '{"NAME":"Vinicius","COUNTRY":"United States"}';
begin
  qrySample.MergeFromJSONObject(JSON);
end;
``` 

#### Validate JSON

Scroll through all DataSet fields by checking the fields that are required. If the field is required and has not been entered in JSON, it is added in the Array.

```pascal
const 
  JSON_VALIDATE = '{"COUNTRY":"Brazil"}';
begin
  mmJSONArrayValidate.Lines.Text := mtJSON.ValidateJSON(JSON_VALIDATE).ToString;
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

###### The default language is English (TLanguageType.enUS);

## JSON Nested Object

Load JSON Nested Object in a simple way:
* `[Recommended]`: Implement the detail master (TDataSet native feature) and call the function to load or export JSON using the main query.
* `[Alternative]`: In the main dataset, create a field of type `TDataSetField` and binds the field created in the master dataset in the `DataSetField` property of the secondary dataset.

See the sample:

![dataset-serialize](img/Screenshot_3.png)

## Another samples

![dataset-serialize](img/Screenshot_2.png)

![dataset-serialize](img/Screenshot_1.png)
