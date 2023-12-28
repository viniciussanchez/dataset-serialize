unit DataSet.Serialize.Export;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  Classes, DB, Generics.Collections, fpjson;
{$ELSE}
  Data.DB, System.JSON;
{$ENDIF}

type
  {$IF DEFINED(FPC)}
  { TJSONExtFloatNumber }
  TJSONExtFloatNumber =class(TJSONFloatNumber)
    function GetAsString: TJSONStringType; override;
  end;
  {$ENDIF}

  TDataSetSerialize = class
  private
    FDataSet: TDataSet;
    FOnlyUpdatedRecords: Boolean;
    FChildRecord: Boolean;
    FValueRecord: Boolean;
    FEncodeBase64Blob: Boolean;
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
    function DataSetToJSONArray(const ADataSet: TDataSet; const IsChild: Boolean; const IsValue: Boolean = True; const IsEncodeBlob: Boolean = True): TJSONArray;
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
    constructor Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True; const AValueRecords: Boolean = True; const AEncodeBase64Blob: Boolean = True);
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
  DateUtils, SysUtils, FmtBCD, TypInfo, base64, StrUtils,
{$ELSE}
  System.DateUtils, Data.FmtBcd, System.SysUtils, System.StrUtils, System.TypInfo, System.Classes, System.NetEncoding, System.Generics.Collections,
  FireDAC.Comp.DataSet,
{$ENDIF}
  DataSet.Serialize.Utils, DataSet.Serialize.Consts, DataSet.Serialize.UpdatedStatus, DataSet.Serialize.Config;

{$IF DEFINED(FPC)}
{ TJSONExtFloatNumber }

function TJSONExtFloatNumber.GetAsString: TJSONStringType;
var
  LFormatSettings: TFormatSettings;
begin
  if TDataSetSerializeConfig.GetInstance.&Export.ExportFloatScientificNotation then
    Result:=inherited GetAsString
  else
  begin
    LFormatSettings.DecimalSeparator := FormatSettings.DecimalSeparator;
    if (TDataSetSerializeConfig.GetInstance.&Export.DecimalSeparator <> '') then
      LFormatSettings.DecimalSeparator := TDataSetSerializeConfig.GetInstance.&Export.DecimalSeparator;
    Result := FloatToStr(GetAsFloat, LFormatSettings);
    // Str produces a ' ' in front where the - can go.
    if (Result<>'') and (Result[1]=' ') then
      Delete(Result,1,1);
  end;
end;
{$ENDIF}

{ TDataSetSerialize }

function TDataSetSerialize.ToJSONObject: TJSONObject;
begin
  Result := DataSetToJSONObject(FDataSet);
end;

function TDataSetSerialize.DataSetToJSONArray(const ADataSet: TDataSet; const IsChild: Boolean; const IsValue: Boolean = True; const IsEncodeBlob: Boolean = True): TJSONArray;
var
  LBookMark: TBookmark;
  LHexString: String;
  LByteValue: Byte;
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
            begin
              if TDataSetSerializeConfig.GetInstance.Export.FormatFloat.Trim.IsEmpty then
                Result.Add(ADataSet.Fields[0].AsFloat)
              else
                Result.Add(FormatFloat(TDataSetSerializeConfig.GetInstance.Export.FormatFloat, ADataSet.Fields[0].AsFloat));
            end;
          TFieldType.ftDateTime, TFieldType.ftTimeStamp:
            begin
              if TDataSetSerializeConfig.GetInstance.DateIsFloatingPoint then
                Result.Add(ADataSet.Fields[0].AsDateTime)
              else if TDataSetSerializeConfig.GetInstance.DateTimeIsISO8601 then
                Result.Add(DateToISO8601(ADataSet.Fields[0].AsDateTime, TDataSetSerializeConfig.GetInstance.DateInputIsUTC))
              else
                Result.Add(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDateTime, ADataSet.Fields[0].AsDateTime));
            end;
          TFieldType.ftTime:
            begin
              if TDataSetSerializeConfig.GetInstance.DateIsFloatingPoint then
                Result.Add(ADataSet.Fields[0].AsDateTime)
              else
                Result.Add(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatTime, ADataSet.Fields[0].AsDateTime));
            end;
          TFieldType.ftDate:
            begin
              if TDataSetSerializeConfig.GetInstance.DateIsFloatingPoint then
                Result.Add(ADataSet.Fields[0].AsDateTime)
              else
                Result.Add(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDate, ADataSet.Fields[0].AsDateTime));
            end;
          TFieldType.ftCurrency:
            begin
              if TDataSetSerializeConfig.GetInstance.Export.FormatCurrency.Trim.IsEmpty then
                Result.Add(ADataSet.Fields[0].AsCurrency)
              else
                Result.Add(FormatCurr(TDataSetSerializeConfig.GetInstance.Export.FormatCurrency, ADataSet.Fields[0].AsCurrency));
            end;
          TFieldType.ftFMTBcd, TFieldType.ftBCD:
            Result.Add(BcdToDouble(ADataSet.Fields[0].AsBcd));
          TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftOraBlob, TFieldType.ftOraClob, TFieldType.ftStream:
            begin
              if IsEncodeBlob then
                Result.Add(EncodingBlobField(ADataSet.Fields[0]))
              else
                Result.Add(ADataSet.Fields[0].AsString);
            end;
          TFieldType.ftVarBytes, TFieldType.ftBytes:
            begin
              LHexString := EmptyStr;
              for LByteValue in ADataSet.Fields[0].AsBytes do
                LHexString := LHexString + IntToHex(LByteValue, 2);
              Result.Add(LHexString);
            end
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
  LDataSetNameNotDefinedCount: Integer;
  LKey, LHexString, LDataSetName, LStringValue: string;
  LNestedDataSet: TDataSet;
  LDataSetDetails: TList<TDataSet>;
  LField: TField;
  LByteValue: Byte;
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
    if Assigned(LField.OnGetText) then
    begin
      Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(LField.Text));
      Continue;
    end;
    case LField.DataType of
      TFieldType.ftBoolean:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TDataSetSerializeUtils.BooleanToJSON(LField.AsBoolean));
      TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftAutoInc{$IF NOT DEFINED(FPC)}, TFieldType.ftShortint, TFieldType.ftLongWord, TFieldType.ftWord, TFieldType.ftByte{$ENDIF}:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsInteger{$ELSE}TJSONNumber.Create(LField.AsInteger){$ENDIF});
      TFieldType.ftLargeint:
        begin
          if TDataSetSerializeConfig.GetInstance.Export.ExportLargeIntAsString then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsLargeInt.ToString{$ELSE}TJSONString.Create(LField.AsLargeInt.ToString){$ENDIF})
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsLargeInt{$ELSE}TJSONNumber.Create(LField.AsLargeInt){$ENDIF});
        end; 
      {$IF NOT DEFINED(FPC)}TFieldType.ftSingle, TFieldType.ftExtended, {$ENDIF}TFieldType.ftFloat:
        begin
          if TDataSetSerializeConfig.GetInstance.Export.FormatFloat.Trim.IsEmpty then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}TJSONExtFloatNumber.Create(LField.AsFloat){$ELSE}TJSONNumber.Create(LField.AsFloat){$ENDIF})
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatFloat(TDataSetSerializeConfig.GetInstance.Export.FormatFloat, LField.AsFloat)));
        end;
      TFieldType.ftGuid:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(LField.AsWideString));
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo, TFieldType.ftFixedChar, TFieldType.ftFixedWideChar:
        begin
          LStringValue := Trim(LField.AsWideString);
          if TDataSetSerializeConfig.GetInstance.Export.TryConvertStringToJson then
          begin
            if (LStringValue.StartsWith('{') and LStringValue.EndsWith('}')) or (LStringValue.StartsWith('[') and LStringValue.EndsWith(']')) then
            begin
              try
                Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}GetJSON(LStringValue){$ELSE}TJSONObject.ParseJSONValue(LStringValue){$ENDIF});
              except
                Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(LField.AsWideString));
              end;
            end
            else
              Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(LField.AsWideString));
          end
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(LField.AsWideString));
        end;
      TFieldType.ftDateTime,TFieldType.ftTimeStamp:
        begin
          if TDataSetSerializeConfig.GetInstance.DateIsFloatingPoint then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsFloat{$ELSE}TJSONNumber.Create(LField.AsFloat){$ENDIF})
          else if TDataSetSerializeConfig.GetInstance.DateTimeIsISO8601 then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(DateToISO8601(LField.AsDateTime, TDataSetSerializeConfig.GetInstance.DateInputIsUTC)))
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDateTime, LField.AsDateTime)));
        end;
      TFieldType.ftTime:
        begin
          if TDataSetSerializeConfig.GetInstance.DateIsFloatingPoint then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsFloat{$ELSE}TJSONNumber.Create(LField.AsFloat){$ENDIF})
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatTime, LField.AsDateTime)));
        end;
      TFieldType.ftDate:
        begin
          if TDataSetSerializeConfig.GetInstance.DateIsFloatingPoint then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}LField.AsFloat{$ELSE}TJSONNumber.Create(LField.AsFloat){$ENDIF})
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatDateTime(TDataSetSerializeConfig.GetInstance.Export.FormatDate, LField.AsDateTime)));
        end;
      TFieldType.ftCurrency:
        begin
          if TDataSetSerializeConfig.GetInstance.Export.FormatCurrency.Trim.IsEmpty then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}TJSONExtFloatNumber.Create(LField.AsCurrency){$ELSE}TJSONNumber.Create(LField.AsCurrency){$ENDIF})
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(FormatCurr(TDataSetSerializeConfig.GetInstance.Export.FormatCurrency, LField.AsCurrency)));
        end;
      TFieldType.ftFMTBcd, TFieldType.ftBCD:
        if TDataSetSerializeConfig.GetInstance.Export.ExportBCDAsFloat then
          Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}TJSONExtFloatNumber.Create(BcdToDouble(LField.AsBcd)){$ELSE}TJSONNumber.Create(BcdToDouble(LField.AsBcd)){$ENDIF})
        else
          Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, {$IF DEFINED(FPC)}BcdToDouble(LField.AsBcd){$ELSE}TJSONNumber.Create(BcdToDouble(LField.AsBcd)){$ENDIF});
      {$IF NOT DEFINED(FPC)}
      TFieldType.ftDataSet:
        begin
          LNestedDataSet := TDataSetField(LField).NestedDataSet;
          Result.AddPair(LKey, DataSetToJSONArray(LNestedDataSet, False, AValue));
        end;
      {$ENDIF}
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftOraBlob, TFieldType.ftOraClob{$IF NOT DEFINED(FPC)}, TFieldType.ftStream{$ENDIF}:
        Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, TJSONString.Create(IfThen(FEncodeBase64Blob, EncodingBlobField(LField), LField.AsString)));
      TFieldType.ftVarBytes, TFieldType.ftBytes:
        begin
          LHexString := EmptyStr;
          for LByteValue in LField.AsBytes do
            LHexString := LHexString + IntToHex(LByteValue, 2);
          Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LKey, LHexString);
        end;
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LKey]);
    end;
  end;
  if (FOnlyUpdatedRecords) and (FDataSet <> ADataSet) then
    Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(TDataSetSerializeUtils.FormatCaseNameDefinition('object_state'), TJSONString.Create(ADataSet.UpdateStatus.ToString));
  if FChildRecord then
  begin
    LDataSetDetails := TList<TDataSet>.Create;
    try
      LDataSetNameNotDefinedCount := 0;
      TDataSetSerializeUtils.GetDetailsDatasets(ADataSet, LDataSetDetails);
      for LNestedDataSet in LDataSetDetails do
      begin
        {$IF NOT DEFINED(FPC)}
        if FOnlyUpdatedRecords then
          TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtDeleted, rtUnmodified];
        {$ENDIF}
        try
          if (not TDataSetSerializeConfig.GetInstance.Export.ExportEmptyDataSet) and (LNestedDataSet.RecordCount = 0) then
            Continue;
          if TDataSetSerializeConfig.GetInstance.Export.ExportOnlyFieldsVisible and (not HasVisibleFields(LNestedDataSet)) then
            Continue;
          if string(LNestedDataSet.Name).Trim.IsEmpty then
          begin
            Inc(LDataSetNameNotDefinedCount);
            LDataSetName := TDataSetSerializeUtils.FormatDataSetName('dataset_name_not_defined_' + LDataSetNameNotDefinedCount.ToString);
          end
          else
            LDataSetName := TDataSetSerializeUtils.FormatDataSetName(LNestedDataSet.Name);
          if TDataSetSerializeConfig.GetInstance.Export.ExportChildDataSetAsJsonObject and (LNestedDataSet.RecordCount = 1) then
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LDataSetName, DataSetToJsonObject(LNestedDataSet))
          else
            Result.{$IF DEFINED(FPC)}Add{$ELSE}AddPair{$ENDIF}(LDataSetName, DataSetToJSONArray(LNestedDataSet, True));
        finally
          {$IF NOT DEFINED(FPC)}
          if FOnlyUpdatedRecords then
            TFDDataSet(LNestedDataSet).FilterChanges := [rtInserted, rtModified, rtUnmodified];
          {$ENDIF}
        end;
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

constructor TDataSetSerialize.Create(const ADataSet: TDataSet; const AOnlyUpdatedRecords: Boolean = False; const AChildRecords: Boolean = True; const AValueRecords: Boolean = True; const AEncodeBase64Blob: Boolean = True);
begin
  FDataSet := ADataSet;
  FOnlyUpdatedRecords := AOnlyUpdatedRecords;
  FChildRecord := AChildRecords;
  FValueRecord := AValueRecords;
  FEncodeBase64Blob := AEncodeBase64Blob;
end;

function TDataSetSerialize.ToJSONArray: TJSONArray;
begin
  Result := DataSetToJSONArray(FDataSet, FChildRecord, FValueRecord, FEncodeBase64Blob);
end;

end.
