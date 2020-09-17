unit DataSet.Serialize.Samples.Master.Detail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, DataSet.Serialize, System.JSON;

type
  TFrmSamples = class(TForm)
    pclSamples: TPageControl;
    tabNestedJSON: TTabSheet;
    Panel7: TPanel;
    tabArrayValue: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    memoJSONNested: TMemo;
    Panel3: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel13: TPanel;
    mtCountries: TFDMemTable;
    dsCountries: TDataSource;
    dsStates: TDataSource;
    mtStates: TFDMemTable;
    mtCities: TFDMemTable;
    dsCities: TDataSource;
    mtCountriesNAME: TStringField;
    mtCountriesSIGLE: TStringField;
    mtStatesNAME: TStringField;
    mtStatesSIGLE: TStringField;
    mtCitiesNAME: TStringField;
    mtCitiesZIP_CODE: TStringField;
    DBGrid2: TDBGrid;
    Panel12: TPanel;
    DBGrid1: TDBGrid;
    DBGrid3: TDBGrid;
    btnLoadFromJSONArray: TButton;
    mtCountriesID: TIntegerField;
    mtStatesID: TIntegerField;
    mtCitiesID: TIntegerField;
    mtStatesID_COUNTRY: TIntegerField;
    mtCitiesID_STATE: TIntegerField;
    btnExportJSONArray: TButton;
    memoExportedDataSetNested: TMemo;
    Panel4: TPanel;
    memoArrayValue: TMemo;
    btnLoadArrayFromJSONArray: TButton;
    Panel9: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    DBGrid5: TDBGrid;
    Panel18: TPanel;
    Panel19: TPanel;
    DBGrid6: TDBGrid;
    mtUsers: TFDMemTable;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    dsUsers: TDataSource;
    dsArray: TDataSource;
    mtArray: TFDMemTable;
    mtUsersARRAY: TDataSetField;
    mtArrayVALUE: TIntegerField;
    Panel14: TPanel;
    btnExportArrayValue: TButton;
    memoExportArrayValue: TMemo;
    procedure btnLoadFromJSONArrayClick(Sender: TObject);
    procedure btnExportJSONArrayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoadArrayFromJSONArrayClick(Sender: TObject);
    procedure btnExportArrayValueClick(Sender: TObject);
  private
    procedure InitializaMasterDetail;
    procedure HideKeyFields;
  end;

var
  FrmSamples: TFrmSamples;

implementation

{$R *.dfm}

procedure TFrmSamples.btnExportArrayValueClick(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  if not mtUsers.IsEmpty then
  begin
    LJSONArray := mtUsers.ToJSONArray;
    try
      memoExportArrayValue.Lines.Text := LJSONArray.Format(2);
    finally
      LJSONArray.Free;
    end;
  end;
end;

procedure TFrmSamples.btnExportJSONArrayClick(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  if not mtCountries.IsEmpty then
  begin
    LJSONArray := mtCountries.ToJSONArray;
    try
      memoExportedDataSetNested.Lines.Text := LJSONArray.Format(2);
    finally
      LJSONArray.Free;
    end;
  end;
end;

procedure TFrmSamples.btnLoadArrayFromJSONArrayClick(Sender: TObject);
begin
  mtUsers.LoadFromJSON(memoArrayValue.Lines.Text);
end;

procedure TFrmSamples.btnLoadFromJSONArrayClick(Sender: TObject);
begin
  if not(mtCountries.Active) then
    InitializaMasterDetail;
  mtCountries.LoadFromJSON(memoJSONNested.Lines.Text);
end;

procedure TFrmSamples.FormCreate(Sender: TObject);
begin
  HideKeyFields;
end;

procedure TFrmSamples.HideKeyFields;
begin
  mtCountriesID.Visible := False;
  mtStatesID.Visible := False;
  mtStatesID_COUNTRY.Visible := False;
  mtCitiesID.Visible := False;
  mtCitiesID_STATE.Visible := False;
end;

procedure TFrmSamples.InitializaMasterDetail;
begin
  mtCountries.Open;

  mtStates.Open;
  mtStates.MasterSource := dsCountries;
  mtStates.MasterFields := mtCountriesID.FieldName;
  mtStates.DetailFields := mtStatesID_COUNTRY.FieldName;
  mtStates.IndexFieldNames := mtStatesID_COUNTRY.FieldName;

  mtCities.Open;
  mtCities.MasterSource := dsStates;
  mtCities.MasterFields := mtStatesID.FieldName;
  mtCities.DetailFields := mtCitiesID_STATE.FieldName;
  mtCities.IndexFieldNames := mtCitiesID_STATE.FieldName;
end;

end.
