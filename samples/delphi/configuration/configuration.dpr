program configuration;

uses
  Vcl.Forms,
  DataSet.Serialize.Samples.Configuration in 'src\DataSet.Serialize.Samples.Configuration.pas' {FrmSamples},
  DataSet.Serialize.Export in '..\..\..\src\core\DataSet.Serialize.Export.pas',
  DataSet.Serialize.Import in '..\..\..\src\core\DataSet.Serialize.Import.pas',
  DataSet.Serialize in '..\..\..\src\helpers\DataSet.Serialize.pas',
  DataSet.Serialize.Consts in '..\..\..\src\providers\DataSet.Serialize.Consts.pas',
  DataSet.Serialize.Utils in '..\..\..\src\providers\DataSet.Serialize.Utils.pas',
  DataSet.Serialize.Config in '..\..\..\src\singletons\DataSet.Serialize.Config.pas',
  DataSet.Serialize.BooleanField in '..\..\..\src\types\DataSet.Serialize.BooleanField.pas',
  DataSet.Serialize.Language in '..\..\..\src\types\DataSet.Serialize.Language.pas',
  DataSet.Serialize.UpdatedStatus in '..\..\..\src\types\DataSet.Serialize.UpdatedStatus.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmSamples, FrmSamples);
  Application.Run;
end.
