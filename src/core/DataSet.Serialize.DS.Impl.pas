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
    /// <param name="DataSet">
    ///   Refers to the DataSet that you want to export the record.
    /// </param>
    /// <returns>
    ///   Returns a JSON object containing the record data.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be exported.
    /// </remarks>
    function DataSetToJSONObject(const DataSet: TDataSet): TJSONObject;
    /// <summary>
    ///   Creates an array of JSON objects with all DataSet records.
    /// </summary>
    /// <param name="DataSet">
    ///   Refers to the DataSet that you want to export the records.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with all records from the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible or null fields will not be exported.
    /// </remarks>
    function DataSetToJSONArray(const DataSet: TDataSet): TJSONArray;
    /// <summary>
    ///   Encrypts a blob field in Base64.
    /// </summary>
    /// <param name="Field">
    ///   Refers to the field of type Blob or similar.
    /// </param>
    /// <returns>
    ///   Returns a string with the cryptogrammed content in Base64.
    /// </returns>
    function EncodingBlobField(const Field: TField): string;
  protected
    /// <summary>
    ///   Responsible for defining the DataSet and its owner.
    /// </summary>
    /// <param name="DataSet">
    ///   It refers to the DataSet itself.
    /// </param>
    /// <param name="Owns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the DataSet or not.
    /// </param>
    /// <returns>
    ///   Returns the IDataSetSerialize interface instance itself.
    /// </returns>
    function SetDataSet(const DataSet: TDataSet; const Owns: Boolean = False): IDataSetSerialize;
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

uses DataSetField.Types, BooleanField.Types, System.DateUtils, Data.FmtBcd, System.SysUtils, Providers.DataSet.Serialize,
  Providers.DataSet.Serialize.Constants, System.Classes, System.NetEncoding, System.TypInfo;

{ TDataSetSerialize }

function TDataSetSerialize.ToJSONObject: TJSONObject;
begin
  Result := DataSetToJSONObject(GetDataSet);
end;

function TDataSetSerialize.DataSetToJSONArray(const DataSet: TDataSet): TJSONArray;
var
  BookMark: TBookmark;
begin
  if DataSet.IsEmpty then
    Exit(TJSONArray.Create);
  try
    Result := TJSONArray.Create;
    BookMark := DataSet.BookMark;
    DataSet.First;
    while not DataSet.Eof do
    begin
      Result.AddElement(DataSetToJSONObject(DataSet));
      DataSet.Next;
    end;
  finally
    if DataSet.BookmarkValid(BookMark) then
      DataSet.GotoBookmark(BookMark);
    DataSet.FreeBookmark(BookMark);
  end;
end;

function TDataSetSerialize.DataSetToJSONObject(const DataSet: TDataSet): TJSONObject;
var
  I: Integer;
  Key: string;
  NestedDataSet: TDataSet;
  DataSetFieldType: TDataSetFieldType;
  BooleanFieldType: TBooleanFieldType;
begin
  Result := TJSONObject.Create;
  if not Assigned(DataSet) or DataSet.IsEmpty then
    Exit;
  for I := 0 to Pred(DataSet.FieldCount) do
  begin
    if (not DataSet.Fields[I].Visible) or DataSet.Fields[I].IsNull then
      Continue;
    Key := DataSet.Fields[I].FieldName;
    case DataSet.Fields[I].DataType of
      TFieldType.ftBoolean:
        begin
          BooleanFieldType := TDataSetSerializeUtils.BooleanFieldToType(TBooleanField(DataSet.Fields[I]));
          case BooleanFieldType of
            bfUnknown, bfBoolean:
              Result.AddPair(Key, TDataSetSerializeUtils.BooleanToJSON(DataSet.Fields[I].AsBoolean));
            else
              Result.AddPair(Key, TJSONNumber.Create(DataSet.Fields[I].AsInteger));
          end;
        end;
      TFieldType.ftInteger, TFieldType.ftSmallint, TFieldType.ftShortint:
        Result.AddPair(Key, TJSONNumber.Create(DataSet.Fields[I].AsInteger));
      TFieldType.ftLongWord, TFieldType.ftAutoInc:
        Result.AddPair(Key, TJSONNumber.Create(DataSet.Fields[I].AsWideString));
      TFieldType.ftLargeint:
        Result.AddPair(Key, TJSONNumber.Create(DataSet.Fields[I].AsLargeInt));
      TFieldType.ftSingle, TFieldType.ftFloat:
        Result.AddPair(Key, TJSONNumber.Create(DataSet.Fields[I].AsFloat));
      TFieldType.ftString, TFieldType.ftWideString, TFieldType.ftMemo, TFieldType.ftWideMemo:
        Result.AddPair(Key, TJSONString.Create(DataSet.Fields[I].AsWideString));
      TFieldType.ftDate, TFieldType.ftTimeStamp, TFieldType.ftDateTime, TFieldType.ftTime:
        Result.AddPair(Key, TJSONString.Create(DateToISO8601(DataSet.Fields[I].AsDateTime)));
      TFieldType.ftCurrency:
        Result.AddPair(Key, TJSONString.Create(FormatCurr('0.00##', DataSet.Fields[I].AsCurrency)));
      TFieldType.ftFMTBcd, TFieldType.ftBCD:
        Result.AddPair(Key, TJSONNumber.Create(BcdToDouble(DataSet.Fields[I].AsBcd)));
      TFieldType.ftDataSet:
        begin
          DataSetFieldType := TDataSetSerializeUtils.DataSetFieldToType(TDataSetField(DataSet.Fields[I]));
          NestedDataSet := TDataSetField(DataSet.Fields[I]).NestedDataSet;
          case DataSetFieldType of
            dfJSONObject:
              Result.AddPair(Key, DataSetToJSONObject(NestedDataSet));
            dfJSONArray:
              Result.AddPair(Key, DataSetToJSONArray(NestedDataSet));
          end;
        end;
      TFieldType.ftGraphic, TFieldType.ftBlob, TFieldType.ftStream:
        Result.AddPair(Key, TJSONString.Create(EncodingBlobField(DataSet.Fields[I])));
      else
        raise EDataSetSerializeException.CreateFmt(FIELD_TYPE_NOT_FOUND, [Key]);
    end;
  end;
end;

destructor TDataSetSerialize.Destroy;
begin
  ClearDataSet;
  inherited Destroy;
end;

function TDataSetSerialize.EncodingBlobField(const Field: TField): string;
var
  MemoryStream: TMemoryStream;
  StringStream: TStringStream;
begin
  MemoryStream := TMemoryStream.Create;
  try
    TBlobField(Field).SaveToStream(MemoryStream);
    MemoryStream.Position := 0;
    StringStream := TStringStream.Create;
    try
      TNetEncoding.Base64.Encode(MemoryStream, StringStream);
      Result := StringStream.DataString;
    finally
      StringStream.Free;
    end;
  finally
    MemoryStream.Free;
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

function TDataSetSerialize.SetDataSet(const DataSet: TDataSet; const Owns: Boolean = False): IDataSetSerialize;
begin
  Result := Self;
  ClearDataSet;
  FDataSet := DataSet;
  FOwns := Owns;
end;

function TDataSetSerialize.SaveStructure: TJSONArray;
var
  I: Integer;
  JSONObject: TJSONObject;
  DataSet: TDataSet;
begin
  Result := nil;
  DataSet := GetDataSet;
  if DataSet.FieldCount <= 0 then
    Exit;
  Result := TJSONArray.Create;
  for I := 0 to Pred(DataSet.FieldCount) do
  begin
    JSONObject := TJSONObject.Create;
    JSONObject.AddPair('FieldName', TJSONString.Create(DataSet.Fields[I].FieldName));
    JSONObject.AddPair('DisplayLabel', TJSONString.Create(DataSet.Fields[I].DisplayLabel));
    JSONObject.AddPair('DataType', TJSONString.Create(GetEnumName(TypeInfo(TFieldType), Integer(DataSet.Fields[I].DataType))));
    JSONObject.AddPair('Size', TJSONNumber.Create(DataSet.Fields[I].SIZE));
    JSONObject.AddPair('Key', TJSONBool.Create(pfInKey in DataSet.Fields[I].ProviderFlags));
    JSONObject.AddPair('Origin', TJSONString.Create(DataSet.Fields[I].ORIGIN));
    JSONObject.AddPair('Required', TJSONBool.Create(DataSet.Fields[I].Required));
    JSONObject.AddPair('Visible', TJSONBool.Create(DataSet.Fields[I].Visible));
    Result.AddElement(JSONObject);
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
