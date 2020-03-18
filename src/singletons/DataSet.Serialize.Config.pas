unit DataSet.Serialize.Config;

interface

type
  TDataSetSerializeConfigExport = class
  private
    FExportNullValues: Boolean;
    FExportOnlyFieldsVisible: Boolean;
    FFormatCurrency: string;
    FFormatDate: string;
  public
    constructor Create;
    property FormatDate: string read FFormatDate write FFormatDate;
    property FormatCurrency: string read FFormatCurrency write FFormatCurrency;
    property ExportOnlyFieldsVisible: Boolean read FExportOnlyFieldsVisible write FExportOnlyFieldsVisible;
    property ExportNullValues: Boolean read FExportNullValues write FExportNullValues;
  end;

  TDataSetSerializeConfig = class
  private
    FLowerCamelCase: Boolean;
    FDataSetPrefix: TArray<string>;
    FDateInputIsUTC: Boolean;
    FExport: TDataSetSerializeConfigExport;
    constructor Create;
  public
    property DataSetPrefix: TArray<string> read FDataSetPrefix write FDataSetPrefix;
    property LowerCamelCase: Boolean read FLowerCamelCase write FLowerCamelCase;
    property DateInputIsUTC: Boolean read FDateInputIsUTC write FDateInputIsUTC;
    property &Export: TDataSetSerializeConfigExport read FExport write FExport;
    class function GetInstance: TDataSetSerializeConfig;
    class function NewInstance: TObject; override;
    destructor Destroy; override;
  end;

var
  Instancia: TDataSetSerializeConfig;

implementation

uses System.SysUtils;

{ TDataSetSerializeConfig }

constructor TDataSetSerializeConfig.Create;
begin
  if not Assigned(FExport) then
    FExport := TDataSetSerializeConfigExport.Create;
end;

destructor TDataSetSerializeConfig.Destroy;
begin
  if Assigned(FExport) then
    FExport.Free;
  inherited;
end;

class function TDataSetSerializeConfig.GetInstance: TDataSetSerializeConfig;
begin
  Result := TDataSetSerializeConfig.Create;
end;

class function TDataSetSerializeConfig.NewInstance: TObject;
begin
  if not Assigned(Instancia) then
  begin
    Instancia := TDataSetSerializeConfig(inherited NewInstance);
    Instancia.LowerCamelCase := True;
    Instancia.DataSetPrefix := ['mt', 'qry'];
    Instancia.DateInputIsUTC := True;
  end;
  Result := Instancia;
end;

{ TDataSetSerializeConfigExport }

constructor TDataSetSerializeConfigExport.Create;
begin
  FExportNullValues := True;
  FExportOnlyFieldsVisible := True;
  FFormatCurrency := '0.00##';
  FFormatDate := 'YYYY-MM-DD';
end;

initialization

finalization
  FreeAndNil(Instancia);

end.
