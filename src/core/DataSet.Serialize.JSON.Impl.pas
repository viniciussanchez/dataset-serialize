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
    ///   Delete all records from dataset.
    /// </summary>
    /// <param name="ADataSet">
    ///   DataSet that will be cleared.
    /// </param>
    procedure ClearDataSet(const ADataSet: TDataSet);
    /// <summary>
    ///   Load a field of type blob with the value of a JSON.
    /// </summary>
    /// <param name="AField">
    ///   It refers to the field that you want to be loaded with the JSONValue.
    /// </param>
    /// <param name="AJSONValue">
    ///   It refers to the value that is assigned to the field.
    /// </param>
    procedure LoadBlobFieldFromStream(const AField: TField; const AJSONValue: TJSONValue);
    /// <summary>
    ///   Loads the fields of a DataSet based on a JSONArray.
    /// </summary>
    /// <param name="AJSONArray">
    ///   JSONArray with the DataSet structure.
    /// </param>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that will be configured.
    /// </param>
    /// <remarks>
    ///   The DataSet can not have predefined fields.
    ///   The DataSet can not be active.
    ///   To convert a structure only JSONArray is allowed.
    /// </remarks>
    procedure JSONArrayToStructure(const AJSONArray: TJSONArray; const ADataSet: TDataSet);
    /// <summary>
    ///   Loads a DataSet with a JSONObject.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    /// <param name="ADataSet">
    ///   Refers to the DataSet which must be loaded with the JSON data.
    /// </param>
    /// <param name="AMerging">
    ///   Indicates whether to include or change the DataSet record.
    /// </param>
    procedure JSONObjectToDataSet(const AJSONObject: TJSONObject; const ADataSet: TDataSet; const AMerging: Boolean);
    /// <summary>
    ///   Loads a DataSet with a JSONArray.
    /// </summary>
    /// <param name="AJSONArray">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    /// <param name="ADataSet">
    ///   Refers to the DataSet which must be loaded with the JSON data.
    /// </param>
    procedure JSONArrayToDataSet(const AJSONArray: TJSONArray; const ADataSet: TDataSet);
    /// <summary>
    ///   Creates a JSON informing the required field.
    /// </summary>
    /// <param name="AFieldName">
    ///   Field name in the DataSet.
    /// </param>
    /// <param name="ADisplayLabel">
    ///   Formatted field name.
    /// </param>
    /// <param name="ALang">
    ///   Language used to mount messages.
    /// </param>
    /// <returns>
    ///   Returns a JSON with the message and field name.
    /// </returns>
    function AddFieldNotFound(const AFieldName, ADisplayLabel: string; const ALang: TLanguageType = enUS): TJSONObject;
    /// <summary>
    ///   Load field structure.
    /// </summary>
    /// <param name="AJSONValue">
    ///   JSON with field data.
    /// </param>
    /// <returns>
    ///   Record of field structure.
    /// </returns>
    function LoadFieldStructure(const AJSONValue: TJSONValue): TFieldStructure;
  protected
    /// <summary>
    ///   Loads fields from a DataSet based on JSON.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet to which you want to load the structure.
    /// </param>
    procedure LoadStructure(const ADataSet: TDataSet);
    /// <summary>
    ///   Runs the merge between the record of DataSet and JSONObject.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that you want to merge with the JSON object.
    /// </param>
    procedure Merge(const ADataSet: TDataSet);
    /// <summary>
    ///   Loads the DataSet with JSON content.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet you want to load.
    /// </param>
    procedure ToDataSet(const ADataSet: TDataSet);
    /// <summary>
    ///   Responsible for validating whether JSON has all the necessary information for a particular DataSet.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that will be loaded with JSON.
    /// </param>
    /// <param name="ALang">
    ///   Language used to mount messages.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with the fields that were not informed.
    /// </returns>
    /// <remarks>
    ///   Walk the DataSet fields by checking the required property.
    ///   Uses the DisplayLabel property to mount the message.
    /// </remarks>
    function Validate(const ADataSet: TDataSet; const ALang: TLanguageType = enUS): TJSONArray;
    /// <summary>
    ///   Defines what the JSONObject.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to JSON itself.
    /// </param>
    /// <param name="AOwns">
    ///   Indicates the owner of the JSON.
    /// </param>
    /// <returns>
    ///   Returns the implementation of IJSONSerialize interface.
    /// </returns>
    /// <remarks>
    ///   If it's the owner destroys the same of the memory when finalizing.
    /// </remarks>
    function SetJSONObject(const AJSONObject: TJSONObject; const AOwns: Boolean = False): IJSONSerialize;
    /// <summary>
    ///   Defines what the JSONArray.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to JSON itself.
    /// </param>
    /// <param name="AOwns">
    ///   Indicates the owner of the JSON.
    /// </param>
    /// <returns>
    ///   Returns the implementation of IJSONSerialize interface.
    /// </returns>
    /// <remarks>
    ///   If it's the owner destroys the same of the memory when finalizing.
    /// </remarks>
    function SetJSONArray(const AJSONArray: TJSONArray; const AOwns: Boolean = False): IJSONSerialize;
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

uses System.Classes, System.SysUtils, System.NetEncoding, System.TypInfo, System.DateUtils, Providers.DataSet.Serialize.Constants,
  System.Generics.Collections;

{ TJSONSerialize }

procedure TJSONSerialize.JSONObjectToDataSet(const AJSONObject: TJSONObject; const ADataSet: TDataSet; const AMerging: Boolean);
var
  LField: TField;
  LJSONValue: TJSONValue;
  LNestedDataSet: TDataSet;
  LBooleanValue: Boolean;
  LDataSetDetails: TList<TDataSet>;
  I: Integer;
begin
  if (not Assigned(AJSONObject)) or (not Assigned(ADataSet)) then
    Exit;
  if AMerging then
    ADataSet.Edit
  else
    ADataSet.Append;
  for LField in ADataSet.Fields do
  begin
    if LField.ReadOnly then
      Continue;
    if not (AJSONObject.TryGetValue(LField.FieldName, LJSONValue) or AJSONObject.TryGetValue(LowerCase(LField.FieldName), LJSONValue)) then
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
            ClearDataSet(LNestedDataSet);
            JSONArrayToDataSet(LJSONValue as TJSONArray, LNestedDataSet);
          end;
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
        LoadBlobFieldFromStream(LField, LJSONValue);
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LField.FieldName]);
    end;
  end;
  LDataSetDetails := TList<TDataSet>.Create;
  try
    ADataSet.GetDetailDataSets(LDataSetDetails);
    for I := 0 to Pred(LDataSetDetails.Count) do
    begin
      if not AJSONObject.TryGetValue(LowerCase(LDataSetDetails.Items[I].Name), LJSONValue) then
        Continue;
      if LJSONValue is TJSONNull then
        Continue;
      if LJSONValue is TJSONObject then
        JSONObjectToDataSet(LJSONValue as TJSONObject, LDataSetDetails.Items[I], False)
      else if LJSONValue is TJSONArray then
      begin
        ClearDataSet(LDataSetDetails.Items[I]);
        JSONArrayToDataSet(LJSONValue as TJSONArray, LDataSetDetails.Items[I]);
      end;
    end;
  finally
    LDataSetDetails.Free;
  end;
  ADataSet.Post;
end;

procedure TJSONSerialize.ToDataSet(const ADataSet: TDataSet);
begin
  if Assigned(FJSONObject) then
    JSONObjectToDataSet(FJSONObject, ADataSet, FMerging)
  else if Assigned(FJSONArray) then
    JSONArrayToDataSet(FJSONArray, ADataSet)
  else
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
end;

function TJSONSerialize.Validate(const ADataSet: TDataSet; const ALang: TLanguageType = enUS): TJSONArray;
var
  I: Integer;
  LJSONValue: string;
begin
  if not Assigned(FJSONObject) then
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
  if not Assigned(ADataSet) then
    raise EDataSetSerializeException.Create(DATASET_NOT_CREATED);
  if ADataSet.Fields.Count = 0 then
    raise EDataSetSerializeException.Create(DATASET_HAS_NO_DEFINED_FIELDS);
  Result := TJSONArray.Create();
  for I := 0 to Pred(ADataSet.Fields.Count) do
    if ADataSet.Fields.Fields[I].Required then
    begin
      if FJSONObject.TryGetValue(ADataSet.Fields.Fields[I].FieldName, LJSONValue) then
      begin
        if LJSONValue.Trim.IsEmpty then
          Result.AddElement(AddFieldNotFound(ADataSet.Fields.Fields[I].FieldName, ADataSet.Fields.Fields[I].DisplayLabel, ALang));
      end
      else
        Result.AddElement(AddFieldNotFound(ADataSet.Fields.Fields[I].FieldName, ADataSet.Fields.Fields[I].DisplayLabel, ALang));
    end;
end;

procedure TJSONSerialize.LoadBlobFieldFromStream(const AField: TField; const AJSONValue: TJSONValue);
var
  LStringStream: TStringStream;
  LMemoryStream: TMemoryStream;
begin
  LStringStream := TStringStream.Create((AJSONValue as TJSONString).Value);
  try
    LStringStream.Position := 0;
    LMemoryStream := TMemoryStream.Create;
    try
      TNetEncoding.Base64.Decode(LStringStream, LMemoryStream);
      TBlobField(AField).LoadFromStream(LMemoryStream);
    finally
      LMemoryStream.Free;
    end;
  finally
    LStringStream.Free;
  end;
end;

function TJSONSerialize.LoadFieldStructure(const AJSONValue: TJSONValue): TFieldStructure;
begin
  Result.FieldType := TFieldType(GetEnumValue(TypeInfo(TFieldType), AJSONValue.GetValue<string>('DataType')));
  Result.Size := StrToIntDef(TJSONObject(AJSONValue).GetValue<string>('Size'), 0);
  Result.FieldName := AJSONValue.GetValue<string>('FieldName');
  Result.Origin := AJSONValue.GetValue<string>('Origin');
  Result.DisplayLabel := AJSONValue.GetValue<string>('DisplayLabel');
  Result.Key := AJSONValue.GetValue<Boolean>('Key');
  Result.Required := AJSONValue.GetValue<Boolean>('Required');
  Result.Visible := AJSONValue.GetValue<Boolean>('Visible');
  Result.ReadOnly := AJSONValue.GetValue<Boolean>('ReadOnly');
  Result.AutoGenerateValue := TAutoRefreshFlag(GetEnumValue(TypeInfo(TAutoRefreshFlag), AJSONValue.GetValue<string>('AutoGenerateValue')));
end;

procedure TJSONSerialize.LoadStructure(const ADataSet: TDataSet);
begin
  if Assigned(FJSONObject) then
    raise EDataSetSerializeException.Create(TO_CONVERT_STRUCTURE_ONLY_JSON_ARRAY_ALLOWED)
  else if Assigned(FJSONArray) then
    JSONArrayToStructure(FJSONArray, ADataSet)
  else
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
end;

function TJSONSerialize.AddFieldNotFound(const AFieldName, ADisplayLabel: string; const ALang: TLanguageType = enUS): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair(TJSONPair.Create('field', AFieldName));
  case ALang of
    ptBR:
      Result.AddPair(TJSONPair.Create('error', ADisplayLabel + ' não foi informado(a)'));
    else
      Result.AddPair(TJSONPair.Create('error', ADisplayLabel + ' not informed'));
  end;
end;

procedure TJSONSerialize.ClearDataSet(const ADataSet: TDataSet);
begin
  ADataSet.First;
  while not ADataSet.Eof do
    ADataSet.Delete;
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

procedure TJSONSerialize.JSONArrayToDataSet(const AJSONArray: TJSONArray; const ADataSet: TDataSet);
var
  LJSONValue: TJSONValue;
begin
  if (not Assigned(AJSONArray)) or (not Assigned(ADataSet)) then
    Exit;
  for LJSONValue in AJSONArray do
  begin
    if (LJSONValue is TJSONArray) then
      JSONArrayToDataSet(LJSONValue as TJSONArray, ADataSet)
    else
      JSONObjectToDataSet(LJSONValue as TJSONObject, ADataSet, False);
  end;
  ADataSet.First;
end;

function TJSONSerialize.SetJSONObject(const AJSONObject: TJSONObject; const AOwns: Boolean = False): IJSONSerialize;
begin
  Result := Self;
  ClearJSON;
  FJSONObject := AJSONObject;
  FOwns := AOwns;
end;

function TJSONSerialize.SetJSONArray(const AJSONArray: TJSONArray; const AOwns: Boolean = False): IJSONSerialize;
begin
  Result := Self;
  ClearJSON;
  FJSONArray := AJSONArray;
  FOwns := AOwns;
end;

procedure TJSONSerialize.Merge(const ADataSet: TDataSet);
begin
  FMerging := True;
  try
    ToDataSet(ADataSet);
  finally
    FMerging := False;
  end;
end;

procedure TJSONSerialize.JSONArrayToStructure(const AJSONArray: TJSONArray; const ADataSet: TDataSet);
var
  LJSONValue: TJSONValue;
begin
  if not Assigned(ADataSet) then
    raise EDataSetSerializeException.Create(DATASET_NOT_DIFINED);
  if ADataSet.Active then
    raise EDataSetSerializeException.Create(DATASET_ACTIVATED);
  if ADataSet.FieldCount > 0 then
    raise EDataSetSerializeException.Create(PREDEFINED_FIELDS);
  try
    for LJSONValue in AJSONArray do
      TDataSetSerializeUtils.NewDataSetField(ADataSet, LoadFieldStructure(LJSONValue));
  finally
    AJSONArray.Free;
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
