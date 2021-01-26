unit DataSet.Serialize.Samples.Configuration;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, memds, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, CheckLst, DBGrids;

type

  { TFrmSamples }

  TFrmSamples = class(TForm)
    btnApplyFormatDate: TButton;
    btnApplyFormatDateTime: TButton;
    btnApplyFormatTime: TButton;
    btnCaseNameDefinition: TButton;
    btnFormatCurrency: TButton;
    Button1: TButton;
    cbxCaseNameDefinition: TComboBox;
    chbFields: TCheckListBox;
    chkDateInputIsUTC: TCheckBox;
    chkExportChildDataSetAsJsonObject: TCheckBox;
    chkExportEmptyDataSet: TCheckBox;
    chkExportNullValues: TCheckBox;
    chkExportOnlyFieldsVisible: TCheckBox;
    chkImportOnlyFieldsVisible: TCheckBox;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    dsLog: TDataSource;
    dsUsers: TDataSource;
    edtFormatCurrency: TEdit;
    edtFormatDate: TEdit;
    edtFormatDateTime: TEdit;
    edtFormatTime: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mtUsers: TMemDataset;
    mtLog: TMemDataset;
    memoJSON: TMemo;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    procedure btnApplyFormatDateClick(Sender: TObject);
    procedure btnApplyFormatDateTimeClick(Sender: TObject);
    procedure btnApplyFormatTimeClick(Sender: TObject);
    procedure btnCaseNameDefinitionClick(Sender: TObject);
    procedure btnFormatCurrencyClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chbFieldsClick(Sender: TObject);
    procedure chkDateInputIsUTCChange(Sender: TObject);
    procedure chkExportChildDataSetAsJsonObjectChange(Sender: TObject);
    procedure chkExportEmptyDataSetChange(Sender: TObject);
    procedure chkExportNullValuesChange(Sender: TObject);
    procedure chkExportOnlyFieldsVisibleChange(Sender: TObject);
    procedure chkImportOnlyFieldsVisibleChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure LoadFields;
    procedure LoadUsers;
  end;

var
  FrmSamples: TFrmSamples;

implementation

{$R *.lfm}

{ TFrmSamples }

uses DataSet.Serialize, DataSet.Serialize.Config, fpjson;

procedure TFrmSamples.chkDateInputIsUTCChange(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.DateInputIsUTC := chkDateInputIsUTC.Checked;
end;

procedure TFrmSamples.btnApplyFormatDateClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.FormatDate := edtFormatDate.Text;
end;

procedure TFrmSamples.btnApplyFormatDateTimeClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.FormatDateTime := edtFormatDateTime.Text;
end;

procedure TFrmSamples.btnApplyFormatTimeClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.FormatTime := edtFormatTime.Text;
end;

procedure TFrmSamples.btnCaseNameDefinitionClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := TCaseNameDefinition(cbxCaseNameDefinition.ItemIndex);
end;

procedure TFrmSamples.btnFormatCurrencyClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.FormatCurrency := edtFormatCurrency.Text;
end;

procedure TFrmSamples.Button1Click(Sender: TObject);
var
  LJSONArray: TJSONArray;
begin
  LJSONArray := mtUsers.ToJSONArray;
  try
    memoJSON.Lines.Text := LJSONArray.FormatJSON();
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmSamples.chbFieldsClick(Sender: TObject);
begin
  mtUsers.FieldByName(chbFields.Items[chbFields.ItemIndex]).Visible := chbFields.Checked[chbFields.ItemIndex];
end;

procedure TFrmSamples.chkExportChildDataSetAsJsonObjectChange(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportChildDataSetAsJsonObject := chkExportChildDataSetAsJsonObject.Checked;
end;

procedure TFrmSamples.chkExportEmptyDataSetChange(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportEmptyDataSet := chkExportEmptyDataSet.Checked;
end;

procedure TFrmSamples.chkExportNullValuesChange(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportNullValues := chkExportNullValues.Checked;
end;

procedure TFrmSamples.chkExportOnlyFieldsVisibleChange(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportOnlyFieldsVisible := chkExportOnlyFieldsVisible.Checked;
end;

procedure TFrmSamples.chkImportOnlyFieldsVisibleChange(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Import.ImportOnlyFieldsVisible := chkImportOnlyFieldsVisible.Checked;
end;

procedure TFrmSamples.FormCreate(Sender: TObject);
begin
  LoadUsers;
  LoadFields;
end;

procedure TFrmSamples.LoadFields;
var
  LField: TField;
begin
  for LField in mtUsers.Fields do
  begin
    chbFields.Items.Add(LField.FieldName.ToUpper);
    chbFields.Checked[Pred(chbFields.Items.Count)] := LField.Visible;
  end;
end;

procedure TFrmSamples.LoadUsers;
begin
  if not mtUsers.Active then
    mtUsers.Open;

  if not mtLog.Active then
    mtLog.Open;

  mtUsers.AppendRecord([1, 'Mateus Vicente', '13/04/1998', 14999.99]);
  mtUsers.AppendRecord([2, 'Vinicius Sanchez', '03/08/1995', Null]);
  mtUsers.AppendRecord([3, 'Julio Senha', '04/06/1985', 27000.00]);
  mtUsers.AppendRecord([4, 'Fagner Granela', Null, 105000.00]);

  mtLog.AppendRecord([1, 1, 'Login']);
  mtLog.AppendRecord([2, 1, 'Logout']);
  mtLog.AppendRecord([3, 2, 'Login']);
  mtLog.AppendRecord([4, 2, 'Logout']);
  mtLog.AppendRecord([5, 2, 'Login']);
  mtLog.AppendRecord([6, 4, 'Login']);
end;

end.

