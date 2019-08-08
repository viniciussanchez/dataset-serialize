unit DataSet.Serialize.DS.Impl;

interface

uses DataSet.Serialize.DS.Intf, Data.DB, System.JSON;

type
  TDataSetSerialize = class(TInterfacedObject, IDataSetSerialize)
  private
    FOwns: Boolean;
    FDataSet: TDataSet;
    /// <summary>
    ///   Clears the DataSet pointer and destroys it if it's the owner.
    /// </summary>
    procedure ClearDataSet;
    /// <summary>
    ///   Returns the same DataSet that was defined.
    /// </summary>
    /// <returns>
    ///   Returns the DataSet.
    /// </returns>
    /// <remarks>
    ///   Creates an exception if the DataSet has not been set.
    /// </remarks>
    function GetDataSet: TDataSet;
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
  protected
    /// <summary>
    ///   Responsible for defining the DataSet and its owner.
    /// </summary>
    /// <param name="ADataSet">
    ///   It refers to the DataSet itself.
    /// </param>
    /// <param name="AOwns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the DataSet or not.
    /// </param>
    /// <returns>
    ///   Returns the IDataSetSerialize interface instance itself.
    /// </returns>
    function SetDataSet(const ADataSet: TDataSet; const AOwns: Boolean = False): IDataSetSerialize;
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
    ///   Responsible for exporting the structure of a DataSet in JSON Array format.
    /// </summary>
    /// <returns>
    ///   Returns a JSON array with all fields of the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function SaveStructure: TJSONArray;
  public
    /// <summary>
    ///   Responsible for creating a new isntância of TDataSetSerialize class.
    /// </summary>
    constructor Create;
    /// <summary>
    ///   Creates a new instance of IDataSetSerialize interface.
    /// </summary>
    /// <returns>
    ///   Returns an instance of IDataSetSerialize interface.
    /// </returns>
    class function New: IDataSetSerialize; static;
    /// <summary>
    ///   Responsible for destroying the TDataSetSerialize class instance.
    /// </summary>
    /// <remarks>
    ///   If owner of the DataSet, destroys the same.
    /// </remarks>
    destructor Destroy; override;
  end;

implementation

uses BooleanField.Types, System.DateUtils, Data.FmtBcd, System.SysUtils, Providers.DataSet.Serialize, System.TypInfo,
  Providers.DataSet.Serialize.Constants, System.Classes, System.NetEncoding, System.Generics.Collections;

{ TDataSetSerialize }

function TDataSetSerialize.ToJSONObject: TJSONObject;
begin
  Result := DataSetToJSONObject(GetDataSet);
end;

function TDataSetSerialize.DataSetToJSONArray(const ADataSet: TDataSet): TJSONArray;
var
  LBookMark: TBookmark;
begin
  if ADataSet.IsEmpty then
    Exit(TJSONArray.Create);
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
  end;
end;

function TDataSetSerialize.DataSetToJSONObject(const ADataSet: TDataSet): TJSONObject;
var
  I: Integer;
  LKey: string;
  LNestedDataSet: TDataSet;
  LBooleanFieldType: TBooleanFieldType;
  LDataSetDetails: TList<TDataSet>;
begin
  Result := TJSONObject.Create;
  if not Assigned(ADataSet) or ADataSet.IsEmpty then
    Exit;
  for I := 0 to Pred(ADataSet.FieldCount) do
  begin
    if (not ADataSet.Fields[I].Visible) or ADataSet.Fields[I].IsNull or ADataSet.Fields[I].AsString.Trim.IsEmpty then
      Continue;
    LKey := LowerCase(ADataSet.Fields[I].FieldName);
    case ADataSet.Fields[I].DataType of
      TFieldType.ftBoolean:
        begin
          LBooleanFieldType := TDataSetSerializeUtils.BooleanFieldToType(TBooleanField(ADataSet.Fields[I]));
          case LBooleanFieldType of
            bfUnknown, bfBoolean:
              Result.AddPair(LKey, TDataSetSerializeUtils.BooleanToJSON(ADataSet.Fields[I].AsBoolean));
            else
              Result.AddPair(LKey, TJSONNumber.Create(ADataSet.Fields[I].AsInteger));
          end;
        end;
      TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftShortint:
        Result.AddPair(LKey, TJSONNumber.Create(ADataSet.Fields[I].AsInteger));
      TFieldType.ftLongWord, TFieldType.ftAutoInc:
        Result.AddPair(LKey, TJSONNumber.Create(ADataSet.Fields[I].AsWideString));
      TFieldType.ftLargeint:
        Result.AddPair(LKey, TJSONNumber.Create(ADataSet.Fields[I].AsLargeInt));
      TFieldType.ftSingle, TFieldType.ftFloat:
        Result.AddPair(LKey, TJSONNumber.Create(ADataSet.Fields[I].AsFloat));
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo:
        Result.AddPair(LKey, TJSONString.Create(ADataSet.Fields[I].AsWideString));
      TFieldType.ftDate, TFieldType.ftTimeStamp, TFieldType.ftDateTime, TFieldType.ftTime:
        Result.AddPair(LKey, TJSONString.Create(DateToISO8601(ADataSet.Fields[I].AsDateTime)));
      TFieldType.ftCurrency:
        Result.AddPair(LKey, TJSONString.Create(FormatCurr('0.00##', ADataSet.Fields[I].AsCurrency)));
      TFieldType.ftFMTBcd, TFieldType.ftBCD:
        Result.AddPair(LKey, TJSONNumber.Create(BcdToDouble(ADataSet.Fields[I].AsBcd)));
      TFieldType.ftDataSet:
        begin
          LNestedDataSet := TDataSetField(ADataSet.Fields[I]).NestedDataSet;
          if LNestedDataSet.RecordCount = 1 then
            Result.AddPair(LKey, DataSetToJSONObject(LNestedDataSet))
          else if LNestedDataSet.RecordCount > 1 then
            Result.AddPair(LKey, DataSetToJSONArray(LNestedDataSet));
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
        Result.AddPair(LKey, TJSONString.Create(EncodingBlobField(ADataSet.Fields[I])));
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [LKey]);
    end;
  end;
  LDataSetDetails := TList<TDataSet>.Create;
  try
    ADataSet.GetDetailDataSets(LDataSetDetails);
    for I := 0 to Pred(LDataSetDetails.Count) do
    begin
      if LDataSetDetails.Items[I].RecordCount = 1 then
        Result.AddPair(LowerCase(LDataSetDetails.Items[I].Name), DataSetToJSONObject(LDataSetDetails.Items[I]))
      else if LDataSetDetails.Items[I].RecordCount > 1 then
        Result.AddPair(LowerCase(LDataSetDetails.Items[I].Name), DataSetToJSONArray(LDataSetDetails.Items[I]));
    end;
  finally
    LDataSetDetails.Free;
  end;
end;

destructor TDataSetSerialize.Destroy;
begin
  ClearDataSet;
  inherited Destroy;
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

procedure TDataSetSerialize.ClearDataSet;
begin
  if FOwns then
    if Assigned(FDataSet) then
      FDataSet.Free;
  FDataSet := nil;
end;

function TDataSetSerialize.GetDataSet: TDataSet;
begin
  if not Assigned(FDataSet) then
    raise EDataSetSerializeException.Create(DATASET_NOT_DIFINED);
  Result := FDataSet;
end;

class function TDataSetSerialize.New: IDataSetSerialize;
begin
  Result := TDataSetSerialize.Create;
end;

function TDataSetSerialize.SetDataSet(const ADataSet: TDataSet; const AOwns: Boolean = False): IDataSetSerialize;
begin
  Result := Self;
  ClearDataSet;
  FDataSet := ADataSet;
  FOwns := AOwns;
end;

function TDataSetSerialize.SaveStructure: TJSONArray;
var
  I: Integer;
  LJSONObject: TJSONObject;
  LDataSet: TDataSet;
begin
  Result := nil;
  LDataSet := GetDataSet;
  if LDataSet.FieldCount <= 0 then
    Exit;
  Result := TJSONArray.Create;
  for I := 0 to Pred(LDataSet.FieldCount) do
  begin
    LJSONObject := TJSONObject.Create;
    LJSONObject.AddPair('FieldName', TJSONString.Create(LDataSet.Fields[I].FieldName));
    LJSONObject.AddPair('DisplayLabel', TJSONString.Create(LDataSet.Fields[I].DisplayLabel));
    LJSONObject.AddPair('DataType', TJSONString.Create(GetEnumName(TypeInfo(TFieldType), Integer(LDataSet.Fields[I].DataType))));
    LJSONObject.AddPair('Size', TJSONNumber.Create(LDataSet.Fields[I].SIZE));
    LJSONObject.AddPair('Key', TJSONBool.Create(pfInKey in LDataSet.Fields[I].ProviderFlags));
    LJSONObject.AddPair('Origin', TJSONString.Create(LDataSet.Fields[I].ORIGIN));
    LJSONObject.AddPair('Required', TJSONBool.Create(LDataSet.Fields[I].Required));
    LJSONObject.AddPair('Visible', TJSONBool.Create(LDataSet.Fields[I].Visible));
    LJSONObject.AddPair('ReadOnly', TJSONBool.Create(LDataSet.Fields[I].ReadOnly));
    LJSONObject.AddPair('AutoGenerateValue', TJSONString.Create(GetEnumName(TypeInfo(TAutoRefreshFlag), Integer(LDataSet.Fields[I].AutoGenerateValue))));
    Result.AddElement(LJSONObject);
  end;
end;

constructor TDataSetSerialize.Create;
begin
  FDataSet := nil;
  FOwns := False;
end;

function TDataSetSerialize.ToJSONArray: TJSONArray;
begin
  Result := DataSetToJSONArray(GetDataSet);
end;

end.
