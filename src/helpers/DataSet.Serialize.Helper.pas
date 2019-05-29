unit DataSet.Serialize.Helper;

interface

uses System.JSON, Data.DB, Language.Types;

type
  TDataSetSerializeHelper = class Helper for TDataSet
  public
    /// <summary>
    ///   Creates a JSON object with the data from the current record of DataSet.
    /// </summary>
    /// <returns>
    ///   Returns a JSON object containing the record data.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function ToJSONObject: TJSONObject;
    /// <summary>
    ///   Creates an array of JSON objects with all DataSet records.
    /// </summary>
    /// <returns>
    ///   Returns a JSONArray with all records from the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function ToJSONArray: TJSONArray;
    /// <summary>
    ///   Responsible for exporting the structure of a DataSet in JSON Array format.
    /// </summary>
    /// <returns>
    ///   Returns a JSON array with all fields of the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function SaveStructure: TJSONArray;
    /// <summary>
    ///   Loads fields from a DataSet based on a JSONArray.
    /// </summary>
    /// <param name="JSONArray">
    ///   Refers to JSON with field specifications.
    /// </param>
    procedure LoadStructure(const JSONArray: TJSONArray);
    /// <summary>
    ///   Loads the DataSet with data from a JSON object.
    /// </summary>
    /// <param name="JSONObject">
    ///   Refers to JSON that you want to load.
    /// </param>
    /// <remarks>
    ///   Only the keys that make up the DataSet field list will be loaded. The JSON keys must have the same name as the
    ///   DataSet fields. It's not case-sensitive.
    /// </remarks>
    procedure LoadFromJSONObject(const JSONObject: TJSONObject);
    /// <summary>
    ///   Loads the DataSet with data from a JSON array.
    /// </summary>
    /// <param name="JSONArray">
    ///   Refers to JSON that you want to load.
    /// </param>
    /// <remarks>
    ///   Only the keys that make up the DataSet field list will be loaded. The JSON keys must have the same name as the
    ///   DataSet fields. It's not case-sensitive.
    /// </remarks>
    procedure LoadFromJSONArray(const JSONArray: TJSONArray);
    /// <summary>
    ///   Updates the DataSet data with JSON object data.
    /// </summary>
    /// <param name="JSONObject">
    ///   Refers to JSON that you want to merge.
    /// </param>
    procedure MergeFromJSONObject(const JSONObject: TJSONObject);
    /// <summary>
    ///   Responsible for validating whether JSON has all the necessary information for a particular DataSet.
    /// </summary>
    /// <param name="JSONObject">
    ///   Refers to JSON that must be validated.
    /// </param>
    /// <param name="Lang">
    ///   Language used to mount messages.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with the fields that were not informed.
    /// </returns>
    /// <remarks>
    ///   Walk the DataSet fields by checking the required property.
    ///   Uses the DisplayLabel property to mount the message.
    /// </remarks>
    function ValidateJSON(const JSONObject: TJSONObject; const Lang: TLanguageType = enUS): TJSONArray;
  end;

implementation

uses DataSet.Serialize.Impl;

function TDataSetSerializeHelper.ToJSONArray: TJSONArray;
begin
  Result := TSerialize.New.SetDataSet(Self).ToJSONArray;
end;

function TDataSetSerializeHelper.ToJSONObject: TJSONObject;
begin
  Result := TSerialize.New.SetDataSet(Self).ToJSONObject;
end;

function TDataSetSerializeHelper.ValidateJSON(const JSONObject: TJSONObject; const Lang: TLanguageType = enUS): TJSONArray;
begin
  Result := TSerialize.New.SetJSONObject(JSONObject).Validate(Self, Lang);
end;

function TDataSetSerializeHelper.SaveStructure: TJSONArray;
begin
  Result := TSerialize.New.SetDataSet(Self).SaveStructure;
end;

procedure TDataSetSerializeHelper.LoadFromJSONArray(const JSONArray: TJSONArray);
begin
  TSerialize.New.SetJSONArray(JSONArray).ToDataSet(Self);
end;

procedure TDataSetSerializeHelper.LoadFromJSONObject(const JSONObject: TJSONObject);
begin
  TSerialize.New.SetJSONObject(JSONObject).ToDataSet(Self);
end;

procedure TDataSetSerializeHelper.LoadStructure(const JSONArray: TJSONArray);
begin
  TSerialize.New.SetJSONArray(JSONArray).LoadStructure(Self);
end;

procedure TDataSetSerializeHelper.MergeFromJSONObject(const JSONObject: TJSONObject);
begin
  TSerialize.New.SetJSONObject(JSONObject).Merge(Self);
end;

end.
