unit DataSet.Serialize.Samples.Master.Detail;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Grids, DBGrids, DataSet.Serialize,
  ZConnection, ZDataset, fpjson, DB;

type

  { TFrmSamples }

  TFrmSamples = class(TForm)
    pclSamples: TPageControl;
    qrCities: TZQuery;
    qrCitiesID: TLongintField;
    qrCitiesID_STATE: TLongintField;
    qrCitiesNAME: TStringField;
    qrCitiesZIP_CODE: TStringField;
    qrCountries: TZQuery;
    qrCountriesID: TLongintField;
    qrCountriesNAME: TStringField;
    qrCountriesSIGLE: TStringField;
    qrStates: TZQuery;
    qrStatesID: TLongintField;
    qrStatesID_COUNTRY: TLongintField;
    qrStatesNAME: TStringField;
    qrStatesSIGLE: TStringField;
    tabNestedJSON: TTabSheet;
    Panel7: TPanel;
    Panel2: TPanel;
    memoJSONNested: TMemo;
    Panel3: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel13: TPanel;
    dsCountries: TDataSource;
    dsStates: TDataSource;
    dsCities: TDataSource;
    DBGrid2: TDBGrid;
    Panel12: TPanel;
    DBGrid1: TDBGrid;
    DBGrid3: TDBGrid;
    btnLoadFromJSONArray: TButton;
    btnExportJSONArray: TButton;
    memoExportedDataSetNested: TMemo;
    ZConnection1: TZConnection;
    procedure btnLoadFromJSONArrayClick(Sender: TObject);
    procedure btnExportJSONArrayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure InitializaMasterDetail;
    procedure HideKeyFields;
  end;

var
  FrmSamples: TFrmSamples;

implementation

{$R *.lfm}

procedure TFrmSamples.btnExportJSONArrayClick(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  if not qrCountries.IsEmpty then
  begin
    LJSONArray := qrCountries.ToJSONArray;
    try
      memoExportedDataSetNested.Lines.Text := LJSONArray.AsJSON;
    finally
      LJSONArray.Free;
    end;
  end;
end;

procedure TFrmSamples.btnLoadFromJSONArrayClick(Sender: TObject);
begin
  if not(qrCountries.Active) then
    InitializaMasterDetail;
  qrCountries.LoadFromJSON(memoJSONNested.Lines.Text);
end;

procedure TFrmSamples.FormCreate(Sender: TObject);
begin
  HideKeyFields;
end;

procedure TFrmSamples.HideKeyFields;
begin
  if qrCountries.Active then
    qrCountries.FieldByName('ID').Visible := False;
  if qrStates.Active then
  begin
    qrStates.FieldByName('ID').Visible := False;
    qrStates.FieldByName('ID_COUNTRY').Visible := False;
  end;
  if qrCities.Active then
  begin
    qrCities.FieldByName('ID').Visible := False;
    qrCities.FieldByName('ID_STATE').Visible := False;
  end;
end;

procedure TFrmSamples.InitializaMasterDetail;
begin
  TDataSetSerializeConfig.GetInstance.DataSetPrefix := ['qr'];

  qrStates.MasterSource := dsCountries;
  qrStates.MasterFields := 'ID';
  qrStates.IndexFieldNames := 'ID_COUNTRY';

  qrCities.MasterSource := dsStates;
  qrCities.MasterFields := 'ID';
  qrCities.IndexFieldNames := 'ID_STATE';

  qrCities.Open;
  qrStates.Open;
  qrCountries.Open;
end;

end.
