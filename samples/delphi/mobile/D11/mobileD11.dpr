program mobileD11;

uses
  System.StartUpCopy,
  FMX.Forms,
  DataSet.Serialize.Samples.Mobile in '..\src\DataSet.Serialize.Samples.Mobile.pas' {Form1},
  DataSet.Serialize.Config in '..\..\..\..\src\DataSet.Serialize.Config.pas',
  DataSet.Serialize.Consts in '..\..\..\..\src\DataSet.Serialize.Consts.pas',
  DataSet.Serialize.Export in '..\..\..\..\src\DataSet.Serialize.Export.pas',
  DataSet.Serialize.Import in '..\..\..\..\src\DataSet.Serialize.Import.pas',
  DataSet.Serialize.Language in '..\..\..\..\src\DataSet.Serialize.Language.pas',
  DataSet.Serialize in '..\..\..\..\src\DataSet.Serialize.pas',
  DataSet.Serialize.UpdatedStatus in '..\..\..\..\src\DataSet.Serialize.UpdatedStatus.pas',
  DataSet.Serialize.Utils in '..\..\..\..\src\DataSet.Serialize.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
