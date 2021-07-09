unit DataSet.Serialize.Export;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  DB, fpjson;
{$ELSE}
  Data.DB, System.JSON;
{$ENDIF}

type
  TDataSetSerialize = class
  private
    FDataSet: TDataSet;
    FOnlyUpdatedRecords: Boolean;
    FChildRecord: Boolean;
    FValueRecord: Boolean;
    /// <summary>
    ///   Creates a JSON object with the data from the current record of DataSet.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that you want to export the record.
    /// </param>
    /// <param name="AValue">
    ///   Only export the value when there is only 1 field in the DataSet.
    /// </param>
    /// <returns>
    ///   Returns a JSON object containing the record data.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be exported.
    /// </remarks>
    function DataSetToJSONObject(const ADataSet: TDataSet; const AValue: Boolean = True): TJSONObject;
    /// <summary>
    ///   Creates an array of JSON objects with all DataSet records.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that you want to export the records.
    /// </param>
    /// <param name="IsChild">
    ///   Inform if it's child records.
    /// </param>
    /// <param name="IsValue">
    ///   Inform if it's to export only field values (when there is only 1 field in the DataSet).
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with all records from the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be exported.
    /// </remarks>
    function DataSetToJSONArray(const ADataSet: TDataSet; const IsChild: Boolean; const IsValue: Boolean = True): TJSONArray;
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
    {$IF NOT DEFINED(FPC)}
    /// <summary>
    ///   Verifiy if a DataSet has detail dataset and if has child modification.
    /// </summary>
    function HasChildModification(const ADataSet: TDataSet): Boolean;
    {$ENDIF}
    /// <summary>
    ///   Verifify if a DataSet has at least one visible field.
    /// </summary>
    function HasVisibleFields(const ADataSet: TDataSet): Boolean;
  public
    /// <summary>
    ///   Responsible for creating a new instance of TDataSetSerialize class.
    /// </summary>
    constructor Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True; const AValueRecords: Boolean = True);
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

uses
{$IF DEFINED(FPC)}
  DateUtils, SysUtils, Classes, FmtBCD, TypInfo, base64,
{$ELSE}
  System.DateUtils, Data.FmtBcd, System.SysUtils, System.TypInfo, System.Classes, System.NetEncoding, System.Generics.Collections,
  FireDAC.Comp.DataSet,
{$ENDIF}
  DataSet.Serialize.Utils, DataSet.Serialize.Consts, DataSet.Serialize.UpdatedStatus, DataSet.Serialize.Config;

{ TDataSetSerialize }

function TDataSetSerialize.ToJSONObject: TJSONObject;
begin
  Result := DataSetToJSONObject(FDataSet);
end;

function TDataSetSerialize.DataSetToJSONArray(const ADataSet: TDataSet; const IsChild: Boolean; const IsValue: Boolean = True): TJSONArray;
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
      {$IF DEFINED(FPC)}
      Result.Add(DataSetToJSONObject(ADataSet));
      {$ELSE}
      if IsChild and FOnlyUpdatedRecords then
        if (ADataSet.UpdateStatus = TUpdateStatus.usUnmodified) and not(HasChildModification(ADataSet)) then
        begin
          ADataSet.Next;
          Continue;
        end;
      if (ADataSet.FieldCount = 1)  and (IsValue)  then
      begin
        case ADataSet.Fields[0].DataType of
          TFieldType.ftBoolean:
            Result.Add(ADataSet.Fields[0].AsBoolean);
          TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftShortint:
            Result.Add(ADataSet.Fields[0].AsInteger);
          TFieldType.ftLongWord, TFieldType.ftAutoInc, TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo, TFieldType.ftGuid:
            Result.Add(ADataSet.Fields[0].AsWideString);
          TFieldType.ftLargeint:
            Result.Add(ADataSet.Fields[0].AsLargeInt);
          TFieldType.ftSingle, TFieldType.ftFloat:
            Result.Add(ADataSet.Fields[0].AsFloat);
          TFieldType.ftDateTime:
               Result.Add(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDateTime, ADataSet.Fields[0].AsDateTime));
           TFieldType.ftTimeStamp:
               Result.Add(DateToISO8601(ADataSet.Fields[0].AsDateTime, TDataSetSerializeConfig.GetInstance.DateInputIsUTC));
           TFieldType.ftTime:
               Result.Add(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatTime, ADataSet.Fields[0].AsDateTime));
           TFieldType.ftDate:
               Result.Add(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDate, ADataSet.Fields[0].AsDateTime));
          TFieldType.ftCurrency:
            begin
              if TDataSetSerializeConfig.GetInstance.Export.FormatCurrency.Trim.IsEmpty then
                Result.Add(ADataSet.Fields[0].AsCurrency)
              else
                Result.Add(FormatCurr(TDataSetSerializeConfig.GetInstance.Export.FormatCurrency, ADataSet.Fields[0].AsCurrency));
            end;
          TFieldType.ftFMTBcd, TFieldType.ftBCD:
            Result.Add(BcdToDouble(ADataSet.Fields[0].AsBcd));
          TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftOraBlob, TFieldType.ftStream:
            Result.Add(EncodingBlobField(ADataSet.Fields[0]));
          else
            raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [ADataSet.Fields[0].FieldName]);
        end;
      end
      else
        Result.AddElement(DataSetToJSONObject(ADataSet, IsValue));
      {$ENDIF}
      ADataSet.Next;
    end;
  finally
    if ADataSet.BookmarkValid(LBookMark) then
      ADataSet.GotoBookmark(LBookMark);
    ADataSet.FreeBookmark(LBookMark);
  end;
end;

function TDataSetSerialize.DataSetToJSONObject(const ADataSet: TDataSet; const AValue: Boolean = True): TJSONObject;
var
  LKey: string;
  {$IF NOT DEFINED(FPC)}
  LNestedDataSet: TDataSet;
  LDataSetDetails: TList<TDataSet>;
  {$ENDIF}
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
    LKey := TDataSetSerializeUtils.FormatCaseNameDefinition(LField.FieldName);
    if LField.IsNull then
    begin
      if TDataSetSerializeConfig.GetInstance.Export.ExportNullValues then
        if TDataSetSerializeConfig.GetInstance.Export.ExportNullAsEmptyString then
          Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, '')
        else
          Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONNull.Create);
      Continue;
    end;
    case LField.DataType of
      TFieldType.ftBoolean:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TDataSetSerializeUtils.BooleanToJSON(LField.AsBoolean));
      TFieldType.ftInteger, TFieldType.ftSmallint{$IF NOT DEFINED(FPC)}, TFieldType.ftShortint, TFieldType.ftWord, TFieldType.ftByte{$ENDIF}:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsInteger{$ELSE}TJSONNumber.Create(LField.AsInteger){$ENDIF});
      {$IF NOT DEFINED(FPC)}TFieldType.ftLongWord, {$ENDIF}TFieldType.ftAutoInc:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsWideString{$ELSE}TJSONNumber.Create(LField.AsWideString){$ENDIF});
      TFieldType.ftLargeint:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsLargeInt{$ELSE}TJSONNumber.Create(LField.AsLargeInt){$ENDIF});
      {$IF NOT DEFINED(FPC)}TFieldType.ftSingle, TFieldType.ftExtended, {$ENDIF}TFieldType.ftFloat:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsFloat{$ELSE}TJSONNumber.Create(LField.AsFloat){$ENDIF});
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo, TFieldType.ftGuid, TFieldType.ftFixedChar, TFieldType.ftFixedWideChar:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(LField.AsWideString));
      TFieldType.ftDateTime:
           Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDateTime, LField.AsDateTime)));
       TFieldType.ftTimeStamp:
           Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(DateToISO8601(LField.AsDateTime, TDataSetSerializeConfig.GetInstance.DateInputIsUTC)));
       TFieldType.ftTime:
           Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatTime, LField.AsDateTime)));
       TFieldType.ftDate:
           Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDate, LField.AsDateTime)));
      TFieldType.ftCurrency:
        begin
          if TDataSetSerializeConfig.GetInstance.Export.FormatCurrency.Trim.IsEmpty then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsCurrency{$ELSE}TJSONNumber.Create(LField.AsCurrency){$ENDIF})
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatCurr(TDataSetSerializeConfig.GetInstance.Export.FormatCurrency, LField.AsCurrency)));
        end;
      TFieldType.ftFMTBcd, TFieldType.ftBCD:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}BcdToDouble(LField.AsBcd){$ELSE}TJSONNumber.Create(BcdToDouble(LField.AsBcd)){$ENDIF});
      {$IF NOT DEFINED(FPC)}
      TFieldType.ftDataSet:
        begin
          LNestedDataSet := TDataSetField(LField).NestedDataSet;
          Result.AddPair(LKey, DataSetToJSONArray(LNestedDataSet, False, AValue));
        end;
      {$ENDIF}
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftOraBlob{$IF NOT DEFINED(FPC)}, TFieldType.ftStream{$ENDIF}:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(EncodingBlobField(LField)));
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LKey]);
    end;
  end;
  if (FOnlyUpdatedRecords) and (FDataSet <> ADataSet) then
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(TDataSetSerializeUtils.FormatCaseNameDefinition('object_state'), TJSONString.Create(ADataSet.UpdateStatus.ToString));
  {$IF NOT DEFINED(FPC)}
  if FChildRecord then
  begin
    LDataSetDetails := TList<TDataSet>.Create;
    try
      ADataSet.GetDetailDataSets(LDataSetDetails);
      for LNestedDataSet in LDataSetDetails do
      begin
        if FOnlyUpdatedRecords then
          TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtDeleted, rtUnmodified];
        try
          if (not TDataSetSerializeConfig.GetInstance.Export.ExportEmptyDataSet) and (LNestedDataSet.RecordCount = 0) then
            Continue;
          if TDataSetSerializeConfig.GetInstance.Export.ExportOnlyFieldsVisible and (not HasVisibleFields(LNestedDataSet)) then
            Continue;
          if TDataSetSerializeConfig.GetInstance.Export.ExportChildDataSetAsJsonObject and (LNestedDataSet.RecordCount = 1) then
            Result.AddPair(TDataSetSerializeUtils.FormatDataSetName(LNestedDataSet.Name), DataSetToJsonObject(LNestedDataSet))
          else
            Result.AddPair(TDataSetSerializeUtils.FormatDataSetName(LNestedDataSet.Name), DataSetToJSONArray(LNestedDataSet, True));
        finally
          if FOnlyUpdatedRecords then
            TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtUnmodified];
        end;
      end;
    finally
      LDataSetDetails.Free;
    end;
  end;
  {$ENDIF}
end;

function TDataSetSerialize.EncodingBlobField(const AField: TField): string;
var
  LMemoryStream: TMemoryStream;
  LStringStream: TStringStream;
  {$IF NOT DEFINED(FPC)}
  LBase64Encoding: TBase64Encoding;
  {$ENDIF}
begin
  LMemoryStream := TMemoryStream.Create;
  LStringStream := TStringStream.Create;
  try
    TBlobField(AField).SaveToStream(LMemoryStream);
    LMemoryStream.Position := 0;
    {$IF DEFINED(FPC)}
    LStringStream.LoadFromStream(LMemoryStream);
    Result := EncodeStringBase64(LStringStream.DataString);
    {$ELSE}
    LBase64Encoding := TBase64Encoding.Create(0);
    try
      LBase64Encoding.Encode(LMemoryStream, LStringStream);
    finally
      LBase64Encoding.Free;
    end;
    Result := LStringStream.DataString;
    {$ENDIF}
  finally
    LStringStream.Free;
    LMemoryStream.Free;
  end;
end;

function TDataSetSerialize.HasVisibleFields(const ADataSet: TDataSet): Boolean;
var
  LField: TField;
begin
  Result := False;
  for LField in ADataSet.Fields do
  begin
    if LField.Visible then
      Exit(True);
  end;
end;

{$IF NOT DEFINED(FPC)}
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
{$ENDIF}

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
    LJSONObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FIELD_PROPERTY_ALIGNMENT, TJSONString.Create(GetEnumName(TypeInfo(TAlignment), Ord(LField.Alignment))));
    LJSONObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FIELD_PROPERTY_FIELD_NAME, TJSONString.Create(LField.FieldName));
    LJSONObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FIELD_PROPERTY_DISPLAY_LABEL, TJSONString.Create(LField.DisplayLabel));
    LJSONObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FIELD_PROPERTY_DATA_TYPE, TJSONString.Create(GetEnumName(TypeInfo(TFieldType), Integer(LField.DataType))));
    LJSONObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FIELD_PROPERTY_SIZE, {$IF DEFINED(FPC)}LField.Size{$ELSE}TJSONNumber.Create(LField.Size){$ENDIF});
    LJSONObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FIELD_PROPERTY_ORIGIN, TJSONString.Create(LField.ORIGIN));

    if IsPublishedProp(LField, 'Precision') then
      LJSONObject.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(FIELD_PROPERTY_PRECISION, {$IF DEFINED(FPC)}TFloatField(LField).Precision{$ELSE}TJSONNumber.Create(TFloatField(LField).Precision){$ENDIF});

    {$IF DEFINED(FPC)}
    LJSONObject.Add(FIELD_PROPERTY_KEY, pfInKey in LField.ProviderFlags);
    LJSONObject.Add(FIELD_PROPERTY_REQUIRED, LField.Required);
    LJSONObject.Add(FIELD_PROPERTY_VISIBLE, LField.Visible);
    LJSONObject.Add(FIELD_PROPERTY_READ_ONLY, LField.ReadOnly);
    {$ELSE}
      {$IF COMPILERVERSION <= 29}
      LJSONObject.AddPair(FIELD_PROPERTY_KEY, TJSONString.Create(BoolToStr(pfInKey in LField.ProviderFlags)));
      LJSONObject.AddPair(FIELD_PROPERTY_REQUIRED, TJSONString.Create(BoolToStr(LField.Required)));
      LJSONObject.AddPair(FIELD_PROPERTY_VISIBLE, TJSONString.Create(BoolToStr(LField.Visible)));
      LJSONObject.AddPair(FIELD_PROPERTY_READ_ONLY, TJSONString.Create(BoolToStr(LField.ReadOnly)));
      {$ELSE}
      LJSONObject.AddPair(FIELD_PROPERTY_KEY, TJSONBool.Create(pfInKey in LField.ProviderFlags));
      LJSONObject.AddPair(FIELD_PROPERTY_REQUIRED, TJSONBool.Create(LField.Required));
      LJSONObject.AddPair(FIELD_PROPERTY_VISIBLE, TJSONBool.Create(LField.Visible));
      LJSONObject.AddPair(FIELD_PROPERTY_READ_ONLY, TJSONBool.Create(LField.ReadOnly));
      {$ENDIF}
    {$ENDIF}

    {$IF NOT DEFINED(FPC)}
    LJSONObject.AddPair(FIELD_PROPERTY_AUTO_GENERATE_VALUE, TJSONString.Create(GetEnumName(TypeInfo(TAutoRefreshFlag), Integer(LField.AutoGenerateValue))));
    {$ENDIF}
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddElement{$ENDIF}(LJSONObject);
  end;
end;

constructor TDataSetSerialize.Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True; const AValueRecords: Boolean = True);
begin
  FDataSet := ADataSet;
  FOnlyUpdatedRecords := AOnlyUpdatedRecords;
  FChildRecord := AChildRecords;
  FValueRecord := AValueRecords;
end;

function TDataSetSerialize.ToJSONArray: TJSONArray;
begin
  Result := DataSetToJSONArray(FDataSet, FChildRecord, FValueRecord);
end;

end.
