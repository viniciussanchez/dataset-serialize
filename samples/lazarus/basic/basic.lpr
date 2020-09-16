program basic;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, DataSet.Serialize.Samples.Basic,
  DataSet.Serialize.UpdatedStatus, DataSet.Serialize.Language,
  DataSet.Serialize.BooleanField, DataSet.Serialize.Import,
  DataSet.Serialize.Export, DataSet.Serialize.Config, DataSet.Serialize.Consts,
  DataSet.Serialize.Utils, DataSet.Serialize
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFrmBasic, FrmBasic);
  Application.Run;
end.

