unit DataSet.Serialize.Samples.Configuration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, DataSet.Serialize, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.CheckLst, Vcl.Grids, Vcl.DBGrids, System.JSON;

type
  TFrmSamples = class(TForm)
    Panel9: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    chkDateInputIsUTC: TCheckBox;
    chkExportNullValues: TCheckBox;
    chkExportOnlyFieldsVisible: TCheckBox;
    edtFormatDate: TEdit;
    btnApplyFormatDate: TButton;
    edtFormatCurrency: TEdit;
    btnFormatCurrency: TButton;
    chkImportOnlyFieldsVisible: TCheckBox;
    Panel3: TPanel;
    dsUsers: TDataSource;
    mtUsers: TFDMemTable;
    mtUsersID: TIntegerField;
    mtUsersNAME: TStringField;
    mtUsersDATE_BIRTH: TDateField;
    mtUsersSALARY: TCurrencyField;
    Panel4: TPanel;
    Panel5: TPanel;
    chbFields: TCheckListBox;
    Panel6: TPanel;
    Panel7: TPanel;
    DBGrid1: TDBGrid;
    Panel8: TPanel;
    Panel10: TPanel;
    Button1: TButton;
    memoJSON: TMemo;
    chkExportEmptyDataSet: TCheckBox;
    dsLog: TDataSource;
    mtLog: TFDMemTable;
    mtLogID_USER: TIntegerField;
    mtLogID: TIntegerField;
    mtLogLOG: TStringField;
    DBGrid2: TDBGrid;
    chkExportChildDataSetAsJsonObject: TCheckBox;
    Label2: TLabel;
    cbxCaseNameDefinition: TComboBox;
    btnCaseNameDefinition: TButton;
    btnApplyFormatTime: TButton;
    edtFormatTime: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    edtFormatDateTime: TEdit;
    btnApplyFormatDateTime: TButton;
    procedure chkDateInputIsUTCClick(Sender: TObject);
    procedure chkExportNullValuesClick(Sender: TObject);
    procedure chkExportOnlyFieldsVisibleClick(Sender: TObject);
    procedure chkImportOnlyFieldsVisibleClick(Sender: TObject);
    procedure btnApplyFormatDateClick(Sender: TObject);
    procedure btnFormatCurrencyClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chbFieldsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure chkExportEmptyDataSetClick(Sender: TObject);
    procedure chkExportChildDataSetAsJsonObjectClick(Sender: TObject);
    procedure btnCaseNameDefinitionClick(Sender: TObject);
    procedure btnApplyFormatTimeClick(Sender: TObject);
    procedure btnApplyFormatDateTimeClick(Sender: TObject);
  private
    procedure LoadFields;
    procedure LoadUsers;
  end;

var
  FrmSamples: TFrmSamples;

implementation

{$R *.dfm}

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
    memoJSON.Lines.Text := {$IFDEF CompilerVersion < 33}LJSONArray.ToJSON{$ELSE}LJSONArray.Format{$ENDIF};
  finally
    LJSONArray.Free;
  end;
end;

procedure TFrmSamples.chbFieldsClick(Sender: TObject);
begin
  mtUsers.FieldByName(chbFields.Items[chbFields.ItemIndex]).Visible := chbFields.Checked[chbFields.ItemIndex];
end;

procedure TFrmSamples.chkDateInputIsUTCClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.DateInputIsUTC := chkDateInputIsUTC.Checked;
end;

procedure TFrmSamples.chkExportEmptyDataSetClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportEmptyDataSet := chkExportEmptyDataSet.Checked;
end;

procedure TFrmSamples.chkExportNullValuesClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportNullValues := chkExportNullValues.Checked;
end;

procedure TFrmSamples.chkExportOnlyFieldsVisibleClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportOnlyFieldsVisible := chkExportOnlyFieldsVisible.Checked;
end;

procedure TFrmSamples.chkExportChildDataSetAsJsonObjectClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Export.ExportChildDataSetAsJsonObject := chkExportChildDataSetAsJsonObject.Checked;
end;

procedure TFrmSamples.chkImportOnlyFieldsVisibleClick(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.Import.ImportOnlyFieldsVisible := chkImportOnlyFieldsVisible.Checked;
end;

procedure TFrmSamples.FormCreate(Sender: TObject);
begin
  LoadFields;
  LoadUsers;
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

  if FormatSettings.DateSeparator = '.' then
  begin
    mtUsers.AppendRecord([1, 'Mateus Vicente', '13.04.1998', 14999.99]);
    mtUsers.AppendRecord([2, 'Vinicius Sanchez', '03.08.1995', Null]);
    mtUsers.AppendRecord([3, 'Julio Senha', '04.06.1985', 27000.00]);
    mtUsers.AppendRecord([4, 'Fagner Granela', Null, 105000.00]);
  end
  else
  begin
    mtUsers.AppendRecord([1, 'Mateus Vicente', '13/04/1998', 14999.99]);
    mtUsers.AppendRecord([2, 'Vinicius Sanchez', '03/08/1995', Null]);
    mtUsers.AppendRecord([3, 'Julio Senha', '04/06/1985', 27000.00]);
    mtUsers.AppendRecord([4, 'Fagner Granela', Null, 105000.00]);
  end;

  mtLog.AppendRecord([1, 1, 'Login']);
  mtLog.AppendRecord([2, 1, 'Logout']);
  mtLog.AppendRecord([3, 2, 'Login']);
  mtLog.AppendRecord([4, 2, 'Logout']);
  mtLog.AppendRecord([5, 2, 'Login']);
  mtLog.AppendRecord([6, 4, 'Login']);
end;

end.
