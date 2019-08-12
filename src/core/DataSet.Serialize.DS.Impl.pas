unit DataSet.Serialize.DS.Impl;

interface

uses Data.DB, System.JSON;

type
  TDataSetSerialize = class
  private
    FDataSet: TDataSet;
    FOnlyUpdatedRecords: Boolean;
    /// <summary>
    ///   Creates a JSON object with the data from the current record of DataSet.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that you want to export the record.
    /// </param>
    /// <returns>
    ///   Returns a JSON object containing the record data.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be exported.
    /// </remarks>
    function DataSetToJSONObject(const ADataSet: TDataSet): TJSONObject;
    /// <summary>
    ///   Creates an array of JSON objects with all DataSet records.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that you want to export the records.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with all records from the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be exported.
    /// </remarks>
    function DataSetToJSONArray(const ADataSet: TDataSet): TJSONArray;
    /// <summary>
    ///   Encrypts a blob field in Base64.
    /// </summary>
    /// <param name="AField">
    ///   Refers to the field of type Blob or similar.
    /// </param>
    /// <returns>
    ///   Returns a string with the cryptogrammed content in Base64.
    /// </returns>
    function EncodingBlobField(const AField: TField): string;
  public
    /// <summary>
    ///   Responsible for creating a new isntância of TDataSetSerialize class.
    /// </summary>
    constructor Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False);
    /// <summary>
    ///   Creates an array of JSON objects with all DataSet records.
    /// </summary>
    /// <returns>
    ///   Returns a JSONArray with all records from the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be generated.
    /// </remarks>
    function ToJSONArray: TJSONArray;
    /// <summary>
    ///   Creates a JSON object with the data from the current record of DataSet.
    /// </summary>
    /// <returns>
    ///   Returns a JSON object containing the record data.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be generated.
    /// </remarks>
    function ToJSONObject: TJSONObject;
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
  end;

implementation

uses BooleanField.Types, System.DateUtils, Data.FmtBcd, System.SysUtils, Providers.DataSet.Serialize, System.TypInfo,
  Providers.DataSet.Serialize.Constants, System.Classes, System.NetEncoding, System.Generics.Collections, FireDAC.Comp.DataSet;

{ TDataSetSerialize }

function TDataSetSerialize.ToJSONObject: TJSONObject;
begin
  Result := DataSetToJSONObject(FDataSet);
end;

function TDataSetSerialize.DataSetToJSONArray(const ADataSet: TDataSet): TJSONArray;
var
  LBookMark: TBookmark;
begin
  if ADataSet.IsEmpty then
    Exit(TJSONArray.Create);
  ADataSet.DisableControls;
  try
    Result := TJSONArray.Create;
    LBookMark := ADataSet.BookMark;
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      Result.AddElement(DataSetToJSONObject(ADataSet));
      ADataSet.Next;
    end;
  finally
    if ADataSet.BookmarkValid(LBookMark) then
      ADataSet.GotoBookmark(LBookMark);
    ADataSet.FreeBookmark(LBookMark);
    ADataSet.EnableControls;
  end;
end;

function TDataSetSerialize.DataSetToJSONObject(const ADataSet: TDataSet): TJSONObject;
var
  LKey: string;
  LNestedDataSet: TDataSet;
  LBooleanFieldType: TBooleanFieldType;
  LDataSetDetails: TList<TDataSet>;
  LField: TField;
begin
  Result := TJSONObject.Create;
  if not Assigned(ADataSet) or ADataSet.IsEmpty then
    Exit;
  for LField in ADataSet.Fields do
  begin
    if (not LField.Visible) or LField.IsNull or LField.AsString.Trim.IsEmpty then
      Continue;
    LKey := LowerCase(LField.FieldName);
    case LField.DataType of
      TFieldType.ftBoolean:
        begin
          LBooleanFieldType := TDataSetSerializeUtils.BooleanFieldToType(TBooleanField(LField));
          case LBooleanFieldType of
            bfUnknown, bfBoolean:
              Result.AddPair(LKey, TDataSetSerializeUtils.BooleanToJSON(LField.AsBoolean));
            else
              Result.AddPair(LKey, TJSONNumber.Create(LField.AsInteger));
          end;
        end;
      TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftShortint:
        Result.AddPair(LKey, TJSONNumber.Create(LField.AsInteger));
      TFieldType.ftLongWord, TFieldType.ftAutoInc:
        Result.AddPair(LKey, TJSONNumber.Create(LField.AsWideString));
      TFieldType.ftLargeint:
        Result.AddPair(LKey, TJSONNumber.Create(LField.AsLargeInt));
      TFieldType.ftSingle, TFieldType.ftFloat:
        Result.AddPair(LKey, TJSONNumber.Create(LField.AsFloat));
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo:
        Result.AddPair(LKey, TJSONString.Create(LField.AsWideString));
      TFieldType.ftDate, TFieldType.ftTimeStamp, TFieldType.ftDateTime, TFieldType.ftTime:
        Result.AddPair(LKey, TJSONString.Create(DateToISO8601(LField.AsDateTime)));
      TFieldType.ftCurrency:
        Result.AddPair(LKey, TJSONString.Create(FormatCurr('0.00##', LField.AsCurrency)));
      TFieldType.ftFMTBcd, TFieldType.ftBCD:
        Result.AddPair(LKey, TJSONNumber.Create(BcdToDouble(LField.AsBcd)));
      TFieldType.ftDataSet:
        begin
          LNestedDataSet := TDataSetField(LField).NestedDataSet;
          if LNestedDataSet.RecordCount = 1 then
            Result.AddPair(LKey, DataSetToJSONObject(LNestedDataSet))
          else if LNestedDataSet.RecordCount > 1 then
            Result.AddPair(LKey, DataSetToJSONArray(LNestedDataSet));
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
        Result.AddPair(LKey, TJSONString.Create(EncodingBlobField(LField)));
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LKey]);
    end;
  end;
  if (FOnlyUpdatedRecords) and (FDataSet <> ADataSet) then
    Result.AddPair(OBJECT_STATE, TJSONNumber.Create(Ord(ADataSet.UpdateStatus)));
  LDataSetDetails := TList<TDataSet>.Create;
  try
    ADataSet.GetDetailDataSets(LDataSetDetails);
    for LNestedDataSet in LDataSetDetails do
    begin
      if (FOnlyUpdatedRecords) and (LNestedDataSet is TFDDataSet) then
        TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtDeleted];
      if LNestedDataSet.RecordCount = 1 then
        Result.AddPair(LowerCase(TDataSetSerializeUtils.FormatDataSetName(LNestedDataSet.Name)), DataSetToJSONObject(LNestedDataSet))
      else if LNestedDataSet.RecordCount > 1 then
        Result.AddPair(LowerCase(TDataSetSerializeUtils.FormatDataSetName(LNestedDataSet.Name)), DataSetToJSONArray(LNestedDataSet));
      if (FOnlyUpdatedRecords) and (LNestedDataSet is TFDDataSet) then
        TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtUnmodified];
    end;
  finally
    LDataSetDetails.Free;
  end;
end;

function TDataSetSerialize.EncodingBlobField(const AField: TField): string;
var
  LMemoryStream: TMemoryStream;
  LStringStream: TStringStream;
begin
  LMemoryStream := TMemoryStream.Create;
  try
    TBlobField(AField).SaveToStream(LMemoryStream);
    LMemoryStream.Position := 0;
    LStringStream := TStringStream.Create;
    try
      TNetEncoding.Base64.Encode(LMemoryStream, LStringStream);
      Result := LStringStream.DataString;
    finally
      LStringStream.Free;
    end;
  finally
    LMemoryStream.Free;
  end;
end;

function TDataSetSerialize.SaveStructure: TJSONArray;
var
  LField: TField;
  LJSONObject: TJSONObject;
  LDataSet: TDataSet;
begin
  Result := nil;
  LDataSet := FDataSet;
  if LDataSet.FieldCount <= 0 then
    Exit;
  Result := TJSONArray.Create;
  for LField in LDataSet.Fields do
  begin
    LJSONObject := TJSONObject.Create;
    LJSONObject.AddPair('FieldName', TJSONString.Create(LField.FieldName));
    LJSONObject.AddPair('DisplayLabel', TJSONString.Create(LField.DisplayLabel));
    LJSONObject.AddPair('DataType', TJSONString.Create(GetEnumName(TypeInfo(TFieldType), Integer(LField.DataType))));
    LJSONObject.AddPair('Size', TJSONNumber.Create(LField.SIZE));
    LJSONObject.AddPair('Key', TJSONBool.Create(pfInKey in LField.ProviderFlags));
    LJSONObject.AddPair('Origin', TJSONString.Create(LField.ORIGIN));
    LJSONObject.AddPair('Required', TJSONBool.Create(LField.Required));
    LJSONObject.AddPair('Visible', TJSONBool.Create(LField.Visible));
    LJSONObject.AddPair('ReadOnly', TJSONBool.Create(LField.ReadOnly));
    LJSONObject.AddPair('AutoGenerateValue', TJSONString.Create(GetEnumName(TypeInfo(TAutoRefreshFlag), Integer(LField.AutoGenerateValue))));
    Result.AddElement(LJSONObject);
  end;
end;

constructor TDataSetSerialize.Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False);
begin
  FDataSet := ADataSet;
  FOnlyUpdatedRecords := AOnlyUpdatedRecords;
end;

function TDataSetSerialize.ToJSONArray: TJSONArray;
begin
  Result := DataSetToJSONArray(FDataSet);
end;

end.
