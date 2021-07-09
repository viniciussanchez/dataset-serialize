unit DataSet.Serialize.Utils;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
{$IF DEFINED(FPC)}
  DB, fpjson, SysUtils, Classes;
{$ELSE}
  System.DateUtils, System.JSON, Data.DB, System.SysUtils, System.Classes, System.Character;
{$ENDIF}

type
  /// <summary>
  ///   API error class (default).
  /// </summary>
  EDataSetSerializeException = class(Exception);

  /// <summary>
  ///   Type to get key values of an dataset.
  /// </summary>
  TKeyValues = array of Variant;

  /// <summary>
  ///   Record representing the structure of a dataset field.
  /// </summary>
  TFieldStructure = record
    Alignment: TAlignment;
    FieldType: TFieldType;
    Size: Integer;
    Precision: Integer;
    FieldName: string;
    Origin: string;
    DisplayLabel: string;
    Key: Boolean;
    Required: Boolean;
    Visible: Boolean;
    ReadOnly: Boolean;
    {$IF NOT DEFINED(FPC)}
    AutoGenerateValue: TAutoRefreshFlag;
    {$ENDIF}
  end;

  TDataSetSerializeUtils = class
  public
    /// <summary>
    ///   Format field name to case name definition.
    /// </summary>
    /// <param name="AFieldName">
    ///   Field name to format.
    /// </param>
    /// <returns>
    ///   Formatted field name.
    /// </returns>
    class function FormatCaseNameDefinition(const AFieldName: string): string;
    /// <summary>
    ///   Creates a new field in the DataSet.
    /// </summary>
    /// <param name="AFieldStructure">
    ///   Field structure to create a new field to dataset.
    /// </param>
    /// <param name="ADataSet">
    ///   DataSet that the field will be created.
    /// </param>
    /// <returns>
    ///   Return a new field.
    /// </returns>
    class function NewDataSetField(const ADataSet: TDataSet; const AFieldStructure: TFieldStructure): TField;
    /// <summary>
    ///   Creates a valid name for the field added to the DataSet.
    /// </summary>
    /// <param name="AName">
    ///   Field name.
    /// </param>
    /// <returns>
    ///   Returns a valid name.
    /// </returns>
    class function CreateValidIdentifier(const AName: string): string;
    /// <summary>
    ///   Converts a Boolean value to a JSONValue.
    /// </summary>
    /// <param name="AValue">
    ///   Refers to the Boolean value (True or False).
    /// </param>
    /// <returns>
    ///   Returns a JSONValue.
    /// </returns>
    class function BooleanToJSON(const AValue: Boolean): {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
    /// <summary>
    ///   Remove the prefix "mt" or "qry" of an child dataset.
    /// </summary>
    class function FormatDataSetName(const ADataSetName: string): string;
    /// <summary>
    ///   Get field data type from a JSONValue
    /// </summary>
    class function GetDataType(const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF}): TFieldType;
  end;

implementation

uses DataSet.Serialize.Consts, DataSet.Serialize.Config;

class function TDataSetSerializeUtils.CreateValidIdentifier(const AName: string): string;
var
  I: Integer;
  LCharacter: Char;
begin
  I := 0;
  {$IF DEFINED(FPC)}
  Result := EmptyStr;
  {$ENDIF}
  SetLength(Result, Length(AName));
  for LCharacter in AName do
  begin
    if CharInSet(LCharacter, ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_']) then
    begin
      Inc(I);
      Result[I] := LCharacter;
    end;
  end;
  SetLength(Result, I);
  if I = 0 then
    Result := '_'
  else if CharInSet(Result[1], ['0' .. '9']) then
    Result := '_' + Result;
end;

class function TDataSetSerializeUtils.FormatCaseNameDefinition(const AFieldName: string): string;
var
  I: Integer;
  LCaseNameDefinition: TCaseNameDefinition;
  LField: TArray<Char>;
begin
  Result := EmptyStr;
  LCaseNameDefinition := TDataSetSerializeConfig.GetInstance.CaseNameDefinition;
  case LCaseNameDefinition of
    cndLower:
      Result := AFieldName.ToLower;
    cndUpper:
      Result := AFieldName.ToUpper;
    cndLowerCamelCase, cndUpperCamelCase:
      begin
        LField := AFieldName.ToCharArray;
        I := Low(LField);
        While i <= High(LField) do
        begin
          if (LField[I] = '_') then
          begin
            Inc(I);
            Result := Result + UpperCase(LField[I]);
          end
          else
          begin
            if (LCaseNameDefinition = cndUpperCamelCase) and (I = 0) then
              Result := Result + UpperCase(LField[I])
            else
              Result := Result + LowerCase(LField[I]);
          end;
          Inc(I);
        end;
        if Result.IsEmpty then
          Result := AFieldName;
      end
  else
    Result := AFieldName;
  end;
end;

class function TDataSetSerializeUtils.FormatDataSetName(const ADataSetName: string): string;
var
  LPrefix: string;
begin
  Result := ADataSetName;
  for LPrefix in TDataSetSerializeConfig.GetInstance.DataSetPrefix do
    if ADataSetName.StartsWith(LPrefix) then
    begin
      Result := Copy(ADataSetName, Succ(LPrefix.Length), ADataSetName.Length - LPrefix.Length);
      Break;
    end;
  Result := Self.FormatCaseNameDefinition(Result);
end;

class function TDataSetSerializeUtils.GetDataType(const AJSONValue: {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF}): TFieldType;
begin
  Result := ftString;
  if AJSONValue is TJSONNumber then
    Result := ftFloat
  {$IF DEFINED(FPC)}
  else if AJSONValue is TJSONBoolean then
  {$ELSE}
  else if (AJSONValue is TJSONTrue) or (AJSONValue is TJSONFalse) then
  {$ENDIF}
    Result := ftBoolean;
end;

class function TDataSetSerializeUtils.NewDataSetField(const ADataSet: TDataSet; const AFieldStructure: TFieldStructure): TField;
begin
  Result := DefaultFieldClasses[AFieldStructure.FieldType].Create(ADataSet);
  Result.Alignment := AFieldStructure.Alignment;
  Result.FieldName := AFieldStructure.FieldName;
  if Result.FieldName.Trim.IsEmpty then
    Result.FieldName := 'Field' + IntToStr(ADataSet.FieldCount + 1);
  Result.FieldKind := fkData;
  Result.DataSet := ADataSet;
  Result.Name := CreateValidIdentifier(ADataSet.Name + Result.FieldName);
  Result.Size := AFieldStructure.Size;

  case Result.DataType of
    ftBCD: 
      TBCDField(Result).Precision := AFieldStructure.Precision;
    ftFloat: 
      TFloatField(Result).Precision := AFieldStructure.Precision;
    {$IF NOT DEFINED(FPC)}
    ftSingle: 
      TSingleField(Result).Precision := AFieldStructure.Precision;
    ftExtended: 
      TExtendedField(Result).Precision := AFieldStructure.Precision;
    {$ENDIF}
    ftCurrency: 
      TCurrencyField(Result).Precision := AFieldStructure.Precision;
    ftFMTBcd: 
      TFMTBCDField(Result).Precision := AFieldStructure.Precision;
  end;

  Result.Visible := AFieldStructure.Visible;
  Result.ReadOnly := AFieldStructure.ReadOnly;
  Result.Required := AFieldStructure.Required;
  Result.Origin := AFieldStructure.Origin;
  Result.DisplayLabel := AFieldStructure.DisplayLabel;
  {$IF NOT DEFINED(FPC)}
  Result.AutoGenerateValue := AFieldStructure.AutoGenerateValue;
  {$ENDIF}
  if AFieldStructure.Key then
    Result.ProviderFlags := [pfInKey];
  if (AFieldStructure.FieldType in [ftString, ftWideString]) and (AFieldStructure.Size <= 0) then
    raise EDataSetSerializeException.CreateFmt(SIZE_NOT_DEFINED_FOR_FIELD, [AFieldStructure.FieldName]);
end;

class function TDataSetSerializeUtils.BooleanToJSON(const AValue: Boolean): {$IF DEFINED(FPC)}TJSONData{$ELSE}TJSONValue{$ENDIF};
begin
  if AValue then
    Result := {$IF DEFINED(FPC)}TJSONBoolean.Create(True){$ELSE}TJSONTrue.Create{$ENDIF}
  else
    Result := {$IF DEFINED(FPC)}TJSONBoolean.Create(False){$ELSE}TJSONFalse.Create{$ENDIF};
end;

end.
