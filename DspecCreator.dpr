program DspecCreator;

{$R *.dres}

uses
  Vcl.Forms,
  DPM.Creator.MainForm in 'DPM.Creator.MainForm.pas' {DSpecCreatorForm},
  DPM.Creator.Dspec.FileHandler in 'DPM.Creator.Dspec.FileHandler.pas',
  DPM.Creator.Dspec.Replacer in 'DPM.Creator.Dspec.Replacer.pas',
  DPM.Creator.TemplateForm in 'DPM.Creator.TemplateForm.pas' {TemplateForm},
  DPM.Creator.FileForm in 'DPM.Creator.FileForm.pas' {SourceForm},
  DPM.Creator.RuntimeForm in 'DPM.Creator.RuntimeForm.pas' {BplForm},
  DPM.Creator.SearchPathForm in 'DPM.Creator.SearchPathForm.pas' {SearchPathForm},
  DPM.Creator.OptionsForm in 'DPM.Creator.OptionsForm.pas' {OptionsForm},
  DPM.Creator.DependencyForm in 'DPM.Creator.DependencyForm.pas' {DependencyForm},
  DPM.Core.Types in 'Libs\DPM\Source\Core\DPM.Core.Types.pas',
  DPM.Core.TargetPlatform in 'Libs\DPM\Source\Core\DPM.Core.TargetPlatform.pas',
  DPM.Core.Init in 'Libs\DPM\Source\Core\DPM.Core.Init.pas',
  DPM.Core.Constants in 'Libs\DPM\Source\Core\DPM.Core.Constants.pas',
  DPM.Core.Cache.Interfaces in 'Libs\DPM\Source\Core\Cache\DPM.Core.Cache.Interfaces.pas',
  DPM.Core.Cache in 'Libs\DPM\Source\Core\Cache\DPM.Core.Cache.pas',
  DPM.Core.Compiler.EnvironmentProvider in 'Libs\DPM\Source\Core\Compiler\DPM.Core.Compiler.EnvironmentProvider.pas',
  DPM.Core.Compiler.Factory in 'Libs\DPM\Source\Core\Compiler\DPM.Core.Compiler.Factory.pas',
  DPM.Core.Compiler.Interfaces in 'Libs\DPM\Source\Core\Compiler\DPM.Core.Compiler.Interfaces.pas',
  DPM.Core.Compiler.MSBuild in 'Libs\DPM\Source\Core\Compiler\DPM.Core.Compiler.MSBuild.pas',
  DPM.Core.Configuration.Classes in 'Libs\DPM\Source\Core\Configuration\DPM.Core.Configuration.Classes.pas',
  DPM.Core.Configuration.Interfaces in 'Libs\DPM\Source\Core\Configuration\DPM.Core.Configuration.Interfaces.pas',
  DPM.Core.Configuration.Manager in 'Libs\DPM\Source\Core\Configuration\DPM.Core.Configuration.Manager.pas',
  DPM.Core.Dependency.Context in 'Libs\DPM\Source\Core\Dependency\DPM.Core.Dependency.Context.pas',
  DPM.Core.Dependency.Graph in 'Libs\DPM\Source\Core\Dependency\DPM.Core.Dependency.Graph.pas',
  DPM.Core.Dependency.Interfaces in 'Libs\DPM\Source\Core\Dependency\DPM.Core.Dependency.Interfaces.pas',
  DPM.Core.Dependency.Resolution in 'Libs\DPM\Source\Core\Dependency\DPM.Core.Dependency.Resolution.pas',
  DPM.Core.Dependency.Resolver in 'Libs\DPM\Source\Core\Dependency\DPM.Core.Dependency.Resolver.pas',
  DPM.Core.Dependency.Version in 'Libs\DPM\Source\Core\Dependency\DPM.Core.Dependency.Version.pas',
  DPM.Core.Logging in 'Libs\DPM\Source\Core\Logging\DPM.Core.Logging.pas',
  DPM.Core.Options.Base in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Base.pas',
  DPM.Core.Options.Cache in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Cache.pas',
  DPM.Core.Options.Common in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Common.pas',
  DPM.Core.Options.Config in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Config.pas',
  DPM.Core.Options.Install in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Install.pas',
  DPM.Core.Options.List in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.List.pas',
  DPM.Core.Options.Pack in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Pack.pas',
  DPM.Core.Options.Push in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Push.pas',
  DPM.Core.Options.Restore in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Restore.pas',
  DPM.Core.Options.Search in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Search.pas',
  DPM.Core.Options.Sources in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Sources.pas',
  DPM.Core.Options.Spec in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Spec.pas',
  DPM.Core.Options.UnInstall in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.UnInstall.pas',
  DPM.Core.Package.Dependency in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.Dependency.pas',
  DPM.Core.Package.Installer in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.Installer.pas',
  DPM.Core.Package.InstallerContext in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.InstallerContext.pas',
  DPM.Core.Package.Interfaces in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.Interfaces.pas',
  DPM.Core.Package.Metadata in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.Metadata.pas',
  DPM.Core.Package.SearchResults in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.SearchResults.pas',
  DPM.Core.Packaging.Archive in 'Libs\DPM\Source\Core\Packaging\DPM.Core.Packaging.Archive.pas',
  DPM.Core.Packaging.Archive.Reader in 'Libs\DPM\Source\Core\Packaging\DPM.Core.Packaging.Archive.Reader.pas',
  DPM.Core.Packaging.Archive.Writer in 'Libs\DPM\Source\Core\Packaging\DPM.Core.Packaging.Archive.Writer.pas',
  DPM.Core.Packaging.IdValidator in 'Libs\DPM\Source\Core\Packaging\DPM.Core.Packaging.IdValidator.pas',
  DPM.Core.Packaging in 'Libs\DPM\Source\Core\Packaging\DPM.Core.Packaging.pas',
  DPM.Core.Packaging.Writer in 'Libs\DPM\Source\Core\Packaging\DPM.Core.Packaging.Writer.pas',
  DPM.Core.Project.Configuration in 'Libs\DPM\Source\Core\Project\DPM.Core.Project.Configuration.pas',
  DPM.Core.Project.Editor in 'Libs\DPM\Source\Core\Project\DPM.Core.Project.Editor.pas',
  DPM.Core.Project.GroupProjReader in 'Libs\DPM\Source\Core\Project\DPM.Core.Project.GroupProjReader.pas',
  DPM.Core.Project.Interfaces in 'Libs\DPM\Source\Core\Project\DPM.Core.Project.Interfaces.pas',
  DPM.Core.Repository.Base in 'Libs\DPM\Source\Core\Repository\DPM.Core.Repository.Base.pas',
  DPM.Core.Repository.Directory in 'Libs\DPM\Source\Core\Repository\DPM.Core.Repository.Directory.pas',
  DPM.Core.Repository.Factory in 'Libs\DPM\Source\Core\Repository\DPM.Core.Repository.Factory.pas',
  DPM.Core.Repository.Http in 'Libs\DPM\Source\Core\Repository\DPM.Core.Repository.Http.pas',
  DPM.Core.Repository.Interfaces in 'Libs\DPM\Source\Core\Repository\DPM.Core.Repository.Interfaces.pas',
  DPM.Core.Repository.Manager in 'Libs\DPM\Source\Core\Repository\DPM.Core.Repository.Manager.pas',
  DPM.Core.Sources.Interfaces in 'Libs\DPM\Source\Core\Sources\DPM.Core.Sources.Interfaces.pas',
  DPM.Core.Sources.Manager in 'Libs\DPM\Source\Core\Sources\DPM.Core.Sources.Manager.pas',
  DPM.Core.Sources.Types in 'Libs\DPM\Source\Core\Sources\DPM.Core.Sources.Types.pas',
  DPM.Core.Spec.BPLEntry in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.BPLEntry.pas',
  DPM.Core.Spec.BuildEntry in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.BuildEntry.pas',
  DPM.Core.Spec.Dependency in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.Dependency.pas',
  DPM.Core.Spec.DependencyGroup in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.DependencyGroup.pas',
  DPM.Core.Spec.FileEntry in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.FileEntry.pas',
  DPM.Core.Spec.Interfaces in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.Interfaces.pas',
  DPM.Core.Spec.MetaData in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.MetaData.pas',
  DPM.Core.Spec.Node in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.Node.pas',
  DPM.Core.Spec in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.pas',
  DPM.Core.Spec.Reader in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.Reader.pas',
  DPM.Core.Spec.SearchPath in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.SearchPath.pas',
  DPM.Core.Spec.SearchPathGroup in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.SearchPathGroup.pas',
  DPM.Core.Spec.TargetPlatform in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.TargetPlatform.pas',
  DPM.Core.Spec.Template in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.Template.pas',
  DPM.Core.Spec.TemplateBase in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.TemplateBase.pas',
  DPM.Core.Spec.Writer in 'Libs\DPM\Source\Core\Spec\DPM.Core.Spec.Writer.pas',
  DPM.Core.Utils.Config in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Config.pas',
  DPM.Core.Utils.Directory in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Directory.pas',
  DPM.Core.Utils.Enum in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Enum.pas',
  DPM.Core.Utils.Numbers in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Numbers.pas',
  DPM.Core.Utils.Path in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Path.pas',
  DPM.Core.Utils.Process in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Process.pas',
  DPM.Core.Utils.Strings in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Strings.pas',
  DPM.Core.Utils.System in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.System.pas',
  DPM.Core.Utils.XML in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.XML.pas',
  DPM.Core.MSXML in 'Libs\DPM\Source\Core\Xml\DPM.Core.MSXML.pas',
  DPM.Core.XML.NodeBase in 'Libs\DPM\Source\Core\Xml\DPM.Core.XML.NodeBase.pas',
  DPM.Core.Package.Icon in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.Icon.pas',
  DPM.Core.Compiler.BOM in 'Libs\DPM\Source\Core\Compiler\DPM.Core.Compiler.BOM.pas',
  DPM.Core.Compiler.ProjectSettings in 'Libs\DPM\Source\Core\Compiler\DPM.Core.Compiler.ProjectSettings.pas',
  DPM.Core.Utils.Files in 'Libs\DPM\Source\Core\Utils\DPM.Core.Utils.Files.pas',
  DPM.Core.Package.Installer.Interfaces in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.Installer.Interfaces.pas',
  DPM.Core.Options.Info in 'Libs\DPM\Source\Core\Options\DPM.Core.Options.Info.pas',
  DPM.Core.Sources.ServiceIndex in 'Libs\DPM\Source\Core\Sources\DPM.Core.Sources.ServiceIndex.pas',
  DPM.Core.Package.ListItem in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.ListItem.pas',
  DPM.Core.Package.PackageLatestVersionInfo in 'Libs\DPM\Source\Core\Package\DPM.Core.Package.PackageLatestVersionInfo.pas',
  DPM.IDE.AddInOptionsFrame in 'Libs\DPM\Source\IDE\DPM.IDE.AddInOptionsFrame.pas' {DPMOptionsFrame: TFrame},
  DPM.IDE.Options in 'Libs\DPM\Source\IDE\Options\DPM.IDE.Options.pas',
  DPM.IDE.Types in 'Libs\DPM\Source\IDE\DPM.IDE.Types.pas',
  DPM.Creator.Logger in 'DPM.Creator.Logger.pas',
  DPM.Creator.TemplateTreeNode in 'DPM.Creator.TemplateTreeNode.pas',
  DPM.Creator.FakeIDEOptions in 'DPM.Creator.FakeIDEOptions.pas',
  DPM.Creator.BuildForm in 'DPM.Creator.BuildForm.pas' {BuildForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDSpecCreatorForm, DSpecCreatorForm);
  Application.Run;
end.
