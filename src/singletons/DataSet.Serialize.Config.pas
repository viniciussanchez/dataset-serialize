unit DataSet.Serialize.Config;

interface

type
  TDataSetSerializeConfig = class
  private
    FDateInputIsUTC: Boolean;
    constructor Create;
  public
    property DateInputIsUTC: Boolean read FDateInputIsUTC write FDateInputIsUTC;
    class function GetInstance: TDataSetSerializeConfig;
    class function NewInstance: TObject; override;
  end;

var
  Instancia: TDataSetSerializeConfig;

implementation

uses System.SysUtils;

constructor TDataSetSerializeConfig.Create;
begin

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
    Instancia.DateInputIsUTC := True;
  end;
  Result := Instancia;
end;

initialization

finalization
  FreeAndNil(Instancia);

end.
