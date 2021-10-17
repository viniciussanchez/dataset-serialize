unit DataSet.Serialize.Samples.Mobile;

interface

uses
  DataSet.Serialize,

  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Layouts, FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    GridLayout1: TGridLayout;
    Button1: TButton;
    Button2: TButton;
    Layout1: TLayout;
    ListView1: TListView;
    FDMemTable1: TFDMemTable;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    FDMemTable1DESCRICAO: TStringField;
    FDMemTable1CADASTRO: TDateField;
    FDMemTable1OBSERVACAO: TStringField;
    FDMemTable1PRECO: TCurrencyField;
    procedure Layout1Painting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  FDMemTable1.Close;
  FDMemTable1.Fields.Clear;
  FDMemTable1.LoadFromJSON(Memo1.Lines.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Text := FDMemTable1.ToJSONArrayString;
end;

procedure TForm1.Layout1Painting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  GridLayout1.ItemWidth := Trunc(ClientWidth / 2);
  Memo1.Height := Trunc((ClientHeight - GridLayout1.Height) / 2);
end;

end.
