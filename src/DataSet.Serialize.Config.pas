unit DataSet.Serialize.Config;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

type
  TCaseNameDefinition = (cndNone, cndLower, cndUpper, cndLowerCamelCase, cndUpperCamelCase);
  TDateTimeFormat = (dtfISO8601, dtfISO8601Utc, dtfFloatingPoint, dtfTimeStamp);

  TDataSetSerializeConfigExport = class
  private
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
    {$IF DEFINED(FPC)}
    property DecimalSeparator: Char read FDecimalSeparator write FDecimalSeparator;
    property ExportFloatScientificNotation: Boolean read FExportFloatScientificNotation write FExportFloatScientificNotation;
    {$ENDIF}
  end;

  TDataSetSerializeConfigImport = class
  private
    FImportOnlyFieldsVisible: Boolean;
    FDecimalSeparator: Char;
  public
    constructor Create;
    property ImportOnlyFieldsVisible: Boolean read FImportOnlyFieldsVisible write FImportOnlyFieldsVisible;
    property DecimalSeparator: Char read FDecimalSeparator write FDecimalSeparator;
  end;

  TDataSetSerializeConfig = class
  private
    class var FInstance: TDataSetSerializeConfig;

    var
    FCaseNameDefinition: TCaseNameDefinition;
    FDataSetPrefix: TArray<string>;
    FDateTimeFormat: TDateTimeFormat;
    FExport: TDataSetSerializeConfigExport;
    FImport: TDataSetSerializeConfigImport;

    function GetDateInputIsUTC: Boolean;
    function GetDateIsFloatingPoint: Boolean;
    function GetDateTimeIsISO8601: Boolean;
    procedure SetDateInputIsUTC(const Value: Boolean);
    procedure SetDateIsFloatingPoint(const Value: Boolean);
    procedure SetDateTimeIsISO8601(const Value: Boolean);
    function GetDateTimeIsTimeStamp: Boolean;
    procedure SetDateTimeIsTimeStamp(const Value: Boolean);
  protected
    class function GetDefaultInstance: TDataSetSerializeConfig;
  public
    constructor Create;
    destructor Destroy; override;

    property DataSetPrefix: TArray<string> read FDataSetPrefix write FDataSetPrefix;
    property CaseNameDefinition: TCaseNameDefinition read FCaseNameDefinition write FCaseNameDefinition;

    property DateTimeFormat: TDateTimeFormat read FDateTimeFormat write FDateTimeFormat;
    property DateTimeIsISO8601: Boolean read GetDateTimeIsISO8601 write SetDateTimeIsISO8601;
    property DateInputIsUTC: Boolean read GetDateInputIsUTC write SetDateInputIsUTC;
    property DateIsFloatingPoint: Boolean read GetDateIsFloatingPoint write SetDateIsFloatingPoint;
    property DateTimeIsTimeStamp: Boolean read GetDateTimeIsTimeStamp write SetDateTimeIsTimeStamp;

    property &Export: TDataSetSerializeConfigExport read FExport write FExport;
    property Import: TDataSetSerializeConfigImport read FImport write FImport;

    class function GetInstance: TDataSetSerializeConfig;
    class destructor UnInitialize;
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

function TDataSetSerializeConfig.GetDateInputIsUTC: Boolean;
begin
  Result := FDateTimeFormat = dtfISO8601Utc;
end;

function TDataSetSerializeConfig.GetDateIsFloatingPoint: Boolean;
begin
  Result := FDateTimeFormat = dtfFloatingPoint;
end;

function TDataSetSerializeConfig.GetDateTimeIsISO8601: Boolean;
begin
  Result := FDateTimeFormat = dtfISO8601;
end;

function TDataSetSerializeConfig.GetDateTimeIsTimeStamp: Boolean;
begin
  Result := FDateTimeFormat = dtfTimeStamp;
end;

class function TDataSetSerializeConfig.GetDefaultInstance: TDataSetSerializeConfig;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TDataSetSerializeConfig.Create;
    FInstance.CaseNameDefinition := cndLowerCamelCase;
    FInstance.DataSetPrefix := ['mt', 'qry'];
    FInstance.DateTimeFormat := dtfISO8601Utc;
  end;
  Result := FInstance;
end;

class function TDataSetSerializeConfig.GetInstance: TDataSetSerializeConfig;
begin
  Result := TDataSetSerializeConfig.GetDefaultInstance;
end;

procedure TDataSetSerializeConfig.SetDateInputIsUTC(const Value: Boolean);
begin
  if Value then
    FDateTimeFormat := dtfISO8601Utc
  else
    FDateTimeFormat := dtfISO8601;
end;

procedure TDataSetSerializeConfig.SetDateIsFloatingPoint(const Value: Boolean);
begin
  if Value then
    FDateTimeFormat := dtfFloatingPoint
  else
    FDateTimeFormat := dtfISO8601Utc;
end;

procedure TDataSetSerializeConfig.SetDateTimeIsISO8601(const Value: Boolean);
begin
  if Value then
    FDateTimeFormat := dtfISO8601
  else
    FDateTimeFormat := dtfISO8601Utc;
end;

procedure TDataSetSerializeConfig.SetDateTimeIsTimeStamp(const Value: Boolean);
begin
  if Value then
    FDateTimeFormat := dtfTimeStamp
  else
    FDateTimeFormat := dtfISO8601Utc;
end;

class destructor TDataSetSerializeConfig.UnInitialize;
begin
  if Assigned(FInstance) then
    FreeAndNil(FInstance);
end;

constructor TDataSetSerializeConfigExport.Create;
begin
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
end;

constructor TDataSetSerializeConfigImport.Create;
begin
  FDecimalSeparator := '.';
  FImportOnlyFieldsVisible := True;
end;

end.
