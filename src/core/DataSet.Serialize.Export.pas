unit DataSet.Serialize.Export;

interface

uses Data.DB, System.JSON;

type
  TDataSetSerialize = class
  private
    FDataSet: TDataSet;
    FOnlyUpdatedRecords: Boolean;
    FChildRecord: Boolean;
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
    function DataSetToJSONArray(const ADataSet: TDataSet; const IsChild: Boolean = False): TJSONArray;
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
    /// <summary>
    ///   Verifiy if a DataSet has detail dataset and if has child modification.
    /// </summary>
    function HasChildModification(const ADataSet: TDataSet): Boolean;    
  public
    /// <summary>
    ///   Responsible for creating a new instance of TDataSetSerialize class.
    /// </summary>
    constructor Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True);
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

uses DataSet.Serialize.BooleanField, System.DateUtils, Data.FmtBcd, System.SysUtils, DataSet.Serialize.Utils, System.TypInfo,
  DataSet.Serialize.Consts, System.Classes, System.NetEncoding, System.Generics.Collections, FireDAC.Comp.DataSet,
  DataSet.Serialize.UpdatedStatus, DataSet.Serialize.Config;

{ TDataSetSerialize }

function TDataSetSerialize.ToJSONObject: TJSONObject;
begin
  Result := DataSetToJSONObject(FDataSet);
end;

function TDataSetSerialize.DataSetToJSONArray(const ADataSet: TDataSet; const IsChild: Boolean): TJSONArray;
var
  LBookMark: TBookmark;
begin
  Result := TJSONArray.Create;
  if ADataSet.IsEmpty then
    Exit;
  try
    LBookMark := ADataSet.BookMark;
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      if IsChild and FOnlyUpdatedRecords then
        if (ADataSet.UpdateStatus = TUpdateStatus.usUnmodified) and not(HasChildModification(ADataSet)) then
        begin
          ADataSet.Next;
          Continue;
        end;
      Result.AddElement(DataSetToJSONObject(ADataSet));
      ADataSet.Next;
    end;
  finally
    if ADataSet.BookmarkValid(LBookMark) then
      ADataSet.GotoBookmark(LBookMark);
    ADataSet.FreeBookmark(LBookMark);
  end;
end;

function TDataSetSerialize.DataSetToJSONObject(const ADataSet: TDataSet): TJSONObject;
var
  LKey: string;
  LNestedDataSet: TDataSet;
  LDataSetDetails: TList<TDataSet>;
  LField: TField;
begin
  Result := TJSONObject.Create;
  if not Assigned(ADataSet) or ADataSet.IsEmpty then
    Exit;
  for LField in ADataSet.Fields do
  begin
    if TDataSetSerializeConfig.GetInstance.Export.ExportOnlyFieldsVisible then
      if not(LField.Visible) then
        Continue;
    LKey := TDataSetSerializeUtils.NameToLowerCamelCase(LField.FieldName);
    if LField.IsNull then
    begin
      if TDataSetSerializeConfig.GetInstance.Export.ExportNullValues then
        Result.AddPair(LKey, TJSONNull.Create);
      Continue;
    end;
    case LField.DataType of
      TFieldType.ftBoolean:
        begin
          case TDataSetSerializeUtils.BooleanFieldToType(TBooleanField(LField)) of
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
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo, TFieldType.ftGuid:
        Result.AddPair(LKey, TJSONString.Create(LField.AsWideString));
      TFieldType.ftTimeStamp, TFieldType.ftDateTime, TFieldType.ftTime:
        Result.AddPair(LKey, TJSONString.Create(DateToISO8601(LField.AsDateTime, TDataSetSerializeConfig.GetInstance.DateInputIsUTC)));
      TFieldType.ftDate:
        Result.AddPair(LKey, TJSONString.Create(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDate, LField.AsDateTime)));
      TFieldType.ftCurrency:
        begin
          if TDataSetSerializeConfig.GetInstance.Export.FormatCurrency.Trim.IsEmpty then
            Result.AddPair(LKey, TJSONNumber.Create(LField.AsCurrency))
          else
            Result.AddPair(LKey, TJSONString.Create(FormatCurr(TDataSetSerializeConfig.GetInstance.Export.FormatCurrency, LField.AsCurrency)));
        end;
      TFieldType.ftFMTBcd, TFieldType.ftBCD:
        Result.AddPair(LKey, TJSONNumber.Create(BcdToDouble(LField.AsBcd)));
      TFieldType.ftDataSet:
        begin
          LNestedDataSet := TDataSetField(LField).NestedDataSet;
          Result.AddPair(LKey, DataSetToJSONArray(LNestedDataSet));
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftOraBlob, TFieldType.ftStream:
        Result.AddPair(LKey, TJSONString.Create(EncodingBlobField(LField)));
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LKey]);
    end;
  end;
  if (FOnlyUpdatedRecords) and (FDataSet <> ADataSet) then
  begin
    if TDataSetSerializeConfig.GetInstance.LowerCamelCase then
      Result.AddPair('objectState', TJSONString.Create(ADataSet.UpdateStatus.ToString))
    else
      Result.AddPair('object_state', TJSONString.Create(ADataSet.UpdateStatus.ToString));
  end;
  if FChildRecord then
  begin
    LDataSetDetails := TList<TDataSet>.Create;
    try
      ADataSet.GetDetailDataSets(LDataSetDetails);      
      for LNestedDataSet in LDataSetDetails do
      begin
        if FOnlyUpdatedRecords then
          TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtDeleted, rtUnmodified];
        if TDataSetSerializeConfig.GetInstance.Export.ExportEmptyDataSet or (LNestedDataSet.RecordCount > 0) then
          Result.AddPair(TDataSetSerializeUtils.FormatDataSetName(LNestedDataSet.Name), DataSetToJSONArray(LNestedDataSet, True));
        if FOnlyUpdatedRecords then
          TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtUnmodified];
      end;
    finally
      LDataSetDetails.Free;
    end;
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

function TDataSetSerialize.HasChildModification(const ADataSet: TDataSet): Boolean;
var
  LMasterSource: TDataSource;
  LDataSetDetails: TList<TDataSet>;
  LNestedDataSet: TDataSet;
begin
  Result := False;
  LDataSetDetails := TList<TDataSet>.Create;
  try
    ADataSet.GetDetailDataSets(LDataSetDetails);
    for LNestedDataSet in LDataSetDetails do
    begin
      Result := HasChildModification(LNestedDataSet);
      if Result then
        Break;
      if not (LNestedDataSet is TFDDataSet) then
        Continue;
      LMasterSource := TFDDataSet(LNestedDataSet).MasterSource;
      try
        TFDDataSet(LNestedDataSet).MasterSource := nil;
        TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtDeleted];
        Result := TFDDataSet(LNestedDataSet).RecordCount > 0;
        if Result then
          Break;
      finally
        TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtUnmodified];
        TFDDataSet(LNestedDataSet).MasterSource := LMasterSource;
      end;
    end;
  finally
    LDataSetDetails.Free;
  end;
end;

function TDataSetSerialize.SaveStructure: TJSONArray;
var
  LField: TField;
  LJSONObject: TJSONObject;
begin
  Result := TJSONArray.Create;
  if FDataSet.FieldCount <= 0 then
    Exit;
  for LField in FDataSet.Fields do
  begin
    LJSONObject := TJSONObject.Create;
    LJSONObject.AddPair(FIELD_PROPERTY_ALIGNMENT, TJSONString.Create(GetEnumName(TypeInfo(TAlignment), Ord(LField.Alignment))));
    LJSONObject.AddPair(FIELD_PROPERTY_FIELD_NAME, TJSONString.Create(LField.FieldName));
    LJSONObject.AddPair(FIELD_PROPERTY_DISPLAY_LABEL, TJSONString.Create(LField.DisplayLabel));
    LJSONObject.AddPair(FIELD_PROPERTY_DATA_TYPE, TJSONString.Create(GetEnumName(TypeInfo(TFieldType), Integer(LField.DataType))));
    LJSONObject.AddPair(FIELD_PROPERTY_SIZE, TJSONNumber.Create(LField.SIZE));
    LJSONObject.AddPair(FIELD_PROPERTY_KEY, TJSONBool.Create(pfInKey in LField.ProviderFlags));
    LJSONObject.AddPair(FIELD_PROPERTY_ORIGIN, TJSONString.Create(LField.ORIGIN));
    LJSONObject.AddPair(FIELD_PROPERTY_REQUIRED, TJSONBool.Create(LField.Required));
    LJSONObject.AddPair(FIELD_PROPERTY_VISIBLE, TJSONBool.Create(LField.Visible));
    LJSONObject.AddPair(FIELD_PROPERTY_READ_ONLY, TJSONBool.Create(LField.ReadOnly));
    LJSONObject.AddPair(FIELD_PROPERTY_AUTO_GENERATE_VALUE, TJSONString.Create(GetEnumName(TypeInfo(TAutoRefreshFlag), Integer(LField.AutoGenerateValue))));
    Result.AddElement(LJSONObject);
  end;
end;

constructor TDataSetSerialize.Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True);
begin
  FDataSet := ADataSet;
  FOnlyUpdatedRecords := AOnlyUpdatedRecords;
  FChildRecord := AChildRecords;
end;

function TDataSetSerialize.ToJSONArray: TJSONArray;
begin
  Result := DataSetToJSONArray(FDataSet);
end;

end.
