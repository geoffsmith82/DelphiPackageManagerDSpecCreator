unit frmDSpecCreator;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.CheckLst,
  Vcl.Menus,
  Vcl.WinXPanels,
  Vcl.ExtCtrls,
  System.ImageList,
  Vcl.ImgList,
  System.RegularExpressions,
  Spring.Collections,
  DosCommand,
  DPM.Core.Types,
  DPM.Core.Logging,
  DPM.Core.Spec.Interfaces,
  DPM.Creator.TemplateTreeNode,
  dspec.filehandler
  ;

type
  TDSpecCreatorForm = class(TForm)
    PageControl: TPageControl;
    tsInfo: TTabSheet;
    edtId: TEdit;
    lblId: TLabel;
    lblVersion: TLabel;
    edtVersion: TEdit;
    mmoDescription: TMemo;
    lblDescription: TLabel;
    lblProjectURL: TLabel;
    edtProjectURL: TEdit;
    lblRepositoryURL: TLabel;
    edtRepositoryURL: TEdit;
    lblLicense: TLabel;
    cboLicense: TComboBox;
    tsPlatforms: TTabSheet;
    lblTags: TLabel;
    edtTags: TEdit;
    clbCompilers: TCheckListBox;
    tsTemplates: TTabSheet;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    miNew: TMenuItem;
    miOpen: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    miPrint: TMenuItem;
    miPrintSetup: TMenuItem;
    miExit: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    cboTemplate: TComboBox;
    clbPlatforms: TCheckListBox;
    lblTemplate: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    btnAddTemplate: TButton;
    btnDeleteTemplate: TButton;
    tvTemplates: TTreeView;
    CardPanel: TCardPanel;
    crdSource: TCard;
    crdSearchPaths: TCard;
    lblSrc: TLabel;
    edtSource: TEdit;
    chkFlatten: TCheckBox;
    lblDest: TLabel;
    edtDest: TEdit;
    lbExclude: TListBox;
    btnAddExclude: TButton;
    btnDeleteExclude: TButton;
    crdBuild: TCard;
    crdRuntime: TCard;
    lblSearchPaths: TLabel;
    lblRuntime: TLabel;
    lblBuild: TLabel;
    lblBuildId: TLabel;
    edtBuildId: TEdit;
    lblProject: TLabel;
    edtProject: TEdit;
    lblRuntimeSrc: TLabel;
    edtRuntimeSrc: TEdit;
    lblRuntimeBuildId: TLabel;
    edtRuntimeBuildId: TEdit;
    chkCopyLocal: TCheckBox;
    PopupMenu: TPopupMenu;
    BalloonHint1: TBalloonHint;
    tsGenerate: TTabSheet;
    lblCompilers: TLabel;
    lblPlatform: TLabel;
    lblTemplateView: TLabel;
    edtSearchPath: TEdit;
    miOptions: TMenuItem;
    lblAuthor: TLabel;
    edtAuthor: TEdit;
    crdDependencies: TCard;
    Label1: TLabel;
    lblDependencyId: TLabel;
    edtDependencyId: TEdit;
    edtDependencyVersion: TEdit;
    ImageList1: TImageList;
    crdDesign: TCard;
    lblDesignSrc: TLabel;
    edtDesignSrc: TEdit;
    lblDesignBuildId: TLabel;
    edtDesignBuildId: TEdit;
    chkDesignInstall: TCheckBox;
    GridPanel1: TGridPanel;
    Panel1: TPanel;
    btnBuildPackages: TButton;
    Memo1: TMemo;
    edtPackageOutputPath: TEdit;
    Label2: TLabel;
    edtConfiguration: TEdit;
    lblConfiguration: TLabel;
    chkBuildForDesign: TCheckBox;
    chkDesignOnly: TCheckBox;
    btnDuplicateTemplate: TButton;
    crdTemplates: TCard;
    edtTemplateName: TEdit;
    lblTemplateName: TLabel;
    tsLogging: TTabSheet;
    Memo2: TMemo;
    procedure FormDestroy(Sender: TObject);
    procedure btnAddExcludeClick(Sender: TObject);
    procedure btnAddTemplateClick(Sender: TObject);
    procedure btnBuildPackagesClick(Sender: TObject);
    procedure btnDeleteExcludeClick(Sender: TObject);
    procedure btnDeleteTemplateClick(Sender: TObject);
    procedure btnDuplicateTemplateClick(Sender: TObject);
    procedure cboLicenseChange(Sender: TObject);
    procedure cboTemplateChange(Sender: TObject);
    procedure chkBuildForDesignClick(Sender: TObject);
    procedure chkCopyLocalClick(Sender: TObject);
    procedure chkDesignInstallClick(Sender: TObject);
    procedure chkDesignOnlyClick(Sender: TObject);
    procedure clbCompilersClick(Sender: TObject);
    procedure clbCompilersClickCheck(Sender: TObject);
    procedure clbPlatformsClickCheck(Sender: TObject);
    procedure DosCommandNewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
    procedure DosCommandTerminated(Sender: TObject);
    procedure edtAuthorChange(Sender: TObject);
    procedure edtBuildIdChange(Sender: TObject);
    procedure edtConfigurationChange(Sender: TObject);
    procedure edtDependencyIdChange(Sender: TObject);
    procedure edtDependencyVersionChange(Sender: TObject);
    procedure edtDesignBuildIdChange(Sender: TObject);
    procedure edtDesignSrcChange(Sender: TObject);
    procedure edtDestChange(Sender: TObject);
    procedure edtIdChange(Sender: TObject);
    procedure edtProjectChange(Sender: TObject);
    procedure edtProjectURLChange(Sender: TObject);
    procedure edtRepositoryURLChange(Sender: TObject);
    procedure edtRuntimeSrcOnChange(Sender: TObject);
    procedure edtRuntimeSrcChange(Sender: TObject);
    procedure edtSearchPathChange(Sender: TObject);
    procedure edtSourceChange(Sender: TObject);
    procedure edtTagsChange(Sender: TObject);
    procedure edtTemplateNameChange(Sender: TObject);
    procedure edtVersionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mmoDescriptionChange(Sender: TObject);
    procedure miNewClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
    procedure miOptionsClick(Sender: TObject);
    procedure miSaveAsClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure tvTemplatesChange(Sender: TObject; Node: TTreeNode);
    procedure tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure tvTemplatesContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure tvTemplatesCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
    procedure PopupAddBuildItem(Sender: TObject);
    procedure PopupDeleteBuildItem(Sender: TObject);
    procedure PopupAddRuntimeItem(Sender: TObject);
    procedure PopupDeleteRuntimeItem(Sender: TObject);
    procedure PopupAddDesignItem(Sender: TObject);
    procedure PopupDeleteDesignItem(Sender: TObject);
    procedure PopupAddSourceItem(Sender: TObject);
    procedure PopupDeleteSourceItem(Sender: TObject);
    procedure PopupAddFileItem(Sender: TObject);
    procedure PopupDeleteFileItem(Sender: TObject);
    procedure PopupAddLibItem(Sender: TObject);
    procedure PopupDeleteLibItem(Sender: TObject);
    procedure PopupAddSearchPathItem(Sender: TObject);
    procedure PopupDeleteSearchPathItem(Sender: TObject);
    procedure PopupAddDependencyItem(Sender: TObject);
    procedure PopupDeleteDependencyItem(Sender: TObject);
    procedure tvTemplatesEdited(Sender: TObject; Node: TTreeNode; var S: string);
    procedure tvTemplatesEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
  private
    { Private declarations }
    FtmpFilename : string;
    FOpenFile : TDSpecFile;
    FDosCommand : TDosCommand;
    FTemplate : ISpecTemplate;
    FSavefilename : string;
    FLogger: ILogger;
    procedure LoadTemplates;
    procedure EnableDisablePlatform(compilerVersion : TCompilerVersion);
    function ReplaceVars(inputStr: String; compiler: TCompilerVersion): string;
  public
    { Public declarations }
    procedure LoadDspecStructure;
    procedure SaveDspecStructure(const filename: string);
    function SelectedPlatform: ISpecTargetPlatform;
  end;

var
  DSpecCreatorForm: TDSpecCreatorForm;

implementation

{$R *.dfm}

uses
  System.UITypes,
  System.IOUtils,
  frmTemplates,
  frmBuild,
  frmSource,
  frmRuntime,
  frmDesign,
  frmSearchPath,
  frmOptions,
  frmDependency,
  dpm.dspec.replacer,
  DPM.Core.Dependency.Version,
  DPM.Creator.Logger
  ;


procedure TDSpecCreatorForm.btnDeleteExcludeClick(Sender: TObject);
var
  exclude : string;
  itemToDelete: Integer;
  entry: ISpecFileEntry;
begin
  if lbExclude.ItemIndex < 0 then
    Exit;

  if Assigned(tvTemplates.Selected) then
  begin
    entry := (tvTemplates.Selected as TTemplateTreeNode).CommonFileEntry;
    if not Assigned(entry) then
      Exit;

    exclude := lbExclude.Items[lbExclude.ItemIndex];
    lbExclude.DeleteSelected;
    itemToDelete := entry.Exclude.IndexOf(exclude);
    entry.Exclude.Delete(itemToDelete);
  end;
end;

procedure TDSpecCreatorForm.btnAddExcludeClick(Sender: TObject);
var
  src : string;
  entry: ISpecFileEntry;
begin
  Src := InputBox('Add Exclude','Exclude to Add','');

  if Assigned(tvTemplates.Selected) then
  begin
    entry := (tvTemplates.Selected as TTemplateTreeNode).CommonFileEntry;
    if not Assigned(entry) then
      Exit;

    entry.Exclude.Add(src);
    lbExclude.Items.Add(src);
  end;
end;

procedure TDSpecCreatorForm.btnAddTemplateClick(Sender: TObject);
var
  templateName : string;
  TemplateForm: TTemplateForm;
begin
  TemplateForm := TTemplateForm.Create(nil);
  try
    if not FOpenFile.DoesTemplateExist('default') then
      TemplateForm.edtTemplate.Text := 'default';
    if TemplateForm.ShowModal =  mrCancel then
      Exit;
    templateName := TemplateForm.edtTemplate.Text;
    if templateName.IsEmpty then
      Exit;
  finally
    FreeAndNil(TemplateForm);
  end;
  FOpenfile.NewTemplate(templateName);
  LoadTemplates;
end;

procedure TDSpecCreatorForm.btnBuildPackagesClick(Sender: TObject);
var
  guid: TGUID;
begin
  guid := TGUID.NewGuid;
  FtmpFilename := FOpenFile.WorkingDir;
  FtmpFilename := TPath.Combine(FtmpFilename, guid.ToString);
  FtmpFilename := ChangeFileExt(FtmpFilename, '.dspec');
  TFile.WriteAllText(FtmpFilename, FOpenFile.AsString);
  if DirectoryExists(edtPackageOutputPath.Text) then
    FDosCommand.CommandLine := 'dpm pack ' + FtmpFilename + ' -o=' + edtPackageOutputPath.Text;
  FDosCommand.Execute;
end;


procedure TDSpecCreatorForm.DosCommandNewLine(ASender: TObject; const ANewLine: string; AOutputType: TOutputType);
begin
  if AOutputType = otEntireLine then
    Memo1.Lines.Add(ANewLine);
end;

procedure TDSpecCreatorForm.DosCommandTerminated(Sender: TObject);
begin
  TFile.Delete(FtmpFilename);
  FtmpFilename := '';
end;

procedure TDSpecCreatorForm.btnDeleteTemplateClick(Sender: TObject);
var
  templateName: string;
begin
  if not Assigned(tvTemplates.Selected) then
    raise Exception.Create('Select Template to delete');
  templateName := (tvTemplates.Selected as TTemplateTreeNode).Template.Name;
  FOpenFile.DeleteTemplate(templateName);
  LoadTemplates;
end;

procedure TDSpecCreatorForm.btnDuplicateTemplateClick(Sender: TObject);
var
  newTemplateName : string;
  sourceTemplate : ISpecTemplate;
begin
  if not Assigned(tvTemplates.Selected) then
    Exit;

  sourceTemplate := (tvTemplates.Selected as TTemplateTreeNode).Template;
  newTemplateName := sourceTemplate.name + Random(100).ToString;
  if not FOpenFile.DoesTemplateExist(newTemplateName) then
  begin
    FOpenFile.DuplicateTemplate(sourceTemplate, newTemplateName);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.cboLicenseChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.license := cboLicense.Text;
end;

procedure TDSpecCreatorForm.cboTemplateChange(Sender: TObject);
var
  templateName: string;
  vPlatform : ISpecTargetPlatform;
begin
  templateName := cboTemplate.Items[cboTemplate.ItemIndex];
  if templateName = 'Create New Template...' then
  begin
    PageControl.ActivePage := tsTemplates;
    btnAddTemplateClick(Sender);
    cboTemplate.ItemIndex := -1;
    Exit;
  end;

  if clbCompilers.ItemIndex < 0 then
    raise Exception.Create('Please select a compiler before trying to set the template');
  vPlatform := FOpenfile.GetPlatform(clbCompilers.Items[clbCompilers.ItemIndex]);

  if not Assigned(vPlatform) then
  begin
    vPlatform := FOpenFile.AddCompiler(clbCompilers.Items[clbCompilers.ItemIndex]);
  end;
  vPlatform.TemplateName := templateName;
  cboTemplate.ItemIndex := cboTemplate.Items.IndexOf(templateName);
end;

procedure TDSpecCreatorForm.chkBuildForDesignClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.buildForDesign := chkBuildForDesign.Checked;
  end;
end;

procedure TDSpecCreatorForm.chkCopyLocalClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.copyLocal := chkCopyLocal.Checked;
  end;
end;

procedure TDSpecCreatorForm.chkDesignInstallClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).design.Install := chkDesignInstall.Checked;
  end;
end;

procedure TDSpecCreatorForm.chkDesignOnlyClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.designOnly := chkDesignOnly.Checked;
  end;
end;

procedure TDSpecCreatorForm.clbCompilersClick(Sender: TObject);
var
  j : Integer;
  vplatform : ISpecTargetPlatform;
  compilerVersion : TCompilerVersion;
begin
  if clbCompilers.ItemIndex < 0 then
  begin
    cboTemplate.ItemIndex := -1;
    Exit;
  end;

  vplatform := FOpenFile.GetPlatform(clbCompilers.Items[clbCompilers.ItemIndex]);
  compilerVersion := StringToCompilerVersion(clbCompilers.Items[clbCompilers.ItemIndex]);

  EnableDisablePlatform(compilerVersion);

  if clbCompilers.Checked[clbCompilers.ItemIndex] and not Assigned(vplatform) then
  begin
    vplatform := FOpenFile.AddCompiler(clbCompilers.Items[clbCompilers.ItemIndex]);
  end;

  if Assigned(vplatform) then
  begin
    for j := 0 to clbPlatforms.Count - 1 do
    begin
      clbPlatforms.Checked[j] := False;
    end;
    cboTemplate.ItemIndex := cboTemplate.Items.IndexOf(vplatform.TemplateName);
   // Exit;
  end;

  if not Assigned(vplatform) then
  begin
    cboTemplate.ItemIndex := -1;
    Exit;
  end;

  if vplatform.PlatformContains('Win32') then
  begin
    j := clbPlatforms.Items.IndexOf('Win32');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.PlatformContains('Win64') then
  begin
    j := clbPlatforms.Items.IndexOf('Win64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.PlatformContains('Android32') then
  begin
    j := clbPlatforms.Items.IndexOf('Android');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.PlatformContains('Android') then
  begin
    j := clbPlatforms.Items.IndexOf('Android');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.PlatformContains('Android64') then
  begin
    j := clbPlatforms.Items.IndexOf('Android64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.PlatformContains('iOS64') then
  begin
    j := clbPlatforms.Items.IndexOf('iOS64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.PlatformContains('OSX64') then
  begin
    j := clbPlatforms.Items.IndexOf('OSX64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;

  cboTemplate.Clear;
  LoadTemplates;

  cboTemplate.ItemIndex := cboTemplate.Items.IndexOf(vplatform.TemplateName);
end;

procedure TDSpecCreatorForm.clbCompilersClickCheck(Sender: TObject);
var
  vPlatform : ISpecTargetPlatform;
  compiler : string;
begin
  if clbCompilers.ItemIndex < 0 then
    Exit;
  compiler := clbCompilers.Items[clbCompilers.ItemIndex];
  vPlatform := FOpenfile.GetPlatform(compiler);
  if clbCompilers.Checked[clbCompilers.ItemIndex] and not Assigned(vPlatform) then
  begin
    vPlatform := FOpenFile.AddCompiler(compiler);
  end
  else if Assigned(vPlatform) and (clbCompilers.Checked[clbCompilers.ItemIndex] = False) then
  begin
    FOpenFile.DeleteCompiler(compiler);
  end;
end;

procedure TDSpecCreatorForm.clbPlatformsClickCheck(Sender: TObject);
var
  vPlatform : ISpecTargetPlatform;
  compiler : string;
  platformString : string;
  dpmPlatform: TDPMPlatform;
  i, j: Integer;
  platformCount: Integer;
  newPlatforms: TArray<TDPMPlatform>;
begin
  if clbCompilers.ItemIndex < 0 then
  begin
    raise Exception.Create('You must select a compiler before you can select platforms');
  end;
  if clbPlatforms.ItemIndex < 0 then
    Exit;

  compiler := clbCompilers.Items[clbCompilers.ItemIndex];
  vPlatform := FOpenfile.GetPlatform(compiler);
  platformCount := 0;
  for i := 0 to clbPlatforms.Count - 1 do
  begin
    if clbPlatforms.Checked[i] then
    begin
      platformString := clbPlatforms.Items[i];
      if platformString = 'Linux' then
        platformString := 'Linux64';
      dpmPlatform := StringToDPMPlatform(platformString);
      if dpmPlatform = TDPMPlatform.UnknownPlatform then
        continue;
      Inc(platformCount);
    end;
  end;

  SetLength(newPlatforms, platformCount);
  j := 0;
  for i := 0 to clbPlatforms.Count - 1 do
  begin
    if not clbPlatforms.Checked[i] then
      continue;
    platformString := clbPlatforms.Items[i];
    if platformString = 'Linux' then
      platformString := 'Linux64';
    dpmPlatform := StringToDPMPlatform(platformString);

    if dpmPlatform = TDPMPlatform.UnknownPlatform then
      continue;
    newPlatforms[j] := dpmPlatform;
    Inc(j);
  end;

  vPlatform.platforms := newPlatforms;
end;

procedure TDSpecCreatorForm.edtAuthorChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.authors := edtAuthor.Text;
end;

procedure TDSpecCreatorForm.edtBuildIdChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.id := edtBuildId.Text;
    (tvTemplates.Selected as TTemplateTreeNode).Text := edtBuildId.Text;
  end;
end;

procedure TDSpecCreatorForm.edtConfigurationChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.Config := edtConfiguration.Text;
  end;
end;

procedure TDSpecCreatorForm.edtDependencyIdChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).dependency.id := edtDependencyId.Text;
    (tvTemplates.Selected as TTemplateTreeNode).Text := edtDependencyId.Text + ' - ' + edtDependencyVersion.Text;
  end;
end;

procedure TDSpecCreatorForm.edtDependencyVersionChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    if length(edtDependencyVersion.Text) > 0 then
    begin
      (tvTemplates.Selected as TTemplateTreeNode).dependency.version := TVersionRange.Parse(edtDependencyVersion.Text);
      (tvTemplates.Selected as TTemplateTreeNode).Text := edtDependencyId.Text + ' - ' + edtDependencyVersion.Text;
    end;
  end;
end;

procedure TDSpecCreatorForm.edtDesignSrcChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).design.Source := edtDesignSrc.Text;

    str := 'Possible Expanded Paths:' + System.sLineBreak;

    for compiler := Low(TCompilerVersion) to High(TCompilerVersion) do
    begin
      if compiler = TCompilerVersion.UnknownVersion then
        continue;
      str := str  + System.sLineBreak + ReplaceVars(edtDesignSrc.Text, compiler);
    end;
    edtDesignSrc.Hint := str;
  end;
end;

procedure TDSpecCreatorForm.edtDesignBuildIdChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).design.buildId := edtDesignBuildId.Text;
    (tvTemplates.Selected as TTemplateTreeNode).Text := edtDesignBuildId.Text;
  end;
end;

procedure TDSpecCreatorForm.edtDestChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).CommonFileEntry.Destination := edtDest.Text;

    str := 'Possible Expanded Paths:' + System.sLineBreak;

    for compiler := Low(TCompilerVersion) to High(TCompilerVersion) do
    begin
      if compiler = TCompilerVersion.UnknownVersion then
        continue;
      str := str  + System.sLineBreak + ReplaceVars(edtDest.Text, compiler);;
    end;
    edtDest.Hint := str;
  end;
end;

procedure TDSpecCreatorForm.LoadTemplates;
var
  node: TTemplateTreeNode;
  nodeSource: TTemplateTreeNode;
  nodeFile: TTemplateTreeNode;
  nodeLib: TTemplateTreeNode;
  nodeSearchPath: TTemplateTreeNode;
  nodeBuild: TTemplateTreeNode;
  nodeRuntime: TTemplateTreeNode;
  nodeDesign: TTemplateTreeNode;
  nodeDependency: TTemplateTreeNode;
  buildNode: TTemplateTreeNode;
  runtimeNode: TTemplateTreeNode;
  designNode: TTemplateTreeNode;
  sourceNode: TTemplateTreeNode;
  fileNode: TTemplateTreeNode;
  libNode: TTemplateTreeNode;
  searchPathNode: TTemplateTreeNode;
  dependencyNode: TTemplateTreeNode;
  i, j : Integer;
begin
  tvTemplates.Items.Clear;
  cboTemplate.Clear;
  for i := 0 to FOpenFile.spec.templates.Count - 1 do
  begin
    cboTemplate.Items.Add(FOpenFile.spec.templates[i].name);
    node := tvTemplates.Items.Add(nil, FOpenFile.spec.templates[i].name) as TTemplateTreeNode;
    node.Template := FOpenFile.spec.templates[i];
    node.ImageIndex := 5;
    node.SelectedIndex := 5;
    node.TemplateHeading := True;
    nodeSource := tvTemplates.Items.AddChild(node, 'Source') as TTemplateTreeNode;
    nodeSource.Template := FOpenFile.spec.templates[i];
    nodeSource.ImageIndex := 2;
    nodeSource.SelectedIndex := 2;
    for j := 0 to FOpenFile.spec.templates[i].SourceFiles.Count - 1 do
    begin
      sourceNode := tvTemplates.Items.AddChild(nodeSource, FOpenFile.spec.templates[i].SourceFiles[j].Source) as TTemplateTreeNode;
      sourceNode.source := FOpenFile.spec.templates[i].SourceFiles[j];
      sourceNode.Template := FOpenFile.spec.templates[i];
      sourceNode.ImageIndex := 2;
      sourceNode.SelectedIndex := 2;
    end;

    nodeFile := tvTemplates.Items.AddChild(node, 'Files') as TTemplateTreeNode;
    nodeFile.Template := FOpenFile.spec.templates[i];
    nodeFile.ImageIndex := 2;
    nodeFile.SelectedIndex := 2;
    for j := 0 to FOpenFile.spec.templates[i].Files.Count - 1 do
    begin
      fileNode := tvTemplates.Items.AddChild(nodeFile, FOpenFile.spec.templates[i].Files[j].Source) as TTemplateTreeNode;
      fileNode.fileEntry := FOpenFile.spec.templates[i].Files[j];
      fileNode.Template := FOpenFile.spec.templates[i];
      fileNode.ImageIndex := 2;
      fileNode.SelectedIndex := 2;
    end;

    nodeLib := tvTemplates.Items.AddChild(node, 'Lib') as TTemplateTreeNode;
    nodeLib.Template := FOpenFile.spec.templates[i];
    nodeLib.ImageIndex := 2;
    nodeLib.SelectedIndex := 2;
    for j := 0 to FOpenFile.spec.templates[i].LibFiles.Count - 1 do
    begin
      libNode := tvTemplates.Items.AddChild(nodeLib, FOpenFile.spec.templates[i].LibFiles[j].Source) as TTemplateTreeNode;
      libNode.libEntry := FOpenFile.spec.templates[i].LibFiles[j];
      libNode.Template := FOpenFile.spec.templates[i];
      libNode.ImageIndex := 2;
      libNode.SelectedIndex := 2;
    end;


    nodeSearchPath := tvTemplates.Items.AddChild(node, 'SearchPaths') as TTemplateTreeNode;
    nodeSearchPath.Template := FOpenFile.spec.templates[i];
    nodeSearchPath.ImageIndex := 3;
    nodeSearchPath.SelectedIndex := 3;
    for j := 0 to FOpenFile.spec.templates[i].searchPaths.Count - 1 do
    begin
      searchPathNode := tvTemplates.Items.AddChild(nodeSearchPath, FOpenFile.spec.templates[i].searchPaths[j].path) as TTemplateTreeNode;
      searchPathNode.searchpath := FOpenFile.spec.templates[i].searchPaths[j];
      searchPathNode.Template := FOpenFile.spec.templates[i];
      searchPathNode.ImageIndex := 3;
      searchPathNode.SelectedIndex := 3;
    end;
    nodeBuild := tvTemplates.Items.AddChild(node, 'Build') as TTemplateTreeNode;
    nodeBuild.Template := FOpenFile.spec.templates[i];
    nodeBuild.ImageIndex := 0;
    nodeBuild.SelectedIndex := 0;
    for j := 0 to FOpenFile.spec.templates[i].BuildEntries.Count - 1 do
    begin
      buildNode := tvTemplates.Items.AddChild(nodeBuild, FOpenFile.spec.templates[i].BuildEntries[j].id) as TTemplateTreeNode;
      buildNode.build := FOpenFile.spec.templates[i].BuildEntries[j];
      buildNode.Template := FOpenFile.spec.templates[i];
      buildNode.ImageIndex := 0;
      buildNode.SelectedIndex := 0;
    end;

    nodeDesign := tvTemplates.Items.AddChild(node, 'Design') as TTemplateTreeNode;
    nodeDesign.Template := FOpenFile.spec.templates[i];
    nodeDesign.ImageIndex := 6;
    nodeDesign.SelectedIndex := 6;
    for j := 0 to FOpenFile.spec.templates[i].DesignFiles.Count - 1 do
    begin
      designNode := tvTemplates.Items.AddChild(nodeDesign, FOpenFile.spec.templates[i].BuildEntries[j].Id) as TTemplateTreeNode;
      designNode.design := FOpenFile.spec.templates[i].DesignFiles[j];
      designNode.Template := FOpenFile.spec.templates[i];
      designNode.ImageIndex := 6;
      designNode.SelectedIndex := 6;
    end;
    nodeRuntime := tvTemplates.Items.AddChild(node, 'Runtime') as TTemplateTreeNode;
    nodeRuntime.Template := FOpenFile.spec.templates[i];
    nodeRuntime.ImageIndex := 1;
    nodeRuntime.SelectedIndex := 1;
    for j := 0 to FOpenFile.spec.templates[i].RuntimeFiles.Count - 1 do
    begin
      runtimeNode := tvTemplates.Items.AddChild(nodeRuntime, FOpenFile.spec.templates[i].RuntimeFiles[j].Source) as TTemplateTreeNode;
      runtimeNode.runtime := FOpenFile.spec.templates[i].RuntimeFiles[j];
      runtimeNode.Template := FOpenFile.spec.templates[i];
      runtimeNode.ImageIndex := 1;
      runtimeNode.SelectedIndex := 1;
    end;

    nodeDependency := tvTemplates.Items.AddChild(node, 'Dependencies') as TTemplateTreeNode;
    nodeDependency.Template := FOpenFile.spec.templates[i];
    nodeDependency.ImageIndex := 4;
    nodeDependency.SelectedIndex := 4;
    for j := 0 to FOpenFile.spec.templates[i].dependencies.Count - 1 do
    begin
      dependencyNode := tvTemplates.Items.AddChild(nodeDependency, FOpenFile.spec.templates[i].dependencies[j].id) as TTemplateTreeNode;
      dependencyNode.dependency := FOpenFile.spec.templates[i].dependencies[j];
      dependencyNode.Template := FOpenFile.spec.templates[i];
      dependencyNode.ImageIndex := 4;
      dependencyNode.SelectedIndex := 4;
    end;

    node.Expand(True);
  end;
  cboTemplate.Items.Add('Create New Template...');
end;

procedure TDSpecCreatorForm.edtIdChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.id := edtId.Text;
end;

procedure TDSpecCreatorForm.edtProjectChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.project := edtProject.Text;

    str := 'Possible Expanded Paths:' + System.sLineBreak;

    for compiler := Low(TCompilerVersion) to High(TCompilerVersion) do
    begin
      if compiler = TCompilerVersion.UnknownVersion then
        continue;
      str := str  + System.sLineBreak + ReplaceVars(edtProject.Text, compiler);
    end;
    edtProject.Hint := str;
  end;
end;

procedure TDSpecCreatorForm.edtProjectURLChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.projectUrl := edtProjectURL.Text;
end;

procedure TDSpecCreatorForm.edtRepositoryURLChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.repositoryUrl := edtRepositoryURL.Text;
end;

procedure TDSpecCreatorForm.edtRuntimeSrcOnChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.Source := edtRuntimeSrc.Text;
    (tvTemplates.Selected as TTemplateTreeNode).Text := edtRuntimeSrc.Text;
  end;
end;

function TDSpecCreatorForm.ReplaceVars(inputStr: String; compiler: TCompilerVersion): string;
begin
  Result := TClassReplacer.ReplaceVars(inputStr, compiler, FOpenFile.spec);
end;

procedure TDSpecCreatorForm.edtRuntimeSrcChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.Source := edtRuntimeSrc.Text;

    str := 'Possible Expanded Paths:' + System.sLineBreak;

    for compiler := Low(TCompilerVersion) to High(TCompilerVersion) do
    begin
      if compiler = TCompilerVersion.UnknownVersion then
        continue;
      str := str  + System.sLineBreak + ReplaceVars(edtRuntimeSrc.Text, compiler);
    end;
    edtRuntimeSrc.Hint := str;
  end;
end;

procedure TDSpecCreatorForm.edtSearchPathChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).searchpath.path:= edtSearchPath.Text;
    (tvTemplates.Selected as TTemplateTreeNode).Text := edtSearchPath.Text
  end;
end;

procedure TDSpecCreatorForm.edtSourceChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).CommonFileEntry.Source := edtSource.Text;
    (tvTemplates.Selected as TTemplateTreeNode).Text := edtSource.Text;


    str := 'Possible Expanded Paths:' + System.sLineBreak;

    for compiler := Low(TCompilerVersion) to High(TCompilerVersion) do
    begin
      if compiler = TCompilerVersion.UnknownVersion then
        continue;
      str := str  + System.sLineBreak + ReplaceVars(edtSource.Text, compiler);
    end;
    edtSource.Hint := str;
  end;
end;

procedure TDSpecCreatorForm.edtTagsChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.tags := edtTags.Text;
end;

procedure TDSpecCreatorForm.edtTemplateNameChange(Sender: TObject);
var
 templateName : string;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    templateName := (tvTemplates.Selected as TTemplateTreeNode).Template.name;
    if SameText(templateName, edtTemplateName.Text) then
      exit;

    (tvTemplates.Selected as TTemplateTreeNode).Text := edtTemplateName.Text;
    FOpenFile.RenameTemplate(templateName, edtTemplateName.Text);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.edtVersionChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.version := TPackageVersion.Parse(edtVersion.Text);
end;

procedure TDSpecCreatorForm.FormCreate(Sender: TObject);
begin
  FLogger := TDSpecLogger.Create(Memo2.Lines);
  FOpenFile := TDSpecFile.Create(FLogger);
  FDosCommand := TDosCommand.Create(nil);
  FDosCommand.OnNewLine := DosCommandNewLine;
  FDosCommand.OnTerminated := DosCommandTerminated;
  LoadDspecStructure;
  FSavefilename := '';
  FtmpFilename := '';
  PageControl.ActivePage := tsInfo;
  edtDependencyVersion.Text := '';
  Caption := 'Untitled - dspec Creator';
end;

procedure TDSpecCreatorForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDosCommand);
end;

procedure TDSpecCreatorForm.LoadDspecStructure;
var
  i : Integer;
  j: Integer;
begin
  edtId.Text := FOpenFile.spec.metadata.id;
  edtVersion.Text := FOpenFile.spec.MetaData.Version.ToString;
  mmoDescription.Text := FOpenFile.spec.MetaData.Description;
  edtProjectURL.Text := FOpenFile.spec.MetaData.ProjectUrl;
  edtRepositoryURL.Text := FOpenFile.spec.MetaData.RepositoryUrl;
  edtAuthor.Text := FOpenFile.spec.MetaData.Authors;
  cboLicense.Text := FOpenFile.spec.MetaData.License;
  edtTags.Text := FOpenFile.spec.MetaData.Tags;
  cboTemplate.Text := '';

  CardPanel.Visible := False;
  for j := 0 to clbCompilers.Count - 1 do
  begin
    clbCompilers.Checked[j] := False;
  end;

  for i := 0 to FOpenFile.spec.targetPlatforms.Count - 1 do
  begin
     j := clbCompilers.Items.IndexOf(CompilerToString(FOpenFile.spec.targetPlatforms[i].compiler));
     if j >= 0 then
       clbCompilers.Checked[j] := j >= 0;
  end;

  LoadTemplates;
end;

procedure TDSpecCreatorForm.SaveDspecStructure(const filename: string);
begin
  FOpenFile.SaveToFile(filename);
  FSavefilename := Filename;
  Caption := FSavefilename + ' - dspec Creator';
end;

function TDSpecCreatorForm.SelectedPlatform: ISpecTargetPlatform;
begin
  Result := nil;
  if clbPlatforms.ItemIndex < 0  then
    Exit;
  Result := FOpenFile.GetPlatform(clbPlatforms.Items[clbPlatforms.ItemIndex]);
end;

procedure TDSpecCreatorForm.EnableDisablePlatform(compilerVersion : TCompilerVersion);
var
  DpmPlatforms : TDPMPlatforms;
  DpmPlatform: TDPMPlatform;
  platformString : string;
  i: Integer;
begin
  DpmPlatforms := AllPlatforms(compilerVersion);

  for i := 0 to clbPlatforms.Count - 1 do
  begin
    platformString := clbPlatforms.Items[i];
    if platformString.Equals('Linux') then
      platformString := 'Linux64'
    else if platformString.Equals('IOS') then
      platformString := 'iOS64';

    DpmPlatform := StringToDPMPlatform(platformString);
    clbPlatforms.ItemEnabled[i] := DpmPlatform in DpmPlatforms;
  end;
end;

procedure TDSpecCreatorForm.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TDSpecCreatorForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  UserChoice: Integer;
begin
  if FOpenFile.IsModified then
  begin
    UserChoice := MessageDlg('Do you want to save the changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
    case UserChoice of
      mrYes:
        begin
          // Call your save function here
          if not FSavefilename.IsEmpty then
          begin
            SaveDspecStructure(FSavefilename);
          end
          else
          begin
            if SaveDialog.Execute then
            begin
              SaveDspecStructure(SaveDialog.FileName);
            end
            else
            begin
              CanClose := False;
              Exit;
            end;
          end;
          CanClose := True;
        end;
      mrNo:
        begin
          // Close without saving
          CanClose := True;
        end;
      mrCancel:
        begin
          // Do not close the form
          CanClose := False;
        end;
    end;
  end
  else
    CanClose := True; // No changes were made, so it's okay to close
end;

procedure TDSpecCreatorForm.miNewClick(Sender: TObject);
begin
  FreeAndNil(FOpenFile);
  FOpenFile := TDSpecFile.Create(FLogger);
  FSavefilename := '';
  Caption := 'Untitled - dspec Creator';
  LoadDspecStructure;
end;

procedure TDSpecCreatorForm.miOpenClick(Sender: TObject);
var
  dspecFilename : string;
begin
  if OpenDialog.Execute then
  begin
    dspecFilename := OpenDialog.FileName;
    FOpenFile.LoadFromFile( dspecFilename);
    FSavefilename := dspecFilename;
    Caption := dspecFilename + ' - dspec Creator';
    LoadDspecStructure;
  end;
end;

procedure TDSpecCreatorForm.miOptionsClick(Sender: TObject);
var
  OptionsForm : TOptionsForm;
begin
  OptionsForm := TOptionsForm.Create(nil, FLogger);
  try
    OptionsForm.ShowModal;
  finally
    FreeAndNil(OptionsForm);
  end;
end;

procedure TDSpecCreatorForm.miSaveAsClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    SaveDspecStructure(SaveDialog.Filename);
  end;
end;

procedure TDSpecCreatorForm.miSaveClick(Sender: TObject);
begin
  if FSavefilename.IsEmpty then
  begin
    if SaveDialog.Execute then
    begin
      SaveDspecStructure(SaveDialog.Filename);
    end;
  end
  else
  begin
    SaveDspecStructure(FSavefilename);
  end;
end;


procedure TDSpecCreatorForm.mmoDescriptionChange(Sender: TObject);
begin
  FOpenFile.spec.metadata.description := mmoDescription.Text;
end;

procedure TDSpecCreatorForm.PopupAddBuildItem(Sender: TObject);
var
  buildId : string;
  BuildForm: TBuildForm;
  build : ISpecBuildEntry;
begin
  BuildForm := TBuildForm.Create(nil);
  try
    BuildForm.edtBuildId.Text := 'default';

    if BuildForm.ShowModal =  mrCancel then
      Exit;
    buildId := BuildForm.edtBuildId.Text;
    if buildId.IsEmpty then
      Exit;
    build := FOpenFile.NewBuild(FTemplate.name, buildId);
    build.project := BuildForm.edtProject.Text;
  finally
    FreeAndNil(BuildForm);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupAddDependencyItem(Sender: TObject);
var
  dependancyId : string;
  DependencyForm: TDependencyForm;
  dependency : ISpecDependency;
begin
  DependencyForm := TDependencyForm.Create(nil);
  try
    DependencyForm.edtDependencyId.Text := 'default';

    if DependencyForm.ShowModal =  mrCancel then
      Exit;
    dependancyId := DependencyForm.edtDependencyId.Text;
    if dependancyId.IsEmpty then
      Exit;
    dependency := FOpenFile.NewDependency(FTemplate.name, dependancyId);
    if length(DependencyForm.edtVersion.Text) > 0 then
      dependency.version := TVersionRange.Parse(DependencyForm.edtVersion.Text);
  finally
    FreeAndNil(DependencyForm);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupAddDesignItem(Sender: TObject);
var
  designBuidId : string;
  DesignForm: TDesignForm;
  design : ISpecBPLEntry;
begin
  DesignForm := TDesignForm.Create(nil);
  try
    DesignForm.edtDesignBuildId.Text := 'buildId';

    if DesignForm.ShowModal =  mrCancel then
      Exit;
    designBuidId := DesignForm.edtDesignBuildId.Text;
    if designBuidId.IsEmpty then
      Exit;
    design := FOpenFile.NewDesign(FTemplate.name, designBuidId);
    design.buildId := DesignForm.edtDesignBuildId.Text;
    design.Source := DesignForm.edtDesignSrc.Text;
    design.install := DesignForm.chkInstall.Checked;
  finally
    FreeAndNil(DesignForm);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupAddRuntimeItem(Sender: TObject);
var
  runtimeBuildId : string;
  RuntimeForm: TRuntimeForm;
  runtime : ISpecBPLEntry;
begin
  RuntimeForm := TRuntimeForm.Create(nil);
  try
    RuntimeForm.edtRuntimeBuildId.Text := 'default';

    if RuntimeForm.ShowModal =  mrCancel then
      Exit;
    runtimeBuildId := RuntimeForm.edtRuntimeBuildId.Text;
    if runtimeBuildId.IsEmpty then
      Exit;
    runtime := FOpenFile.NewRuntime(FTemplate.name, runtimeBuildId);
    runtime.Source := RuntimeForm.edtRuntimeSrc.Text;
    runtime.copyLocal := RuntimeForm.chkCopyLocal.Checked;
  finally
    FreeAndNil(RuntimeForm);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupAddSearchPathItem(Sender: TObject);
var
  searchPathStr : string;
  SearchPathForm: TSearchPathForm;
  searchPath : ISpecSearchPath;
begin
  SearchPathForm := TSearchPathForm.Create(nil);
  try
      SearchPathForm.edtSearchPath.Text := 'default';

    if SearchPathForm.ShowModal =  mrCancel then
      Exit;
    searchPathStr := SearchPathForm.edtSearchPath.Text;
    if searchPathStr.IsEmpty then
      Exit;
    searchPath := FOpenFile.NewSearchPath(FTemplate.name, searchPathStr);
  finally
    FreeAndNil(SearchPathForm);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupAddSourceItem(Sender: TObject);
var
  SourceSrc : string;
  SourceForm: TSourceForm;
  source : ISpecFileEntry;
begin
  SourceForm := TSourceForm.Create(nil);
  try
      SourceForm.edtSource.Text := 'default';

    if SourceForm.ShowModal =  mrCancel then
      Exit;
    SourceSrc := SourceForm.edtSource.Text;
    if SourceSrc.IsEmpty then
      Exit;
    source := FOpenFile.NewSource(FTemplate.name, SourceSrc);
    source.flatten := SourceForm.chkFlatten.Checked;
    source.Destination := SourceForm.edtDest.Text;
  finally
    FreeAndNil(SourceForm);
  end;
  LoadTemplates;
end;


procedure TDSpecCreatorForm.PopupAddFileItem(Sender: TObject);
var
  SourceSrc : string;
  FileForm: TSourceForm;
  FileEntry : ISpecFileEntry;
begin
  FileForm := TSourceForm.Create(nil);
  try
      FileForm.edtSource.Text := 'default';

    if FileForm.ShowModal =  mrCancel then
      Exit;
    SourceSrc := FileForm.edtSource.Text;
    if SourceSrc.IsEmpty then
      Exit;
    FileEntry := FOpenFile.NewFile(FTemplate.name, SourceSrc);
    FileEntry.flatten := FileForm.chkFlatten.Checked;
    FileEntry.Destination := FileForm.edtDest.Text;
  finally
    FreeAndNil(FileForm);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupAddLibItem(Sender: TObject);
var
  SourceSrc : string;
  LibForm: TSourceForm;
  LibEntry : ISpecFileEntry;
begin
  LibForm := TSourceForm.Create(nil);
  try
      LibForm.edtSource.Text := 'default';

    if LibForm.ShowModal =  mrCancel then
      Exit;
    SourceSrc := LibForm.edtSource.Text;
    if SourceSrc.IsEmpty then
      Exit;
    LibEntry := FOpenFile.NewLib(FTemplate.name, SourceSrc);
    LibEntry.flatten := LibForm.chkFlatten.Checked;
    LibEntry.Destination := LibForm.edtDest.Text;
  finally
    FreeAndNil(LibForm);
  end;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteBuildItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteBuild;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteDependencyItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteDependency;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteDesignItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteDesign;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteRuntimeItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteRuntime;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteSearchPathItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteSearchPath;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteSourceItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteSource;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteFileItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteFileEntry;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.PopupDeleteLibItem(Sender: TObject);
begin
  (tvTemplates.Selected as TTemplateTreeNode).DeleteLibEntry;
  LoadTemplates;
end;

procedure TDSpecCreatorForm.tvTemplatesChange(Sender: TObject; Node: TTreeNode);
begin
  if (node.Text = 'SearchPaths') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdSearchPaths;
    CardPanel.Visible := False;
  end
  else if (node.Text = 'Source') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdSource;
    CardPanel.Visible := False;
  end
  else if (node.Text = 'Files') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdSource;
    CardPanel.Visible := False;
  end
  else if (node.Text = 'Lib') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdSource;
    CardPanel.Visible := False;
  end
  else if (Node.Text = 'Build') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdBuild;
    CardPanel.Visible := False;
  end
  else if (Node.Text = 'Design') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdDesign;
    CardPanel.Visible := False;
  end
  else if (Node.Text = 'Runtime') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdRuntime;
    CardPanel.Visible := False;
  end
  else if (Node.Text = 'Dependencies') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel.ActiveCard := crdDependencies;
    CardPanel.Visible := False;
  end
  else if ((Node as TTemplateTreenode).TemplateHeading) then
  begin
    CardPanel.Visible := True;
    CardPanel.ActiveCard := crdTemplates;
    edtTemplateName.Text := (Node as TTemplateTreeNode).Template.name;
  end
  else
  begin
    if (Node.Parent <> nil) then
    begin
      if (Node.Parent as TTemplateTreeNode).Text = 'SearchPaths' then
      begin
        edtSearchPath.Text := (Node as TTemplateTreeNode).searchpath.path;
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdSearchPaths;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Source' then
      begin
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdSource;
        edtSource.Text := (Node as TTemplateTreeNode).source.Source;
        chkFlatten.Checked := (Node as TTemplateTreeNode).source.flatten;
        edtDest.Text := (Node as TTemplateTreeNode).source.Destination;
        lbExclude.Clear;
        for var j := 0 to (Node as TTemplateTreeNode).source.Exclude.Count - 1 do
        begin
          lbExclude.Items.Add((Node as TTemplateTreeNode).source.Exclude[j]);
        end;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Files' then
      begin
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdSource;
        edtSource.Text := (Node as TTemplateTreeNode).fileEntry.Source;
        chkFlatten.Checked := (Node as TTemplateTreeNode).fileEntry.flatten;
        edtDest.Text := (Node as TTemplateTreeNode).fileEntry.Destination;
        lbExclude.Clear;
        for var j := 0 to (Node as TTemplateTreeNode).fileEntry.Exclude.Count - 1 do
        begin
          lbExclude.Items.Add((Node as TTemplateTreeNode).fileEntry.Exclude[j]);
        end;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Lib' then
      begin
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdSource;
        edtSource.Text := (Node as TTemplateTreeNode).libEntry.Source;
        chkFlatten.Checked := (Node as TTemplateTreeNode).libEntry.flatten;
        edtDest.Text := (Node as TTemplateTreeNode).libEntry.Destination;
        lbExclude.Clear;
        for var j := 0 to (Node as TTemplateTreeNode).libEntry.Exclude.Count - 1 do
        begin
          lbExclude.Items.Add((Node as TTemplateTreeNode).libEntry.Exclude[j]);
        end;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Build' then
      begin
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdBuild;
        edtBuildId.Text := (Node as TTemplateTreeNode).build.id;
        edtProject.Text := (Node as TTemplateTreeNode).build.project;
        edtConfiguration.Text := (Node as TTemplateTreeNode).build.Config;
        chkBuildForDesign.Checked := (Node as TTemplateTreeNode).build.buildForDesign;
        chkDesignOnly.Checked := (Node as TTemplateTreeNode).build.DesignOnly;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Design' then
      begin
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdDesign;
        edtDesignBuildId.Text := (Node as TTemplateTreeNode).design.buildId;
        edtDesignSrc.Text := (Node as TTemplateTreeNode).design.Source;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Runtime' then
      begin
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdRuntime;
        edtRuntimeBuildId.Text := (Node as TTemplateTreeNode).runtime.buildId;
        edtRuntimeSrc.Text := (Node as TTemplateTreeNode).runtime.Source;
        chkCopyLocal.Checked := (Node as TTemplateTreeNode).runtime.copyLocal;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Dependencies' then
      begin
        CardPanel.Visible := True;
        CardPanel.ActiveCard := crdDependencies;
        edtDependencyId.Text := (Node as TTemplateTreeNode).dependency.id;
        if not (Node as TTemplateTreeNode).dependency.version.IsEmpty then
          edtDependencyVersion.Text := (Node as TTemplateTreeNode).dependency.version.ToString
        else
          edtDependencyVersion.Text := '';
      end;
    end;
  end;
end;

procedure TDSpecCreatorForm.tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := false;
end;

procedure TDSpecCreatorForm.tvTemplatesContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  item : TMenuItem;
  localPos : TPoint;
  node : TTemplateTreeNode;
begin
  localPos := tvTemplates.ClientToScreen(MousePos);
  if Assigned(tvTemplates.Selected) then
  begin
    node := tvTemplates.Selected as TTemplateTreeNode;
    if node.TemplateHeading then
    begin
      node.EditText;
      Handled := True;
    end;


    tvTemplates.PopupMenu.Items.Clear;
    node := tvTemplates.GetNodeAt(MousePos.X, MousePos.Y) as TTemplateTreeNode;

    if Assigned(node.Template) then
      FTemplate := node.Template
    else if Assigned(node.Parent) and Assigned((node.Parent as TTemplateTreeNode).Template) then
      FTemplate := (node.Parent as TTemplateTreeNode).Template
    else if Assigned(node.Parent.Parent) and Assigned((node.Parent.Parent as TTemplateTreeNode).Template) then
      FTemplate := (node.Parent.Parent as TTemplateTreeNode).Template;

    if node.IsBuild or ((node.Text='Build') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Build Item';
      item.OnClick := PopupAddBuildItem;
      tvTemplates.PopupMenu.Items.Add(item);

      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Build Item';
      item.OnClick := PopupDeleteBuildItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;
    if node.IsRuntime or ((node.Text='Runtime') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Runtime Item';
      item.OnClick := PopupAddRuntimeItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Runtime Item';
      item.OnClick := PopupDeleteRuntimeItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;
    if node.IsDesign or ((node.Text='Design') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Design Item';
      item.OnClick := PopupAddDesignItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Design Item';
      item.OnClick := PopupDeleteDesignItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;
    if node.IsDependency or ((node.Text='Dependencies') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Dependency Item';
      item.OnClick := PopupAddDependencyItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Dependency Item';
      item.OnClick := PopupDeleteDependencyItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;
    if node.IsSource or ((node.Text='Source') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Source Item';
      item.OnClick := PopupAddSourceItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Source Item';
      item.OnClick := PopupDeleteSourceItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;
    if node.IsFileEntry or ((node.Text='Files') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add File Item';
      item.OnClick := PopupAddFileItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete File Item';
      item.OnClick := PopupDeleteFileItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;
    if node.IsFileEntry or ((node.Text='Lib') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Library Item';
      item.OnClick := PopupAddLibItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Library Item';
      item.OnClick := PopupDeleteLibItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;
    if node.IsSearchPath or ((node.Text='SearchPaths') and node.IsHeading) then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add SearchPath Item';
      item.OnClick := PopupAddSearchPathItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete SearchPath Item';
      item.OnClick := PopupDeleteSearchPathItem;
      tvTemplates.PopupMenu.Items.Add(item);
    end;

    tvTemplates.PopupMenu.Popup(localPos.X, localPos.Y);

    Handled := True;
  end;
end;

procedure TDSpecCreatorForm.tvTemplatesCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
begin
  NodeClass := TTemplateTreeNode;
end;

procedure TDSpecCreatorForm.tvTemplatesEdited(Sender: TObject; Node: TTreeNode; var S: string);
begin
  FOpenFile.RenameTemplate(Node.Text, s);
  edtTemplateName.Text := s;
end;

procedure TDSpecCreatorForm.tvTemplatesEditing(Sender: TObject; Node: TTreeNode; var AllowEdit: Boolean);
begin
  AllowEdit := (Node as TTemplateTreenode).TemplateHeading;
end;

end.
