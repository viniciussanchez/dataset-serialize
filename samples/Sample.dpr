program Sample;

uses
  Vcl.Forms,
  DataSet.Serialize in '..\src\helpers\DataSet.Serialize.pas',
  DataSet.Serialize.BooleanField in '..\src\types\DataSet.Serialize.BooleanField.pas',
  DataSet.Serialize.Utils in '..\src\providers\DataSet.Serialize.Utils.pas',
  DataSet.Serialize.Export in '..\src\core\DataSet.Serialize.Export.pas',
  DataSet.Serialize.Import in '..\src\core\DataSet.Serialize.Import.pas',
  DataSet.Serialize.Consts in '..\src\providers\DataSet.Serialize.Consts.pas',
  DataSet.Serialize.Language in '..\src\types\DataSet.Serialize.Language.pas',
  DataSet.Serialize.Samples in 'src\DataSet.Serialize.Samples.pas' {FrmSamples},
  DataSet.Serialize.UpdatedStatus in '..\src\types\DataSet.Serialize.UpdatedStatus.pas',
  DataSet.Serialize.Config in '..\src\singletons\DataSet.Serialize.Config.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmSamples, FrmSamples);
  Application.Run;
end.
