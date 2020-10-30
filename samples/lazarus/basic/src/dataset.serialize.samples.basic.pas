unit DataSet.Serialize.Samples.Basic;

{$mode objfpc}{$H+}

interface

uses Classes, SysUtils, memds, DB, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, DBGrids, fpjson, DataSet.Serialize, TypInfo;

type

  { TFrmBasic }

  TFrmBasic = class(TForm)
    btnLoadJSONArray: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    dsEmpty: TDataSource;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    dsUsers: TDataSource;
    DBGrid1: TDBGrid;
    edtCountry: TEdit;
    edtName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    mmDataType: TMemo;
    mtEmpty: TMemDataset;
    memoEmpty: TMemo;
    memoJSONArray: TMemo;
    memoJSONObject: TMemo;
    memoMerge: TMemo;
    mtUsers: TMemDataset;
    memoDataSet: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure btnLoadJSONArrayClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  end;

var
  FrmBasic: TFrmBasic;

implementation

{$R *.lfm}

{ TFrmBasic }

procedure TFrmBasic.Button2Click(Sender: TObject);
begin
  if not mtUsers.Active then
    mtUsers.Active := True;
  mtUsers.Append;
  mtUsers.FieldByName('ID').AsInteger := Succ(mtUsers.RecordCount);
  mtUsers.FieldByName('NAME').AsString := edtName.Text;
  mtUsers.FieldByName('COUNTRY').AsString := edtCountry.Text;
  mtUsers.Post;
  edtName.Clear;
  edtCountry.Clear;
  edtName.SetFocus;
end;

procedure TFrmBasic.Button1Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := mtUsers.ToJSONArray;
  try
    memoDataSet.Lines.Text := LJSONArray.AsJSON;
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmBasic.btnLoadJSONArrayClick(Sender: TObject);
begin
  mtUsers.Clear(False);
  mtUsers.Close;
  mtUsers.Active := True;
  mtUsers.LoadFromJSON(memoJSONArray.Lines.Text);
end;

procedure TFrmBasic.Button3Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := mtUsers.SaveStructure;
  try
    memoDataSet.Lines.Text := LJSONArray.AsJSON;
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmBasic.Button4Click(Sender: TObject);
var
  LJSONObject: TJSONObject;
begin
  LJSONObject := mtUsers.ToJSONObject;
  try
    memoDataSet.Lines.Text := LJSONObject.AsJSON;
  finally
    LJSONObject.Free;
  end;
end;

procedure TFrmBasic.Button5Click(Sender: TObject);
begin
  if not mtUsers.Active then
    mtUsers.Active := True;
  mtUsers.LoadFromJSON(memoJSONObject.Lines.Text);
end;

procedure TFrmBasic.Button6Click(Sender: TObject);
begin
  if not mtUsers.Active then
    mtUsers.Active := True;
  if not(mtUsers.Active) or mtUsers.IsEmpty then
    ShowMessage('No selected user to merge!')
  else
    mtUsers.MergeFromJSONObject(memoMerge.Lines.Text);
end;

procedure TFrmBasic.Button7Click(Sender: TObject);
var
  LField: TField;
begin
  mtEmpty.LoadFromJSON(memoEmpty.Lines.Text);
  for LField in mtEmpty.Fields do
    mmDataType.Lines.Add(Format('Field: %s - %s', [LField.FieldName, GetEnumName(System.TypeInfo(TFieldType), Ord(LField.DataType))]));
end;

end.

