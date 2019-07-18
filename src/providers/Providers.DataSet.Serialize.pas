unit Providers.DataSet.Serialize;

interface

uses System.DateUtils, System.JSON, Data.DB, BooleanField.Types, DataSetField.Types, System.SysUtils;

type
  /// <summary>
  ///   API error class (default).
  /// </summary>
  EDataSetSerializeException = class(Exception);

  /// <summary>
  ///   Record representing the structure of a dataset field.
  /// </summary>
  TFieldStructure = record
    FieldType: TFieldType;
    Size: Integer;
    FieldName: string;
    Origin: string;
    DisplayLabel: string;
    Key: Boolean;
    Required: Boolean;
    Visible: Boolean;
    ReadOnly: Boolean;
    AutoGenerateValue: TAutoRefreshFlag;
  end;

  TDataSetSerializeUtils = class
  public
    /// <summary>
    ///   Creates a new field in the DataSet.
    /// </summary>
    /// <param name="FieldStructure">
    ///   Field structure to create a new field to dataset.
    /// </param>
    /// <param name="DataSet">
    ///   DataSet that the field will be created.
    /// </param>
    /// <returns>
    ///   Return a new field.
    /// </returns>
    class function NewDataSetField(const DataSet: TDataSet; const FieldStructure: TFieldStructure): TField;
    /// <summary>
    ///   Converts a boolean to a TBooleanFieldType.
    /// </summary>
    /// <param name="BooleanField">
    ///   Boolean field type.
    /// </param>
    /// <returns>
    ///   Returns a valid boolean field type.
    /// </returns>
    class function BooleanFieldToType(const BooleanField: TBooleanField): TBooleanFieldType;
    /// <summary>
    ///   Converts a DataSet field to a TDataSetFieldType.
    /// </summary>
    /// <param name="DataSetField">
    ///   DataSet field type.
    /// </param>
    /// <returns>
    ///   Returns a valid field.
    /// </returns>
    class function DataSetFieldToType(const DataSetField: TDataSetField): TDataSetFieldType;
    /// <summary>
    ///   Creates a valid name for the field added to the DataSet.
    /// </summary>
    /// <param name="Name">
    ///   Field name.
    /// </param>
    /// <returns>
    ///   Returns a valid name.
    /// </returns>
    class function CreateValidIdentifier(const Name: string): string;
    /// <summary>
    ///   Converts a Boolean value to a JSONValue.
    /// </summary>
    /// <param name="Value">
    ///   Refers to the Boolean value (True or False).
    /// </param>
    /// <returns>
    ///   Returns a JSONValue.
    /// </returns>
    class function BooleanToJSON(const Value: Boolean): TJSONValue;
  end;

implementation

uses Providers.DataSet.Serialize.Constants;

{ TDataSetSerializeUtils }

class function TDataSetSerializeUtils.BooleanFieldToType(const BooleanField: TBooleanField): TBooleanFieldType;
var
  I: Integer;
begin
  Result := bfUnknown;
  for I := Ord(low(TBooleanFieldType)) to Ord(high(TBooleanFieldType)) do
    if LowerCase(TBooleanFieldType(I).ToString).Equals(LowerCase(BooleanField.Origin.Trim)) then
      Exit(TBooleanFieldType(I));
end;

class function TDataSetSerializeUtils.DataSetFieldToType(const DataSetField: TDataSetField): TDataSetFieldType;
var
  I: Integer;
begin
  Result := dfUnknown;
  for I := Ord(low(TDataSetFieldType)) to Ord(high(TDataSetFieldType)) do
    if LowerCase(TDataSetFieldType(I).ToString).Equals(LowerCase(DataSetField.Origin.Trim)) then
      Exit(TDataSetFieldType(I));
end;

class function TDataSetSerializeUtils.CreateValidIdentifier(const Name: string): string;
var
  I: Integer;
  Character: Char;
begin
  I := 0;
  SetLength(Result, Length(name));
  for Character in name do
  begin
    if CharInSet(Character, ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_']) then
    begin
      Inc(I);
      Result[I] := Character;
    end;
  end;
  SetLength(Result, I);
  if I = 0 then
    Result := '_'
  else if CharInSet(Result[1], ['0' .. '9']) then
    Result := '_' + Result;
end;

class function TDataSetSerializeUtils.NewDataSetField(const DataSet: TDataSet; const FieldStructure: TFieldStructure): TField;
begin
  Result := DefaultFieldClasses[FieldStructure.FieldType].Create(DataSet);
  Result.FieldName := FieldStructure.FieldName;
  if Result.FieldName.Trim.IsEmpty then
    Result.FieldName := 'Field' + IntToStr(DataSet.FieldCount + 1);
  Result.FieldKind := fkData;
  Result.DataSet := DataSet;
  Result.Name := CreateValidIdentifier(DataSet.Name + Result.FieldName);
  Result.Size := FieldStructure.Size;
  Result.Visible := FieldStructure.Visible;
  Result.ReadOnly := FieldStructure.ReadOnly;
  Result.Required := FieldStructure.Required;
  Result.Origin := FieldStructure.Origin;
  Result.DisplayLabel := FieldStructure.DisplayLabel;
  Result.AutoGenerateValue := FieldStructure.AutoGenerateValue;
  if FieldStructure.Key then
    Result.ProviderFlags := [pfInKey];
  if (FieldStructure.FieldType in [ftString, ftWideString]) and (FieldStructure.Size <= 0) then
    raise EDataSetSerializeException.CreateFmt(SIZE_NOT_DEFINED_FOR_FIELD, [FieldStructure.FieldName]);
end;

class function TDataSetSerializeUtils.BooleanToJSON(const Value: Boolean): TJSONValue;
begin
  if Value then
    Result := TJSONTrue.Create
  else
    Result := TJSONFalse.Create;
end;

end.
