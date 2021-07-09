unit DataSet.Serialize.Import;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  DB, fpjson,
{$ELSE}
  System.JSON, Data.DB, System.StrUtils, System.SysUtils, System.Rtti,
{$ENDIF}
  DataSet.Serialize.Language, DataSet.Serialize.Utils;

type
  TJSONSerialize = class
  private
    FMerging: Boolean;
    FJSONObject: TJSONObject;
    FJSONArray: TJSONArray;
    FOwns: Boolean;
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
    procedure LoadBlobFieldFromStream(const AField: TField; const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF});
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
    /// <param name="ADetail">
    ///   Indicates if it's a dataset detail.
    /// </param>
    procedure JSONObjectToDataSet(const AJSONObject: TJSONObject; const ADataSet: TDataSet; const ADetail: Boolean);
    /// <summary>
    ///   Loads a DataSet with a JSONOValue.
    /// </summary>
    /// <param name="AJSONValue">
    ///   Refers to the JSON value that must be loaded in the DataSet.
    /// </param>
    /// <param name="ADataSet">
    ///   Refers to the DataSet which must be loaded with the JSON value.
    /// </param>
    procedure JSONValueToDataSet(const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF}; const ADataSet: TDataSet);
    /// <summary>
    ///   Loads a DataSet with a JSONArray.
    /// </summary>
    /// <param name="AJSONArray">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    /// <param name="ADataSet">
    ///   Refers to the DataSet which must be loaded with the JSON data.
    /// </param>
    procedure JSONArrayToDataSet(const AJSONArray: TJSONArray; const ADataSet: TDataSet; const ADetail: Boolean = False);
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
    function LoadFieldStructure(const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF}): TFieldStructure;
    /// <returns>
    ///   The key fields name of the ADataSet parameter.
    /// </returns>
    function GetKeyFieldsDataSet(const ADataSet: TDataSet): string;
    /// <returns>
    ///   The key values of the ADataSet parameter.
    /// </returns>
    function GetKeyValuesDataSet(const ADataSet: TDataSet; const AJSONObject: TJSONObject): TKeyValues;
    /// <summary>
    ///   Convert string in FieldName.
    /// </summary>
    function JSONPairToFieldName(const AValue: string): string;
    /// <summary>
    ///   Load the fields into the dataset.
    /// </summary>
    procedure LoadFieldsFromJSON(const ADataSet: TDataSet; const AJSONObject: TJSONObject);
  public
    /// <summary>
    ///   Responsible for creating a new instance of TDataSetSerialize class.
    /// </summary>
    /// <param name="AJSONArray">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    constructor Create(const AJSONArray: TJSONArray; const AOwns: Boolean); overload;
    /// <summary>
    ///   Responsible for creating a new instance of TDataSetSerialize class.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to the JSON in with the data that must be loaded in the DataSet.
    /// </param>
    constructor Create(const AJSONObject: TJSONObject; const AOwns: Boolean); overload;
    /// <summary>
    ///   Loads fields from a DataSet based on JSON.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet to which you want to load the structure.
    /// </param>
    procedure LoadStructure(const ADataSet: TDataSet);
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
    ///   Responsible for destroying the TJSONSerialize class instance.
    /// </summary>
    /// <remarks>
    ///   If owner of the JSON, destroys the same.
    /// </remarks>
    destructor Destroy; override;
  end;

implementation

uses
{$IF DEFINED(FPC)}
  Classes, Variants, SysUtils, DateUtils, TypInfo, base64,
{$ELSE}
  System.Classes, System.NetEncoding, System.TypInfo, System.DateUtils, System.Generics.Collections,
  System.Variants, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
{$ENDIF}
  DataSet.Serialize.Consts, DataSet.Serialize.Config, DataSet.Serialize.UpdatedStatus;

{ TJSONSerialize }

procedure TJSONSerialize.JSONObjectToDataSet(const AJSONObject: TJSONObject; const ADataSet: TDataSet; const ADetail: Boolean);
var
  LField: TField;
  LJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
  {$IF DEFINED(FPC)}
  I: Integer;
  {$ELSE}
  LNestedDataSet: TDataSet;
  LBooleanValue: Boolean;
  LDataSetDetails: TList<TDataSet>;
  LMasterSource: TDataSource;
  {$ENDIF}
  LObjectState: string;
  LFormatSettings: TFormatSettings;
begin
  if (not Assigned(AJSONObject)) or (not Assigned(ADataSet)) or (AJSONObject.Count = 0) then
    Exit;

  if not(ADataSet.Active) then
  begin
    {$IF NOT DEFINED(FPC)}
    if not(ADataSet is TFDMemTable)  then
      Exit;
    {$ENDIF}
    if ((ADataSet.FieldDefs.Count = 0) and (ADataSet.FieldCount = 0)) then
      LoadFieldsFromJSON(ADataSet, AJSONObject);
    ADataSet.Open;
  end;

  {$IF NOT DEFINED(FPC)}
  LMasterSource := nil;
  {$ENDIF}
  try
    {$IF DEFINED(FPC)}
    LObjectState := AJSONObject.Get('object_state', EmptyStr);
    if LObjectState.Trim.IsEmpty then
      LObjectState := AJSONObject.Get('objectState', EmptyStr);
    if not LObjectState.Trim.IsEmpty then
    begin
    {$ELSE}
    if AJSONObject.TryGetValue('object_state', LObjectState) or AJSONObject.TryGetValue('objectState', LObjectState) then
    begin
    {$ENDIF}
      if TUpdateStatus.usInserted.ToString = LObjectState then
      begin
        if ADataSet.State <> dsInsert then
          ADataSet.Append;
      end
      else if not (TUpdateStatus.usUnmodified.ToString = LObjectState) then
      begin
        {$IF NOT DEFINED(FPC)}
        if ADataSet.InheritsFrom(TFDDataSet) and Assigned(TFDDataSet(ADataSet).MasterSource) then
        begin
          LMasterSource := TFDDataSet(ADataSet).MasterSource;
          TFDDataSet(ADataSet).MasterSource := nil;
        end;
        {$ENDIF}
        if not ADataSet.Locate(GetKeyFieldsDataSet(ADataSet), VarArrayOf(GetKeyValuesDataSet(ADataSet, AJSONObject)), []) then
          Exit;
        if TUpdateStatus.usModified.ToString = LObjectState then
        begin
          if ADataSet.State <> dsEdit then
            ADataSet.Edit;
        end
        else if TUpdateStatus.usDeleted.ToString = LObjectState then
        begin
          ADataSet.Delete;
          Exit;
        end;
      end;
    end
    else if FMerging then
    begin
      if ADataSet.State <> dsEdit then
      begin
        if ADetail then
        begin
          if ADataSet.Locate(GetKeyFieldsDataSet(ADataSet), VarArrayOf(GetKeyValuesDataSet(ADataSet, AJSONObject)), []) then
            ADataSet.Edit;
        end
        else
          ADataSet.Edit;
      end;
    end
    else
    begin
      if ADataSet.State <> dsInsert then
        ADataSet.Append;
    end;

    if (ADataSet.State in dsEditModes) then
    begin
      {$IF DEFINED(FPC)}
      for I := 0 to Pred(ADataSet.FieldCount) do
      begin
        LField := ADataSet.Fields[I];
      {$ELSE}
      for LField in ADataSet.Fields do
      begin
      {$ENDIF}
        if TDataSetSerializeConfig.GetInstance.Import.ImportOnlyFieldsVisible then
          if not(LField.Visible) then
            Continue;
        if LField.ReadOnly then
          Continue;
        {$IF DEFINED(FPC)}
        LJSONValue := AJSONObject.Find(TDataSetSerializeUtils.FormatCaseNameDefinition(LField.FieldName));
        if not Assigned(LJSONValue) then
          LJSONValue := AJSONObject.Find(LField.FieldName);
        if not Assigned(LJSONValue) then
          Continue;
        {$ELSE}
        if not (AJSONObject.TryGetValue(TDataSetSerializeUtils.FormatCaseNameDefinition(LField.FieldName), LJSONValue) or (AJSONObject.TryGetValue(LField.FieldName, LJSONValue))) then
          Continue;
        {$ENDIF}
        if LJSONValue is TJSONNull then
        begin
          LField.Clear;
          Continue;
        end;
        case LField.DataType of
          TFieldType.ftBoolean:
            begin
              {$IF DEFINED(FPC)}
              LField.AsBoolean := LJSONValue.AsBoolean;
              {$ELSE}
              if LJSONValue.TryGetValue<Boolean>(LBooleanValue) then
                LField.AsBoolean := LBooleanValue;
              {$ENDIF}
            end;
          TFieldType.ftInteger, TFieldType.ftSmallint{$IF NOT DEFINED(FPC)}, TFieldType.ftShortint, TFieldType.ftLongWord{$ENDIF}:
            LField.AsInteger := StrToIntDef(LJSONValue.Value, 0);
          TFieldType.ftLargeint, TFieldType.ftAutoInc:
            LField.AsLargeInt := StrToInt64Def(LJSONValue.Value, 0);
          TFieldType.ftCurrency:
            LField.AsCurrency := StrToCurr(LJSONValue.Value);
          TFieldType.ftFloat, TFieldType.ftFMTBcd, TFieldType.ftBCD{$IF NOT DEFINED(FPC)}, TFieldType.ftSingle{$ENDIF}:
            LField.AsFloat := StrToFloat(LJSONValue.Value);
          TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo, TFieldType.ftGuid, TFieldType.ftFixedChar, TFieldType.ftFixedWideChar:
            LField.AsString := LJSONValue.Value;
          TFieldType.ftDate:
             LField.AsDateTime := DateOf(ISO8601ToDate(LJSONValue.Value, TDataSetSerializeConfig.GetInstance.DateInputIsUTC));
          TFieldType.ftTimeStamp, TFieldType.ftDateTime:
             LField.AsDateTime := ISO8601ToDate(LJSONValue.Value, TDataSetSerializeConfig.GetInstance.DateInputIsUTC);
          TFieldType.ftTime:
          begin
             LFormatSettings.TimeSeparator := ':';
             LFormatSettings.DecimalSeparator := '.';
             LFormatSettings.ShortTimeFormat := 'hh:mm:ss.zzz';
             LField.AsDateTime := StrToTime(LJSONValue.Value, LFormatSettings);
          end;
          {$IF NOT DEFINED(FPC)}
          TFieldType.ftDataSet:
            begin
              LNestedDataSet := TDataSetField(LField).NestedDataSet;
              if LJSONValue is TJSONObject then
                JSONObjectToDataSet(LJSONValue as TJSONObject, LNestedDataSet, True)
              else if LJSONValue is TJSONArray then
              begin
                ClearDataSet(LNestedDataSet);
                JSONArrayToDataSet(LJSONValue as TJSONArray, LNestedDataSet);
              end;
            end;
          {$ENDIF}
          TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftOraBlob{$IF NOT DEFINED(FPC)}, TFieldType.ftStream{$ENDIF}:
            LoadBlobFieldFromStream(LField, LJSONValue);
          else
            raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LField.FieldName]);
        end;
      end;
      ADataSet.Post;
    end;
  finally
    {$IF NOT DEFINED(FPC)}
    if Assigned(LMasterSource) then
      TFDDataSet(ADataSet).MasterSource := LMasterSource;
    {$ENDIF}
  end;
  {$IF NOT DEFINED(FPC)}
  LDataSetDetails := TList<TDataSet>.Create;
  try
    ADataSet.GetDetailDataSets(LDataSetDetails);
    for LNestedDataSet in LDataSetDetails do
    begin
      if not AJSONObject.TryGetValue(TDataSetSerializeUtils.FormatDataSetName(LNestedDataSet.Name), LJSONValue) then
        Continue;
      if LJSONValue is TJSONNull then
        Continue;
      if TUpdateStatus.usUnmodified.ToString = LObjectState then
        if not ADataSet.Locate(GetKeyFieldsDataSet(ADataSet), VarArrayOf(GetKeyValuesDataSet(ADataSet, AJSONObject)), []) then
          Continue;
      if LJSONValue is TJSONObject then
        JSONObjectToDataSet(LJSONValue as TJSONObject, LNestedDataSet, True)
      else if LJSONValue is TJSONArray then
        JSONArrayToDataSet(LJSONValue as TJSONArray, LNestedDataSet, True);
    end;
  finally
    LDataSetDetails.Free;
  end;
  {$ENDIF}
end;

function TJSONSerialize.JSONPairToFieldName(const AValue: string): string;
var
  I: Integer;
  LFieldName: string;
begin
  Result := AValue;
  if TDataSetSerializeConfig.GetInstance.CaseNameDefinition = cndLowerCamelCase then
  begin
    LFieldName := EmptyStr;
    {$IFDEF ANDROID}
    for I := 0 to Pred(Length(Result)) do
    {$ELSE}
    for I := 1 to Length(Result) do
    {$ENDIF}
    begin
      if CharInSet(Result[I], ['A'..'Z']) and CharInSet(Result[Pred(I)], ['a'..'z']) then
        LFieldName := LFieldName + '_';
      LFieldName := LFieldName + Result[I];
    end;
    Result := LFieldName.ToUpper;
  end;
end;

procedure TJSONSerialize.JSONValueToDataSet(const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF}; const ADataSet: TDataSet);
begin
  if ADataSet.Fields.Count <> 1 then
    raise EDataSetSerializeException.Create(Format(INVALID_FIELD_COUNT, [ADataSet.Name]));
  if not ADataSet.Active then
    ADataSet.Open;
  ADataSet.Append;
  ADataSet.Fields.Fields[0].AsString := AJSONValue.Value;
  ADataSet.Post;
end;

procedure TJSONSerialize.ToDataSet(const ADataSet: TDataSet);
begin
  if Assigned(FJSONObject) then
    JSONObjectToDataSet(FJSONObject, ADataSet, False)
  else if Assigned(FJSONArray) then
    JSONArrayToDataSet(FJSONArray, ADataSet)
  else
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
end;

function TJSONSerialize.Validate(const ADataSet: TDataSet; const ALang: TLanguageType = enUS): TJSONArray;
var
  LField: TField;
  LFieldName, LJSONValue: string;
begin
  if not Assigned(FJSONObject) then
    raise EDataSetSerializeException.Create(JSON_NOT_DIFINED);
  if ADataSet.Fields.Count = 0 then
    raise EDataSetSerializeException.Create(DATASET_HAS_NO_DEFINED_FIELDS);
  Result := TJSONArray.Create();
  for LField in ADataSet.Fields do
    if LField.Required then
    begin
      LFieldName := TDataSetSerializeUtils.FormatCaseNameDefinition(LField.FieldName);
      {$IF DEFINED(FPC)}
      LJSONValue := FJSONObject.Get(LFieldName, EmptyStr);
      if LJSONValue.Trim.Equals(EmptyStr) then
      {$ELSE}
      if FJSONObject.TryGetValue(LFieldName, LJSONValue) then
      {$ENDIF}
      begin
        if LJSONValue.Trim.IsEmpty then
        begin
          {$IF DEFINED(FPC)}
          Result.Add(AddFieldNotFound(LFieldName, LField.DisplayLabel, ALang));
          {$ELSE}
          Result.AddElement(AddFieldNotFound(LFieldName, LField.DisplayLabel, ALang));
          {$ENDIF}
        end;
      end
      else if LField.IsNull then
      begin
        {$IF DEFINED(FPC)}
        Result.Add(AddFieldNotFound(LFieldName, LField.DisplayLabel, ALang));
        {$ELSE}
        Result.AddElement(AddFieldNotFound(LFieldName, LField.DisplayLabel, ALang));
        {$ENDIF}
      end;
    end;
end;

procedure TJSONSerialize.LoadBlobFieldFromStream(const AField: TField; const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF});
var
  LStringStream: TStringStream;
  {$IF NOT DEFINED(FPC)}
  LMemoryStream: TMemoryStream;
  {$ENDIF}
begin
  LStringStream := TStringStream.Create((AJSONValue as TJSONString).Value);
  try
    LStringStream.Position := 0;
    {$IF DEFINED(FPC)}
    TBlobField(AField).AsString := DecodeStringBase64(LStringStream.DataString);
    {$ELSE}
    LMemoryStream := TMemoryStream.Create;
    try
      TNetEncoding.Base64.Decode(LStringStream, LMemoryStream);
      LMemoryStream.Position := 0;
      TBlobField(AField).LoadFromStream(LMemoryStream);
    finally
      LMemoryStream.Free;
    end;
    {$ENDIF}
  finally
    LStringStream.Free;
  end;
end;

procedure TJSONSerialize.LoadFieldsFromJSON(const ADataSet: TDataSet; const AJSONObject: TJSONObject);
var
  {$IF DEFINED(FPC)}
  I: Integer;
  {$ELSE}
  LJSONPair: TJSONPair;
  {$ENDIF}
begin
  {$IF DEFINED(FPC)}
  for I := 0 to Pred(AJSONObject.Count) do
  {$ELSE}
  for LJSONPair in AJSONObject do
  {$ENDIF}
  begin
    with ADataSet.FieldDefs.AddFieldDef do
    begin
      Name := JSONPairToFieldName({$IF DEFINED(FPC)}AJSONObject.Names[I]{$ELSE}LJSONPair.JsonString.Value{$ENDIF});
      DataType := TDataSetSerializeUtils.GetDataType({$IF DEFINED(FPC)}AJSONObject.Items[I]{$ELSE}LJSONPair.JsonValue{$ENDIF});
      if DataType = ftString then
      begin
        if Length({$IF DEFINED(FPC)}AJSONObject.Items[I].AsString{$ELSE}LJSONPair.JsonValue.Value{$ENDIF}) > 4096 then
        begin
          DataType := ftBlob;
          Size := Length({$IF DEFINED(FPC)}AJSONObject.Items[I].AsString{$ELSE}LJSONPair.JsonValue.Value{$ENDIF});
        end
        else
          Size := 4096;
      end;
    end;
  end;
end;

function TJSONSerialize.LoadFieldStructure(const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF}): TFieldStructure;
var
  LStrTemp: string;
  LIntTemp: Integer;
  LBoolTemp: Boolean;
begin
{$IF NOT DEFINED(FPC)}
  if AJSONValue.TryGetValue<string>(FIELD_PROPERTY_DATA_TYPE, LStrTemp) then
    Result.FieldType := TFieldType(GetEnumValue(TypeInfo(TFieldType), LStrTemp))
  else
    raise EDataSetSerializeException.CreateFmt('Attribute %s not found in json!', [FIELD_PROPERTY_DATA_TYPE]);

  if AJSONValue.TryGetValue<string>(FIELD_PROPERTY_ALIGNMENT, LStrTemp) then
    Result.Alignment := TRttiEnumerationType.GetValue<TAlignment>(LStrTemp);

  if AJSONValue.TryGetValue<string>(FIELD_PROPERTY_FIELD_NAME, LStrTemp) then
    Result.FieldName := LStrTemp
  else
    raise EDataSetSerializeException.CreateFmt('Attribute %s not found in json!', [FIELD_PROPERTY_FIELD_NAME]);

  if AJSONValue.TryGetValue<Integer>(FIELD_PROPERTY_SIZE, LIntTemp) then
    Result.Size := LIntTemp;

  if AJSONValue.TryGetValue<string>(FIELD_PROPERTY_ORIGIN, LStrTemp) then
    Result.Origin := LStrTemp;

  if AJSONValue.TryGetValue<string>(FIELD_PROPERTY_DISPLAY_LABEL, LStrTemp) then
    Result.DisplayLabel := LStrTemp;

  if AJSONValue.TryGetValue<Boolean>(FIELD_PROPERTY_KEY, LBoolTemp) then
    Result.Key := LBoolTemp;

  if AJSONValue.TryGetValue<Boolean>(FIELD_PROPERTY_REQUIRED, LBoolTemp) then
    Result.Required := LBoolTemp;

  if AJSONValue.TryGetValue<Boolean>(FIELD_PROPERTY_VISIBLE, LBoolTemp) then
    Result.Visible := LBoolTemp;

  if AJSONValue.TryGetValue<Boolean>(FIELD_PROPERTY_READ_ONLY, LBoolTemp) then
    Result.ReadOnly := LBoolTemp;

  if AJSONValue.TryGetValue<string>(FIELD_PROPERTY_AUTO_GENERATE_VALUE, LStrTemp) then
    Result.AutoGenerateValue := TAutoRefreshFlag(GetEnumValue(TypeInfo(TAutoRefreshFlag), LStrTemp));
{$ENDIF}
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
var
  LError: string;
begin
  Result := TJSONObject.Create;
  {$IF DEFINED(FPC)}
  Result.Add('field', AFieldName);
  {$ELSE}
  Result.AddPair(TJSONPair.Create('field', AFieldName));
  {$ENDIF}
  case ALang of
    ptBR:
      begin
        LError := ADisplayLabel + ' não foi informado(a)';
        {$IF DEFINED(FPC)}
        Result.Add('error', LError);
        {$ELSE}
        Result.AddPair(TJSONPair.Create('error', LError));
        {$ENDIF}
      end
    else
      begin
        LError := ADisplayLabel + ' not informed';
        {$IF DEFINED(FPC)}
        Result.Add('error', LError);
        {$ELSE}
        Result.AddPair(TJSONPair.Create('error', LError));
        {$ENDIF}
      end;
  end;
end;

procedure TJSONSerialize.ClearDataSet(const ADataSet: TDataSet);
begin
  ADataSet.First;
  while not ADataSet.Eof do
    ADataSet.Delete;
end;

constructor TJSONSerialize.Create(const AJSONObject: TJSONObject; const AOwns: Boolean);
begin
  FOwns := AOwns;
  FJSONObject := AJSONObject;
end;

constructor TJSONSerialize.Create(const AJSONArray: TJSONArray; const AOwns: Boolean);
begin
  FOwns := AOwns;
  FJSONArray := AJSONArray;
end;

procedure TJSONSerialize.JSONArrayToDataSet(const AJSONArray: TJSONArray; const ADataSet: TDataSet; const ADetail: Boolean = False);
var
  I: Integer;
begin
  if (not Assigned(AJSONArray)) or (not Assigned(ADataSet)) then
    Exit;
  for I := 0 to Pred(AJSONArray.Count) do
  begin
    if (AJSONArray.Items[I] is TJSONArray) then
      JSONArrayToDataSet(AJSONArray.Items[I] as TJSONArray, ADataSet, ADetail)
    else if (AJSONArray.Items[I] is TJSONObject) then
      JSONObjectToDataSet(AJSONArray.Items[I] as TJSONObject, ADataSet, ADetail)
    else
      JSONValueToDataSet(AJSONArray.Items[I], ADataSet);
  end;
  if ADataSet.Active then
    ADataSet.First;
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
  I: Integer;
begin
  if ADataSet.Active then
    raise EDataSetSerializeException.Create(DATASET_ACTIVATED);
  if ADataSet.FieldCount > 0 then
    raise EDataSetSerializeException.Create(PREDEFINED_FIELDS);
  for I := 0 to Pred(AJSONArray.Count) do
    TDataSetSerializeUtils.NewDataSetField(ADataSet, LoadFieldStructure(AJSONArray.Items[I]));
end;

destructor TJSONSerialize.Destroy;
begin
  if Assigned(FJSONObject) and FOwns then
    FJSONObject.Free;
  if Assigned(FJSONArray) and FOwns then
    FJSONArray.Free;
  FJSONObject := nil;
  FJSONArray := nil;
  inherited Destroy;
end;

function TJSONSerialize.GetKeyFieldsDataSet(const ADataSet: TDataSet): string;
var
  LField: TField;
begin
  Result := EmptyStr;
  for LField in ADataSet.Fields do
    if pfInKey in LField.ProviderFlags then
    begin
      if Result.Trim.IsEmpty then
        Result := Result + LField.FieldName
      else
        Result := Result + ';' + LField.FieldName;
    end;
end;

function TJSONSerialize.GetKeyValuesDataSet(const ADataSet: TDataSet; const AJSONObject: TJSONObject): TKeyValues;
var
  LField: TField;
  LKeyValue: string;
begin
  for LField in ADataSet.Fields do
    if pfInKey in LField.ProviderFlags then
    begin
      if TDataSetSerializeConfig.GetInstance.CaseNameDefinition = cndLowerCamelCase then
      begin
        {$IF DEFINED(FPC)}
        LKeyValue := AJSONObject.Get(TDataSetSerializeUtils.FormatCaseNameDefinition(LField.FieldName), EmptyStr);
        if LKeyValue.Trim.IsEmpty then
        {$ELSE}
        if not AJSONObject.TryGetValue(TDataSetSerializeUtils.FormatCaseNameDefinition(LField.FieldName), LKeyValue) then
        {$ENDIF}
          Continue;
      end
      else
      begin
        {$IF DEFINED(FPC)}
        LKeyValue := AJSONObject.Get(LowerCase(LField.FieldName), EmptyStr);
        if LKeyValue.Trim.IsEmpty then
          Continue;
        LKeyValue := AJSONObject.Get(LField.FieldName, EmptyStr);
        if LKeyValue.Trim.IsEmpty then
        {$ELSE}
        if not (AJSONObject.TryGetValue(LowerCase(LField.FieldName), LKeyValue) or AJSONObject.TryGetValue(LField.FieldName, LKeyValue)) then
        {$ENDIF}
          Continue;
      end;
      SetLength(Result, Length(Result) + 1);
      Result[Pred(Length(Result))] := LKeyValue;
    end;
end;

end.
