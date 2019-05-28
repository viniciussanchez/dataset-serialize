unit DataSet.Serialize.JSON.Impl;

interface

uses DataSet.Serialize.JSON.Intf, System.JSON, Data.DB;

type
  TJSONSerialize = class(TInterfacedObject, IJSONSerialize)
  private
    FOwns: Boolean;
    FMerging: Boolean;
    FJSONObject: TJSONObject;
    FJSONArray: TJSONArray;
    /// <summary>
    ///   Clears the JSON pointer and destroys it if it's the owner.
    /// </summary>
    procedure ClearJSON;
    /// <summary>
    ///   Load a field of type blob with the value of a JSON.
    /// </summary>
    /// <param name="Field">
    ///   It refers to the field that you want to be loaded with the JSONValue.
    /// </param>
    /// <param name="JSONValue">
    ///   It refers to the value that is assigned to the field.
    /// </param>
    procedure LoadBlobFieldFromStream(const Field: TField; const JSONValue: TJSONValue);
    /// <summary>
    ///   Loads the fields of a DataSet based on a JSONArray.
    /// </summary>
    /// <param name="JSONArray">
    ///   JSONArray with the DataSet structure.
    /// </param>
    /// <param name="DataSet">
    ///   Refers to the DataSet that will be configured.
    /// </param>
    /// <remarks>
    ///   The DataSet can not have predefined fields.
    ///   The DataSet can not be active.
    ///   To convert a structure only JSONArray is allowed.
    /// </remarks>
    procedure JSONArrayToStructure(const JSONArray: TJSONArray; const DataSet: TDataSet);
    /// <summary>
    ///   Loads a DataSet with a JSONObject.
    /// </summary>
    /// <param name="JSON">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    /// <param name="DataSet">
    ///   Refers to the DataSet which must be loaded with the JSON data.
    /// </param>
    /// <param name="Merging">
    ///   Indicates whether to include or change the DataSet record.
    /// </param>
    /// <param name="Owns">
    ///   Indicates the owner of the DataSet.
    /// </param>
    procedure JSONObjectToDataSet(const JSON: TJSONObject; const DataSet: TDataSet; const Merging: Boolean; const Owns: Boolean);
    /// <summary>
    ///   Loads a DataSet with a JSONArray.
    /// </summary>
    /// <param name="JSON">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    /// <param name="DataSet">
    ///   Refers to the DataSet which must be loaded with the JSON data.
    /// </param>
    /// <param name="Owns">
    ///   Indicates the owner of the DataSet.
    /// </param>
    procedure JSONArrayToDataSet(const JSON: TJSONArray; const DataSet: TDataSet; const Owns: Boolean);
  protected
    /// <summary>
    ///   Loads fields from a DataSet based on JSON.
    /// </summary>
    /// <param name="DataSet">
    ///   Refers to the DataSet to which you want to load the structure.
    /// </param>
    procedure LoadStructure(const DataSet: TDataSet);
    /// <summary>
    ///   Runs the merge between the record of DataSet and JSONObject.
    /// </summary>
    /// <param name="DataSet">
    ///   Refers to the DataSet that you want to merge with the JSON object.
    /// </param>
    /// <param name="Owns">
    ///   Indicates the owner of the DataSet.
    /// </param>
    procedure Merge(const DataSet: TDataSet; const Owns: Boolean = False);
    /// <summary>
    ///   Loads the DataSet with JSON content.
    /// </summary>
    /// <param name="DataSet">
    ///   Refers to the DataSet you want to load.
    /// </param>
    /// <param name="Owns">
    ///   Indicates the owner of the DataSet.
    /// </param>
    procedure ToDataSet(const DataSet: TDataSet; const Owns: Boolean = False);
    /// <summary>
    ///   Defines what the JSONObject.
    /// </summary>
    /// <param name="JSONObject">
    ///   Refers to JSON itself.
    /// </param>
    /// <param name="Owns">
    ///   Indicates the owner of the JSON.
    /// </param>
    /// <returns>
    ///   Returns the implementation of IJSONSerialize interface.
    /// </returns>
    /// <remarks>
    ///   If it's the owner destroys the same of the memory when finalizing.
    /// </remarks>
    function SetJSONObject(const JSONObject: TJSONObject; const Owns: Boolean = False): IJSONSerialize;
    /// <summary>
    ///   Defines what the JSONArray.
    /// </summary>
    /// <param name="JSONObject">
    ///   Refers to JSON itself.
    /// </param>
    /// <param name="Owns">
    ///   Indicates the owner of the JSON.
    /// </param>
    /// <returns>
    ///   Returns the implementation of IJSONSerialize interface.
    /// </returns>
    /// <remarks>
    ///   If it's the owner destroys the same of the memory when finalizing.
    /// </remarks>
    function SetJSONArray(const JSONArray: TJSONArray; const Owns: Boolean = False): IJSONSerialize;
  public
    /// <summary>
    ///   Responsible for creating a new isntância of TDataSetSerialize class.
    /// </summary>
    constructor Create;
    /// <summary>
    ///   Creates a new instance of IJSONSerialize interface.
    /// </summary>
    /// <returns>
    ///   Returns an instance of IJSONSerialize interface.
    /// </returns>
    class function New: IJSONSerialize; static;
    /// <summary>
    ///   Responsible for destroying the TJSONSerialize class instance.
    /// </summary>
    /// <remarks>
    ///   If owner of the JSON, destroys the same.
    /// </remarks>
    destructor Destroy; override;
  end;

implementation

uses DataSetField.Types, System.Classes, System.SysUtils, System.NetEncoding, Providers.DataSet.Serialize, System.TypInfo,
  System.DateUtils, Providers.Constants;

{ TJSONSerialize }

procedure TJSONSerialize.JSONObjectToDataSet(const JSON: TJSONObject; const DataSet: TDataSet; const Merging: Boolean; const Owns: Boolean);
var
  Field: TField;
  JSONValue: TJSONValue;
  DataSetFieldType: TDataSetFieldType;
  NestedDataSet: TDataSet;
  BooleanValue: Boolean;
begin
  if (not Assigned(JSON)) or (not Assigned(DataSet)) then
    Exit;
  if not Owns then
  begin
    if Merging then
      DataSet.Edit
    else
      DataSet.Append;
  end;
  for Field in DataSet.Fields do
  begin
    if Field.ReadOnly then
      Continue;
    if not Assigned(JSON.Get(Field.FieldName)) then
      Continue;
    JSONValue := JSON.Get(Field.FieldName).JSONValue;
    if JSONValue is TJSONNull then
    begin
      Field.Clear;
      Continue;
    end;
    case Field.DataType of
      TFieldType.ftBoolean:
        if JSONValue.TryGetValue<Boolean>(BooleanValue) then
          Field.AsBoolean := BooleanValue;
      TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftShortint, TFieldType.ftLongWord:
        Field.AsInteger := StrToIntDef(JSONValue.Value, 0);
      TFieldType.ftLargeint, TFieldType.ftAutoInc:
        Field.AsLargeInt := StrToInt64Def(JSONValue.Value, 0);
      TFieldType.ftCurrency:
        Field.AsCurrency := StrToCurr(JSONValue.Value);
      TFieldType.ftFloat, TFieldType.ftFMTBcd, TFieldType.ftBCD, TFieldType.ftSingle:
        Field.AsFloat := StrToFloat(JSONValue.Value);
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo:
        Field.AsString := JSONValue.Value;
      TFieldType.ftDate, TFieldType.ftTimeStamp, TFieldType.ftDateTime, TFieldType.ftTime:
        Field.AsDateTime := ISO8601ToDate(JSONValue.Value);
      TFieldType.ftDataSet:
        begin
          DataSetFieldType := TDataSetSerializeUtils.DataSetFieldToType(TDataSetField(Field));
          NestedDataSet := TDataSetField(Field).NestedDataSet;
          case DataSetFieldType of
            dfJSONObject:
              JSONObjectToDataSet(JSONValue as TJSONObject, NestedDataSet, 0, True, Owns);
            dfJSONArray:
              begin
                NestedDataSet.First;
                while not NestedDataSet.Eof do
                  NestedDataSet.Delete;
                JSONArrayToDataSet(JSONValue as TJSONArray, NestedDataSet, Owns);
              end;
          end;
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
        LoadBlobFieldFromStream(Field, JSONValue);
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [Field.FieldName]);
    end;
  end;
  if not Owns then
    DataSet.Post;
end;

procedure TJSONSerialize.ToDataSet(const DataSet: TDataSet; const Owns: Boolean = False);
begin
  if Assigned(FJSONObject) then
    JSONObjectToDataSet(FJSONObject, DataSet, 0, FMerging, Owns)
  else if Assigned(FJSONArray) then
    JSONArrayToDataSet(FJSONArray, DataSet, Owns)
  else
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
end;

procedure TJSONSerialize.LoadBlobFieldFromStream(const Field: TField; const JSONValue: TJSONValue);
var
  StringStream: TStringStream;
  MemoryStream: TMemoryStream;
begin
  StringStream := TStringStream.Create((JSONValue as TJSONString).Value);
  try
    StringStream.Position := 0;
    MemoryStream := TMemoryStream.Create;
    try
      TNetEncoding.Base64.Decode(StringStream, MemoryStream);
      TBlobField(Field).LoadFromStream(MemoryStream);
    finally
      MemoryStream.Free;
    end;
  finally
    StringStream.Free;
  end;
end;

procedure TJSONSerialize.LoadStructure(const DataSet: TDataSet);
begin
  if Assigned(FJSONObject) then
    raise EDataSetSerializeException.Create(TO_CONVERT_STRUCTURE_ONLY_JSON_ARRAY_ALLOWED)
  else if Assigned(FJSONArray) then
    JSONArrayToStructure(FJSONArray, DataSet)
  else
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
end;

procedure TJSONSerialize.ClearJSON;
begin
  if FOwns then
  begin
    if Assigned(FJSONObject) then
      FJSONObject.Free;
    if Assigned(FJSONArray) then
      FJSONArray.Free;
  end;
  FJSONObject := nil;
  FJSONArray := nil;
end;

procedure TJSONSerialize.JSONArrayToDataSet(const JSON: TJSONArray; const DataSet: TDataSet; const Owns: Boolean);
var
  JSONValue: TJSONValue;
begin
  if (not Assigned(JSON)) or (not Assigned(DataSet)) then
    Exit;
  for JSONValue in JSON do
  begin
    if (JSONValue is TJSONArray) then
      JSONArrayToDataSet(JSONValue as TJSONArray, DataSet, Owns)
    else
      JSONObjectToDataSet(JSONValue as TJSONObject, DataSet, False, Owns);
  end;
end;

function TJSONSerialize.SetJSONObject(const JSONObject: TJSONObject; const Owns: Boolean = False): IJSONSerialize;
begin
  Result := Self;
  ClearJSON;
  FJSONObject := JSONObject;
  FOwns := Owns;
end;

function TJSONSerialize.SetJSONArray(const JSONArray: TJSONArray; const Owns: Boolean = False): IJSONSerialize;
begin
  Result := Self;
  ClearJSON;
  FJSONArray := JSONArray;
  FOwns := Owns;
end;

procedure TJSONSerialize.Merge(const DataSet: TDataSet; const Owns: Boolean = False);
begin
  FMerging := True;
  try
    ToDataSet(DataSet, Owns);
  finally
    FMerging := False;
  end;
end;

procedure TJSONSerialize.JSONArrayToStructure(const JSONArray: TJSONArray; const DataSet: TDataSet);
var
  JSONValue: TJSONValue;
begin
  if not Assigned(DataSet) then
    raise EDataSetSerializeException.Create(DATASET_NOT_DIFINED);
  if DataSet.Active then
    raise EDataSetSerializeException.Create(DATASET_ACTIVATED);
  if DataSet.FieldCount > 0 then
    raise EDataSetSerializeException.Create(PREDEFINED_FIELDS);
  for JSONValue in JSONArray do
  begin
    TDataSetSerializeUtils.NewDataSetField(DataSet,
      TFieldType(GetEnumValue(TypeInfo(TFieldType), JSONValue.GetValue<string>('DataType'))),
      JSONValue.GetValue<string>('FieldName'), StrToIntDef(TJSONObject(JSONValue).GetValue<string>('Size'), 0),
      JSONValue.GetValue<string>('Origin'), '', JSONValue.GetValue<Boolean>('Key'));
  end;
end;

class function TJSONSerialize.New: IJSONSerialize;
begin
  Result := TJSONSerialize.Create;
end;

constructor TJSONSerialize.Create;
begin
  FJSONObject := nil;
  FJSONArray := nil;
  FOwns := False;
  FMerging := False;
end;

destructor TJSONSerialize.Destroy;
begin
  ClearJSON;
  inherited Destroy;
end;

end.
