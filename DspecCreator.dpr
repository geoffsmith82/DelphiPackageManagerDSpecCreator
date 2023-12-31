program DspecCreator;

uses
  Vcl.Forms,
  frmDSpecCreator in 'frmDSpecCreator.pas' {DSpecCreatorForm},
  dpm.dspec.format in 'dpm.dspec.format.pas',
  DPM.Core.Types in 'Libs\DPM\Source\Core\DPM.Core.Types.pas',
  DPM.Core.Utils.Strings in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Strings.pas',
  dspec.filehandler in 'dspec.filehandler.pas',
  dpm.dspec.replacer in 'dpm.dspec.replacer.pas',
  frmTemplates in 'frmTemplates.pas' {TemplateForm},
  frmSource in 'frmSource.pas' {SourceForm},
  frmBuild in 'frmBuild.pas' {BuildForm},
  frmRuntime in 'frmRuntime.pas' {RuntimeForm},
  frmSearchPath in 'frmSearchPath.pas' {SearchPathForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDSpecCreatorForm, DSpecCreatorForm);
  Application.Run;
end.
