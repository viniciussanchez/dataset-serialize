unit DataSet.Serialize.Samples;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Datasnap.DBClient;

type
  TFrmSamples = class(TForm)
    pclDataSetSerialize: TPageControl;
    tabDataSet: TTabSheet;
    tabJSON: TTabSheet;
    mtDataSet: TFDMemTable;
    mtDataSetID: TIntegerField;
    mtDataSetFIRST_NAME: TStringField;
    mtDataSetCOUNTRY: TStringField;
    Panel1: TPanel;
    dsDataSet: TDataSource;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    mmDataSet: TMemo;
    Splitter1: TSplitter;
    edtName: TEdit;
    Label2: TLabel;
    edtCountry: TEdit;
    Label3: TLabel;
    Button2: TButton;
    Panel3: TPanel;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Splitter2: TSplitter;
    DBGridStructure: TDBGrid;
    mtJSON: TFDMemTable;
    dsJSON: TDataSource;
    Panel4: TPanel;
    mmJSONArray: TMemo;
    Panel5: TPanel;
    Button7: TButton;
    Panel8: TPanel;
    mmMerge: TMemo;
    Button8: TButton;
    Panel9: TPanel;
    Panel10: TPanel;
    mmJSONObject: TMemo;
    Panel6: TPanel;
    Button6: TButton;
    Panel13: TPanel;
    Panel7: TPanel;
    Button5: TButton;
    mmStructure: TMemo;
    mmValidateJSON: TMemo;
    Panel12: TPanel;
    Button9: TButton;
    mmJSONArrayValidate: TMemo;
    tabJSONNested: TTabSheet;
    mtJSONNested: TFDMemTable;
    mtJSONNestedUF: TFDMemTable;
    Panel11: TPanel;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    mtJSONNestedPAIS: TStringField;
    mtJSONNestedSIGLA: TStringField;
    mtJSONNestedUFNOME: TStringField;
    mtJSONNestedUFCEP: TStringField;
    dsJSONNested: TDataSource;
    dsJSONNestedUF: TDataSource;
    Panel14: TPanel;
    mmJSONNested: TMemo;
    Button10: TButton;
    mtJSONNestedESTADOS: TDataSetField;
    Panel15: TPanel;
    mmExportDataSetNested: TMemo;
    Button11: TButton;
    mtJSONNestedCity: TFDMemTable;
    dsJSONNEstedCity: TDataSource;
    DBGrid4: TDBGrid;
    mtJSONNestedUFCIDADES: TDataSetField;
    mtJSONNestedCityNOME: TStringField;
    mtJSONNestedCityCEP: TStringField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel16: TPanel;
    mmDataSetField: TMemo;
    Button12: TButton;
    dsChieldsArray: TDataSource;
    mtChieldsArray: TFDMemTable;
    mtNested: TFDMemTable;
    dsNested: TDataSource;
    mtNestedID: TIntegerField;
    mtNestedNAME: TStringField;
    mtNestedARRAY: TDataSetField;
    Panel17: TPanel;
    DBGrid5: TDBGrid;
    DBGrid6: TDBGrid;
    mtChieldsArrayVALUE: TIntegerField;
    mtDataSetDATE: TDateTimeField;
    tabConfig: TTabSheet;
    chkDateInputIsUTC: TCheckBox;
    chkExportNullValues: TCheckBox;
    chkExportOnlyFieldsVisible: TCheckBox;
    chkFieldNameLowerCamelCasePattern: TCheckBox;
    Label1: TLabel;
    edtFormatDate: TEdit;
    btnApplyFormatDate: TButton;
    Label4: TLabel;
    edtFormatCurrency: TEdit;
    btnFormatCurrency: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure mtDataSetAfterInsert(DataSet: TDataSet);
    procedure chkDateInputIsUTCClick(Sender: TObject);
    procedure chkExportNullValuesClick(Sender: TObject);
    procedure chkExportOnlyFieldsVisibleClick(Sender: TObject);
    procedure chkFieldNameLowerCamelCasePatternClick(Sender: TObject);
    procedure btnApplyFormatDateClick(Sender: TObject);
    procedure btnFormatCurrencyClick(Sender: TObject);
  private
    procedure Append;
    procedure ClearFields;
    function ValidateStructure: Boolean;
  end;

var
  FrmSamples: TFrmSamples;

implementation

{$R *.dfm}

uses DataSet.Serialize, System.JSON, DataSet.Serialize.Language, DataSet.Serialize.Config;

procedure TFrmSamples.Append;
begin
  mtDataSet.Append;
  if not Trim(edtName.Text).IsEmpty then
    mtDataSetFIRST_NAME.AsString := edtName.Text;
  if not Trim(edtCountry.Text).IsEmpty then
    mtDataSetCOUNTRY.AsString := edtCountry.Text;
  mtDataSet.Post;
end;

procedure TFrmSamples.btnApplyFormatDateClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.FormatDate := edtFormatDate.Text;
end;

procedure TFrmSamples.btnFormatCurrencyClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.FormatCurrency := edtFormatCurrency.Text;
end;

procedure TFrmSamples.Button10Click(Sender: TObject);
begin
  mtJSONNested.LoadFromJSON(mmJSONNested.Lines.Text);
end;

procedure TFrmSamples.Button11Click(Sender: TObject);
var
  LJSONObject: TJSONObject;
begin
  if not mtJSONNested.IsEmpty then
  begin
    LJSONObject := mtJSONNested.ToJSONObject;
    try
      mmExportDataSetNested.Lines.Text := LJSONObject.ToString;
    finally
      LJSONObject.Free;
    end;
  end;
end;

procedure TFrmSamples.Button12Click(Sender: TObject);
begin
  mtNested.LoadFromJSON(mmDataSetField.Lines.Text);
end;

procedure TFrmSamples.Button1Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := mtDataSet.ToJSONArray;
  try
    mmDataSet.Lines.Text := LJSONArray.ToString;
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmSamples.Button2Click(Sender: TObject);
begin
  Append;
  ClearFields;
end;

procedure TFrmSamples.Button3Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := mtDataSet.SaveStructure;
  try
    mmDataSet.Lines.Text := LJSONArray.ToString;
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmSamples.Button4Click(Sender: TObject);
var
  LJSONObject: TJSONObject;
begin
  LJSONObject := mtDataSet.ToJSONObject;
  try
    mmDataSet.Lines.Text := LJSONObject.ToString;
  finally
    LJSONObject.Free;
  end;
end;

procedure TFrmSamples.Button5Click(Sender: TObject);
begin
  mtJSON.LoadStructure(mmStructure.Lines.Text);
  DBGridStructure.Columns.RebuildColumns;
  DBGridStructure.Columns.Items[0].Width := 64;
  DBGridStructure.Columns.Items[1].Width := 250;
  DBGridStructure.Columns.Items[2].Width := 145;
  mtJSON.Active := True;
end;

procedure TFrmSamples.Button6Click(Sender: TObject);
begin
  if ValidateStructure then
    mtJSON.LoadFromJSON(mmJSONObject.Lines.Text);
end;

procedure TFrmSamples.Button7Click(Sender: TObject);
begin
  if ValidateStructure then
    mtJSON.LoadFromJSON(mmJSONArray.Lines.Text);
end;

procedure TFrmSamples.Button8Click(Sender: TObject);
begin
  if ValidateStructure then
    if mtJSON.RecordCount > 0 then
      mtJSON.MergeFromJSONObject(mmMerge.Lines.Text);
end;

procedure TFrmSamples.Button9Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := mtJSON.ValidateJSON(mmValidateJSON.Lines.Text);
  try
    mmJSONArrayValidate.Lines.Text := LJSONArray.ToString;
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmSamples.chkDateInputIsUTCClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.DateInputIsUTC := chkDateInputIsUTC.Checked;
end;

procedure TFrmSamples.chkExportNullValuesClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportNullValues := chkExportNullValues.Checked;
end;

procedure TFrmSamples.chkExportOnlyFieldsVisibleClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportOnlyFieldsVisible := chkExportOnlyFieldsVisible.Checked;
end;

procedure TFrmSamples.chkFieldNameLowerCamelCasePatternClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.LowerCamelCase := chkFieldNameLowerCamelCasePattern.Checked;
end;

procedure TFrmSamples.ClearFields;
begin
  edtName.Clear;
  edtCountry.Clear;
end;

procedure TFrmSamples.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmSamples.FormCreate(Sender: TObject);
begin
  mtDataSet.Active := True;
  mtJSONNested.Active := True;
  mtJSONNestedUF.Active := True;
  mtJSONNestedCity.Active := True;
end;

procedure TFrmSamples.FormShow(Sender: TObject);
begin
  pclDataSetSerialize.ActivePage := tabDataSet;
end;

procedure TFrmSamples.mtDataSetAfterInsert(DataSet: TDataSet);
begin
  mtDataSetDATE.AsDateTime := Now;
end;

function TFrmSamples.ValidateStructure: Boolean;
const
  LOAD_STRUCTURE_FIRST = 'Load the structure first';
begin
  Result := True;
  if mtJSON.Fields.Count = 0 then
  begin
    ShowMessage(LOAD_STRUCTURE_FIRST);
    Result := False;
  end;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;

end.
