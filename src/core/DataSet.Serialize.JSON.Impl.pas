unit DataSet.Serialize.JSON.Impl;

interface

uses DataSet.Serialize.JSON.Intf, System.JSON, Data.DB, Language.Types, Providers.DataSet.Serialize;

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
    procedure JSONObjectToDataSet(const JSON: TJSONObject; const DataSet: TDataSet; const Merging: Boolean);
    /// <summary>
    ///   Loads a DataSet with a JSONArray.
    /// </summary>
    /// <param name="JSON">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    /// <param name="DataSet">
    ///   Refers to the DataSet which must be loaded with the JSON data.
    /// </param>
    procedure JSONArrayToDataSet(const JSON: TJSONArray; const DataSet: TDataSet);
    /// <summary>
    ///   Creates a JSON informing the required field.
    /// </summary>
    /// <param name="FieldName">
    ///   Field name in the DataSet.
    /// </param>
    /// <param name="DisplayLabel">
    ///   Formatted field name.
    /// </param>
    /// <param name="Lang">
    ///   Language used to mount messages.
    /// </param>
    /// <returns>
    ///   Returns a JSON with the message and field name.
    /// </returns>
    function AddFieldNotFound(const FieldName, DisplayLabel: string; const Lang: TLanguageType = enUS): TJSONObject;
    /// <summary>
    ///   Load field structure.
    /// </summary>
    /// <param name="JSONValue">
    ///   JSON with field data.
    /// </param>
    /// <returns>
    ///   Record of field structure.
    /// </returns>
    function LoadFieldStructure(const JSONValue: TJSONValue): TFieldStructure;
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
    procedure Merge(const DataSet: TDataSet);
    /// <summary>
    ///   Loads the DataSet with JSON content.
    /// </summary>
    /// <param name="DataSet">
    ///   Refers to the DataSet you want to load.
    /// </param>
    procedure ToDataSet(const DataSet: TDataSet);
    /// <summary>
    ///   Responsible for validating whether JSON has all the necessary information for a particular DataSet.
    /// </summary>
    /// <param name="DataSet">
    ///   Refers to the DataSet that will be loaded with JSON.
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
    function Validate(const DataSet: TDataSet; const Lang: TLanguageType = enUS): TJSONArray;
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

uses System.Classes, System.SysUtils, System.NetEncoding, System.TypInfo, System.DateUtils, Providers.DataSet.Serialize.Constants;

{ TJSONSerialize }

procedure TJSONSerialize.JSONObjectToDataSet(const JSON: TJSONObject; const DataSet: TDataSet; const Merging: Boolean);
var
  LField: TField;
  LJSONValue: TJSONValue;
  LNestedDataSet: TDataSet;
  LBooleanValue: Boolean;
begin
  if (not Assigned(JSON)) or (not Assigned(DataSet)) then
    Exit;
  if Merging then
    DataSet.Edit
  else
    DataSet.Append;
  for LField in DataSet.Fields do
  begin
    if LField.ReadOnly then
      Continue;

    if not (JSON.TryGetValue(LField.FieldName, LJSONValue) or JSON.TryGetValue(LowerCase(LField.FieldName), LJSONValue)) then
      Continue;

    if LJSONValue is TJSONNull then
    begin
      LField.Clear;
      Continue;
    end;
    case LField.DataType of
      TFieldType.ftBoolean:
        if LJSONValue.TryGetValue<Boolean>(LBooleanValue) then
          LField.AsBoolean := LBooleanValue;
      TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftShortint, TFieldType.ftLongWord:
        LField.AsInteger := StrToIntDef(LJSONValue.Value, 0);
      TFieldType.ftLargeint, TFieldType.ftAutoInc:
        LField.AsLargeInt := StrToInt64Def(LJSONValue.Value, 0);
      TFieldType.ftCurrency:
        LField.AsCurrency := StrToCurr(LJSONValue.Value);
      TFieldType.ftFloat, TFieldType.ftFMTBcd, TFieldType.ftBCD, TFieldType.ftSingle:
        LField.AsFloat := StrToFloat(LJSONValue.Value);
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo:
        LField.AsString := LJSONValue.Value;
      TFieldType.ftDate, TFieldType.ftTimeStamp, TFieldType.ftDateTime, TFieldType.ftTime:
        LField.AsDateTime := ISO8601ToDate(LJSONValue.Value);
      TFieldType.ftDataSet:
        begin
          LNestedDataSet := TDataSetField(LField).NestedDataSet;
          if LJSONValue is TJSONObject then
            JSONObjectToDataSet(LJSONValue as TJSONObject, LNestedDataSet, False)
          else if LJSONValue is TJSONArray then
          begin
            LNestedDataSet.First;
            while not LNestedDataSet.Eof do
              LNestedDataSet.Delete;
            JSONArrayToDataSet(LJSONValue as TJSONArray, LNestedDataSet);
          end;
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
        LoadBlobFieldFromStream(LField, LJSONValue);
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LField.FieldName]);
    end;
  end;
  DataSet.Post;
end;

procedure TJSONSerialize.ToDataSet(const DataSet: TDataSet);
begin
  if Assigned(FJSONObject) then
    JSONObjectToDataSet(FJSONObject, DataSet, FMerging)
  else if Assigned(FJSONArray) then
    JSONArrayToDataSet(FJSONArray, DataSet)
  else
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
end;

function TJSONSerialize.Validate(const DataSet: TDataSet; const Lang: TLanguageType = enUS): TJSONArray;
var
  I: Integer;
  LJSONValue: string;
begin
  if not Assigned(FJSONObject) then
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
  if not Assigned(DataSet) then
    raise EDataSetSerializeException.Create(DATASET_NOT_CREATED);
  if DataSet.Fields.Count = 0 then
    raise EDataSetSerializeException.Create(DATASET_HAS_NO_DEFINED_FIELDS);
  Result := TJSONArray.Create();
  for I := 0 to Pred(DataSet.Fields.Count) do
    if DataSet.Fields.Fields[I].Required then
    begin
      if FJSONObject.TryGetValue(DataSet.Fields.Fields[I].FieldName, LJSONValue) then
      begin
        if LJSONValue.Trim.IsEmpty then
          Result.AddElement(AddFieldNotFound(DataSet.Fields.Fields[I].FieldName, DataSet.Fields.Fields[I].DisplayLabel, Lang));
      end
      else
        Result.AddElement(AddFieldNotFound(DataSet.Fields.Fields[I].FieldName, DataSet.Fields.Fields[I].DisplayLabel, Lang));
    end;
end;

procedure TJSONSerialize.LoadBlobFieldFromStream(const Field: TField; const JSONValue: TJSONValue);
var
  LStringStream: TStringStream;
  LMemoryStream: TMemoryStream;
begin
  LStringStream := TStringStream.Create((JSONValue as TJSONString).Value);
  try
    LStringStream.Position := 0;
    LMemoryStream := TMemoryStream.Create;
    try
      TNetEncoding.Base64.Decode(LStringStream, LMemoryStream);
      TBlobField(Field).LoadFromStream(LMemoryStream);
    finally
      LMemoryStream.Free;
    end;
  finally
    LStringStream.Free;
  end;
end;

function TJSONSerialize.LoadFieldStructure(const JSONValue: TJSONValue): TFieldStructure;
begin
  Result.FieldType := TFieldType(GetEnumValue(TypeInfo(TFieldType), JSONValue.GetValue<string>('DataType')));
  Result.Size := StrToIntDef(TJSONObject(JSONValue).GetValue<string>('Size'), 0);
  Result.FieldName := JSONValue.GetValue<string>('FieldName');
  Result.Origin := JSONValue.GetValue<string>('Origin');
  Result.DisplayLabel := JSONValue.GetValue<string>('DisplayLabel');
  Result.Key := JSONValue.GetValue<Boolean>('Key');
  Result.Required := JSONValue.GetValue<Boolean>('Required');
  Result.Visible := JSONValue.GetValue<Boolean>('Visible');
  Result.ReadOnly := JSONValue.GetValue<Boolean>('ReadOnly');
  Result.AutoGenerateValue := TAutoRefreshFlag(GetEnumValue(TypeInfo(TAutoRefreshFlag), JSONValue.GetValue<string>('AutoGenerateValue')));
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

function TJSONSerialize.AddFieldNotFound(const FieldName, DisplayLabel: string; const Lang: TLanguageType = enUS): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair(TJSONPair.Create('field', FieldName));
  case Lang of
    ptBR:
      Result.AddPair(TJSONPair.Create('error', DisplayLabel + ' não foi informado(a)'));
    else
      Result.AddPair(TJSONPair.Create('error', DisplayLabel + ' not informed'));
  end;
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

procedure TJSONSerialize.JSONArrayToDataSet(const JSON: TJSONArray; const DataSet: TDataSet);
var
  LJSONValue: TJSONValue;
begin
  if (not Assigned(JSON)) or (not Assigned(DataSet)) then
    Exit;
  for LJSONValue in JSON do
  begin
    if (LJSONValue is TJSONArray) then
      JSONArrayToDataSet(LJSONValue as TJSONArray, DataSet)
    else
      JSONObjectToDataSet(LJSONValue as TJSONObject, DataSet, False);
  end;
  DataSet.First;
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

procedure TJSONSerialize.Merge(const DataSet: TDataSet);
begin
  FMerging := True;
  try
    ToDataSet(DataSet);
  finally
    FMerging := False;
  end;
end;

procedure TJSONSerialize.JSONArrayToStructure(const JSONArray: TJSONArray; const DataSet: TDataSet);
var
  LJSONValue: TJSONValue;
begin
  if not Assigned(DataSet) then
    raise EDataSetSerializeException.Create(DATASET_NOT_DIFINED);
  if DataSet.Active then
    raise EDataSetSerializeException.Create(DATASET_ACTIVATED);
  if DataSet.FieldCount > 0 then
    raise EDataSetSerializeException.Create(PREDEFINED_FIELDS);
  try
    for LJSONValue in JSONArray do
      TDataSetSerializeUtils.NewDataSetField(DataSet, LoadFieldStructure(LJSONValue));
  finally
    JSONArray.Free;
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
