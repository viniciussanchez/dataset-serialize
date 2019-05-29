unit Providers.DataSet.Serialize;

interface

uses System.DateUtils, System.JSON, Data.DB, BooleanField.Types, DataSetField.Types, System.SysUtils;

type
  /// <summary>
  ///   API error class (default).
  /// </summary>
  EDataSetSerializeException = class(Exception);

  TDataSetSerializeUtils = class
  public
    /// <summary>
    ///   Creates a new field in the DataSet.
    /// </summary>
    class function NewDataSetField(const DataSet: TDataSet; const FieldType: TFieldType; const Size: Integer;
      const FieldName, Origin, DisplayLabel: string; const Key, Required, Visible: Boolean): TField;
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
  Origin: string;
begin
  Result := bfUnknown;
  Origin := Trim(BooleanField.Origin);
  for I := Ord(low(TBooleanFieldType)) to Ord(high(TBooleanFieldType)) do
    if TBooleanFieldType(I).ToString.ToLower.Equals(Origin.ToLower) then
      Exit(TBooleanFieldType(I));
end;

class function TDataSetSerializeUtils.DataSetFieldToType(const DataSetField: TDataSetField): TDataSetFieldType;
var
  I: Integer;
  Origin: string;
begin
  Result := dfUnknown;
  Origin := Trim(DataSetField.Origin);
  for I := Ord(low(TDataSetFieldType)) to Ord(high(TDataSetFieldType)) do
    if TDataSetFieldType(I).ToString.ToLower.Equals(Origin.ToLower) then
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

class function TDataSetSerializeUtils.NewDataSetField(const DataSet: TDataSet; const FieldType: TFieldType; const Size: Integer;
  const FieldName, Origin, DisplayLabel: string; const Key, Required, Visible: Boolean): TField;
begin
  Result := DefaultFieldClasses[FieldType].Create(DataSet);
  Result.FieldName := FieldName;
  if Result.FieldName.Trim.IsEmpty then
    Result.FieldName := 'Field' + IntToStr(DataSet.FieldCount + 1);
  Result.FieldKind := fkData;
  Result.DataSet := DataSet;
  Result.Name := CreateValidIdentifier(DataSet.Name + Result.FieldName);
  Result.Size := Size;
  Result.Visible := Visible;
  Result.Required := Required;
  Result.Origin := Origin;
  Result.DisplayLabel := DisplayLabel;
  if Key then
    Result.ProviderFlags := [pfInKey];
  if (FieldType in [ftString, ftWideString]) and (Size <= 0) then
    raise EDataSetSerializeException.CreateFmt(SIZE_NOT_DEFINED_FOR_FIELD, [FieldName]);
end;

class function TDataSetSerializeUtils.BooleanToJSON(const Value: Boolean): TJSONValue;
begin
  if Value then
    Result := TJSONTrue.Create
  else
    Result := TJSONFalse.Create;
end;

end.
