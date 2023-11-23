unit DataSet.Serialize.Config;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

type
  TCaseNameDefinition = (cndNone, cndLower, cndUpper, cndLowerCamelCase, cndUpperCamelCase);

  TDataSetSerializeConfigExport = class
  private
    FTryConvertStringToJson: Boolean;
    FExportBCDAsFloat: Boolean;
    FExportLargeIntAsString: Boolean;
    FExportNullValues: Boolean;
    FExportNullAsEmptyString: Boolean;
    FExportOnlyFieldsVisible: Boolean;
    FExportEmptyDataSet: Boolean;
    FFormatCurrency: string;
    FFormatDate: string;
    FFormatTime: string;
    FFormatDateTime: string;
    FFormatFloat: string;
    FExportChildDataSetAsJsonObject: Boolean;
    {$IF DEFINED(FPC)}
    FDecimalSeparator: Char;
    FExportFloatScientificNotation : Boolean;
    {$ENDIF}
  public
    constructor Create;
    property FormatDate: string read FFormatDate write FFormatDate;
    property FormatTime: string read FFormatTime write FFormatTime;
    property FormatDateTime: string read FFormatDateTime write FFormatDateTime;
    property FormatCurrency: string read FFormatCurrency write FFormatCurrency;
    property FormatFloat: string read FFormatFloat write FFormatFloat;
    property ExportOnlyFieldsVisible: Boolean read FExportOnlyFieldsVisible write FExportOnlyFieldsVisible;
    property ExportNullValues: Boolean read FExportNullValues write FExportNullValues;
    property ExportNullAsEmptyString: Boolean read FExportNullAsEmptyString write FExportNullAsEmptyString;
    property ExportEmptyDataSet: Boolean read FExportEmptyDataSet write FExportEmptyDataSet;
    property ExportChildDataSetAsJsonObject: Boolean read FExportChildDataSetAsJsonObject write FExportChildDataSetAsJsonObject;
    property TryConvertStringToJson: Boolean read FTryConvertStringToJson write FTryConvertStringToJson;
    {$IF DEFINED(FPC)}
    property DecimalSeparator: Char read FDecimalSeparator write FDecimalSeparator;
    property ExportFloatScientificNotation: Boolean read FExportFloatScientificNotation write FExportFloatScientificNotation;
    {$ENDIF}
    property ExportLargeIntAsString: Boolean read FExportLargeIntAsString write FExportLargeIntAsString;
    property ExportBCDAsFloat: Boolean read FExportBCDAsFloat write FExportBCDAsFloat;
  end;

  TDataSetSerializeConfigImport = class
  private
    FDecodeBase64BlobField: Boolean;
    FImportOnlyFieldsVisible: Boolean;
    FDecimalSeparator: Char;
  public
    constructor Create;
    property ImportOnlyFieldsVisible: Boolean read FImportOnlyFieldsVisible write FImportOnlyFieldsVisible;
    property DecimalSeparator: Char read FDecimalSeparator write FDecimalSeparator;
    property DecodeBase64BlobField: Boolean read FDecodeBase64BlobField write FDecodeBase64BlobField;
  end;

  TDataSetSerializeConfig = class
  private
    FCaseNameDefinition: TCaseNameDefinition;
    FDataSetPrefix: TArray<string>;
    FDateInputIsUTC: Boolean;
    FDateTimeIsISO8601: Boolean;
    FDateIsFloatingPoint: Boolean;
    FRemoveBlankSpaceFieldName: Boolean;
    FExport: TDataSetSerializeConfigExport;
    FImport: TDataSetSerializeConfigImport;
    class var FInstance: TDataSetSerializeConfig;
  protected
    class function GetDefaultInstance: TDataSetSerializeConfig;
  public
    constructor Create;
    destructor Destroy; override;
    property DataSetPrefix: TArray<string> read FDataSetPrefix write FDataSetPrefix;
    property CaseNameDefinition: TCaseNameDefinition read FCaseNameDefinition write FCaseNameDefinition;
    property RemoveBlankSpaceFieldName: Boolean read FRemoveBlankSpaceFieldName write FRemoveBlankSpaceFieldName;
    property DateTimeIsISO8601: Boolean read FDateTimeIsISO8601 write FDateTimeIsISO8601;
    property DateInputIsUTC: Boolean read FDateInputIsUTC write FDateInputIsUTC;
    property DateIsFloatingPoint: Boolean read FDateIsFloatingPoint write FDateIsFloatingPoint;
    property &Export: TDataSetSerializeConfigExport read FExport write FExport;
    property Import: TDataSetSerializeConfigImport read FImport write FImport;
    class function GetInstance: TDataSetSerializeConfig;
    class procedure UnInitialize;
  end;

implementation

uses
{$IF DEFINED(FPC)}
  SysUtils;
{$ELSE}
  System.SysUtils;
{$ENDIF}

constructor TDataSetSerializeConfig.Create;
begin
  if not Assigned(FExport) then
    FExport := TDataSetSerializeConfigExport.Create;
  if not Assigned(FImport) then
    FImport := TDataSetSerializeConfigImport.Create;
end;

destructor TDataSetSerializeConfig.Destroy;
begin
  if Assigned(FExport) then
    FreeAndNil(FExport);
  if Assigned(FImport) then
    FreeAndNil(FImport);
  inherited;
end;

class function TDataSetSerializeConfig.GetDefaultInstance: TDataSetSerializeConfig;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TDataSetSerializeConfig.Create;
    FInstance.CaseNameDefinition := cndLowerCamelCase;
    FInstance.DataSetPrefix := ['mt', 'qry'];
    FInstance.DateInputIsUTC := True;
    FInstance.RemoveBlankSpaceFieldName := True;
    FInstance.DateIsFloatingPoint := False;
    FInstance.DateTimeIsISO8601 := True;
  end;
  Result := FInstance;
end;

class function TDataSetSerializeConfig.GetInstance: TDataSetSerializeConfig;
begin
  Result := TDataSetSerializeConfig.GetDefaultInstance;
end;

class procedure TDataSetSerializeConfig.UnInitialize;
begin
  if Assigned(FInstance) then
    FreeAndNil(FInstance);
end;

constructor TDataSetSerializeConfigExport.Create;
begin
  FTryConvertStringToJson := False;
  FExportNullValues := True;
  FExportNullAsEmptyString:= False;
  FExportOnlyFieldsVisible := True;
  ExportEmptyDataSet := False;
  FFormatCurrency := EmptyStr;
  FFormatFloat := EmptyStr;
  FFormatDate := 'YYYY-MM-DD';
  FFormatTime := 'hh:nn:ss.zzz';
  FFormatDateTime := 'yyyy-mm-dd hh:nn:ss.zzz';
  FExportChildDataSetAsJsonObject := False;
  {$IF DEFINED(FPC)}
  FDecimalSeparator := '.';
  FExportFloatScientificNotation := False;
  {$ENDIF}
  FExportLargeIntAsString := False;
  FExportBCDAsFloat := False;                
end;

{ TDataSetSerializeConfigImport }

constructor TDataSetSerializeConfigImport.Create;
begin
  FDecimalSeparator := '.';
  FImportOnlyFieldsVisible := True;
  FDecodeBase64BlobField := True;
end;

initialization

finalization
  TDataSetSerializeConfig.UnInitialize;

end.
