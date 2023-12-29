program DspecCreator;

uses
  Vcl.Forms,
  frmDSpecCreator in 'frmDSpecCreator.pas' {Form5},
  dpm.dspec.format in 'dpm.dspec.format.pas',
  DPM.Core.Types in 'Libs\DPM\Source\Core\DPM.Core.Types.pas',
  DPM.Core.Utils.Strings in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Strings.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
