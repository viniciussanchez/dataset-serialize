unit Providers.DataSet.Serialize.Sample;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids;

type
  TFrmSamples = class(TForm)
    pclDataSetSerialize: TPageControl;
    tabDataSet: TTabSheet;
    tabJSON: TTabSheet;
    mtDataSet: TFDMemTable;
    mtDataSetID: TIntegerField;
    mtDataSetNAME: TStringField;
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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure mtDataSetAfterInsert(DataSet: TDataSet);
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure mtJSONAfterInsert(DataSet: TDataSet);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    FId, FIdJSON: Integer;
    procedure Append;
    procedure ClearFields;
    function ValidateStructure: Boolean;
  end;

var
  FrmSamples: TFrmSamples;

implementation

{$R *.dfm}

uses DataSet.Serialize.Helper, System.JSON, Language.Types;

procedure TFrmSamples.Append;
begin
  mtDataSet.Append;
  mtDataSetNAME.AsString := edtName.Text;
  mtDataSetCOUNTRY.AsString := edtCountry.Text;
  mtDataSet.Post;
end;

procedure TFrmSamples.Button1Click(Sender: TObject);
begin
  mmDataSet.Lines.Text := mtDataSet.ToJSONArray.ToString;
end;

procedure TFrmSamples.Button2Click(Sender: TObject);
begin
  Append;
  ClearFields;
end;

procedure TFrmSamples.Button3Click(Sender: TObject);
begin
  mmDataSet.Lines.Text := mtDataSet.SaveStructure.ToString;
end;

procedure TFrmSamples.Button4Click(Sender: TObject);
begin
  mmDataSet.Lines.Text := mtDataSet.ToJSONObject.ToString;
end;

procedure TFrmSamples.Button5Click(Sender: TObject);
begin
  mtJSON.LoadStructure(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(mmStructure.Lines.Text),0) as TJSONArray);
  DBGridStructure.Columns.RebuildColumns;
  DBGridStructure.Columns.Items[0].Width := 64;
  DBGridStructure.Columns.Items[1].Width := 250;
  DBGridStructure.Columns.Items[2].Width := 145;
  mtJSON.Active := True;
end;

procedure TFrmSamples.Button6Click(Sender: TObject);
begin
  if ValidateStructure then
    mtJSON.LoadFromJSONObject(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(mmJSONObject.Lines.Text),0) as TJSONObject);
end;

procedure TFrmSamples.Button7Click(Sender: TObject);
begin
  if ValidateStructure then
    mtJSON.LoadFromJSONArray(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(mmJSONArray.Lines.Text),0) as TJSONArray);
end;

procedure TFrmSamples.Button8Click(Sender: TObject);
begin
  if ValidateStructure then
    if mtJSON.RecordCount > 0 then
      mtJSON.MergeFromJSONObject(TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(mmMerge.Lines.Text),0) as TJSONObject);
end;

procedure TFrmSamples.Button9Click(Sender: TObject);
var
  JSON: TJSONObject;
begin
  JSON := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(mmValidateJSON.Lines.Text),0) as TJSONObject;
  mmJSONArrayValidate.Lines.Text := mtJSON.ValidateJSON(JSON, TLanguageType.ptBR).ToString;
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
  FId := 0;
  FIdJSON := 0;
  mtDataSet.Active := True;
end;

procedure TFrmSamples.FormShow(Sender: TObject);
begin
  pclDataSetSerialize.ActivePage := tabDataSet;
end;

procedure TFrmSamples.mtDataSetAfterInsert(DataSet: TDataSet);
begin
  Inc(FId);
  mtDataSetID.AsInteger := FId;
end;

procedure TFrmSamples.mtJSONAfterInsert(DataSet: TDataSet);
begin
  Inc(FIdJSON);
  mtJSON.FieldByName('ID').AsInteger := FIdJSON;
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

end.
