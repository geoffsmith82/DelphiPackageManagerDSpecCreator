program DspecCreator;

{$R *.dres}

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
  frmSearchPath in 'frmSearchPath.pas' {SearchPathForm},
  frmOptions in 'frmOptions.pas' {OptionsForm},
  DPM.IDE.AddInOptionsFrame in 'Libs\DPM\Source\IDE\DPM.IDE.AddInOptionsFrame.pas' {DPMOptionsFrame: TFrame},
  DPM.IDE.Options in 'Libs\DPM\Source\IDE\Options\DPM.IDE.Options.pas',
  DPM.Core.Configuration.Interfaces in 'Libs\DPM\Source\Core\Configuration\DPM.Core.Configuration.Interfaces.pas',
  DPM.Core.Logging in 'Libs\DPM\Source\Core\Logging\DPM.Core.Logging.pas',
  DPM.IDE.Types in 'Libs\DPM\Source\IDE\DPM.IDE.Types.pas',
  DPM.Core.Constants in 'Libs\DPM\Source\Core\DPM.Core.Constants.pas',
  DPM.Core.Utils.System in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.System.pas',
  DPM.Core.Configuration.Classes in 'Libs\DPM\Source\Core\Configuration\DPM.Core.Configuration.Classes.pas',
  DPM.Core.Sources.Types in 'Libs\DPM\Source\Core\Sources\DPM.Core.Sources.Types.pas',
  DPM.Core.Utils.Enum in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Enum.pas',
  DPM.Core.Utils.Config in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Config.pas',
  frmDependency in 'frmDependency.pas' {DependancyForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDSpecCreatorForm, DSpecCreatorForm);
  Application.Run;
end.
