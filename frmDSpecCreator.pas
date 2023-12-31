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
  System.RegularExpressions,
  DPM.Core.Types,
  dspec.filehandler,
  dpm.dspec.format
  ;

type
  TTemplateTreeNode = class (TTreeNode)
  public
    Template: TTemplate;
    build: TBuild;
    runtime: TRuntime;
    source: TSource;
    searchpath: TSearchPath;
    function IsHeading: Boolean;
    function IsBuild: Boolean;
    function IsRuntime: Boolean;
    function IsSource: Boolean;
    function IsSearchPath: Boolean;
  end;

  TForm5 = class(TForm)
    PageControl1: TPageControl;
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
    CardPanel1: TCardPanel;
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
    lblRuntimeBuildId: TLabel;
    edtRuntimeBuildId: TEdit;
    lblRuntimeSrc: TLabel;
    edtRuntimeSrc: TEdit;
    chkCopyLocal: TCheckBox;
    PopupMenu: TPopupMenu;
    BalloonHint1: TBalloonHint;
    procedure btnAddExcludeClick(Sender: TObject);
    procedure btnAddTemplateClick(Sender: TObject);
    procedure btnDeleteTemplateClick(Sender: TObject);
    procedure cboLicenseChange(Sender: TObject);
    procedure cboTemplateChange(Sender: TObject);
    procedure chkCopyLocalClick(Sender: TObject);
    procedure clbCompilersClick(Sender: TObject);
    procedure clbCompilersClickCheck(Sender: TObject);
    procedure clbPlatformsClickCheck(Sender: TObject);
    procedure edtBuildIdChange(Sender: TObject);
    procedure edtDestChange(Sender: TObject);
    procedure edtIdChange(Sender: TObject);
    procedure edtProjectChange(Sender: TObject);
    procedure edtProjectURLChange(Sender: TObject);
    procedure edtRuntimeBuildIdClick(Sender: TObject);
    procedure edtRuntimeSrcChange(Sender: TObject);
    procedure edtSourceChange(Sender: TObject);
    procedure edtTagsChange(Sender: TObject);
    procedure edtVersionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mmoDescriptionChange(Sender: TObject);
    procedure miNewClick(Sender: TObject);
    procedure miOpenClick(Sender: TObject);
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
    procedure PopupAddSourceItem(Sender: TObject);
    procedure PopupDeleteSourceItem(Sender: TObject);
    procedure PopupAddSearchPathItem(Sender: TObject);
    procedure PopupDeleteSearchPathItem(Sender: TObject);
  private
    { Private declarations }
    FOpenFile : TDSpecFile;
    FTemplate : TTemplate;
    FMenuSource : TSource;
    FMenuRuntime : TRuntime;
    FMenuSearchPath: TSearchPath;
    FMenuBuild: TBuild;
    FSavefilename : string;
    procedure LoadTemplates;
    procedure EnableDisablePlatform(compilerVersion : TCompilerVersion);
    function ReplaceVars(inputStr: String; compiler: TCompilerVersion): string;
  public
    { Public declarations }
    procedure LoadDspecStructure;
    procedure SaveDspecStructure(const filename: string);
    function SelectedPlatform: TTargetPlatform;
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses
  System.UITypes,
  frmTemplates,
  dpm.dspec.replacer
  ;

procedure TForm5.btnAddExcludeClick(Sender: TObject);
var
  src : string;
  templateSource : TArray<TSource>;
begin
  Src := InputBox('','','');

  templateSource := FTemplate.source;

  SetLength(templateSource, length(templateSource) + 1);
  templateSource[length(templateSource) - 1] := TSource.Create;
  templateSource[length(templateSource) - 1].src := src;
  FTemplate.source := templateSource;


  LoadTemplates;
end;

procedure TForm5.btnAddTemplateClick(Sender: TObject);
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

procedure TForm5.btnDeleteTemplateClick(Sender: TObject);
var
  templateName: string;
begin
  templateName := (tvTemplates.Selected as TTemplateTreeNode).Template.name;
  FOpenFile.DeleteTemplate(templateName);
  LoadTemplates;
end;

procedure TForm5.cboLicenseChange(Sender: TObject);
begin
  FOpenFile.structure.metadata.license := cboLicense.Text;
end;

procedure TForm5.cboTemplateChange(Sender: TObject);
var
  templateName: string;
  vPlatform : TTargetPlatform;
begin
  templateName := cboTemplate.Items[cboTemplate.ItemIndex];
  if templateName = 'Create New Template...' then
  begin
    PageControl1.ActivePage := tsTemplates;
    btnAddTemplateClick(Sender);
    cboTemplate.ItemIndex := -1;
    Exit;
  end;
//  if Assigned(tvTemplates.Selected) then
//  begin
//    (tvTemplates.Selected as TTemplateTreeNode).template := FOpenFile.GetTemplate(templateName);
    vPlatform := FOpenfile.GetPlatform(clbCompilers.Items[clbCompilers.ItemIndex]);
//  end;
  if not Assigned(vPlatform) then
  begin
    vPlatform := FOpenFile.AddCompiler(clbCompilers.Items[clbCompilers.ItemIndex]);
  end;
  vPlatform.template := templateName;
  cboTemplate.ItemIndex := cboTemplate.Items.IndexOf(templateName);

end;

procedure TForm5.chkCopyLocalClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.copyLocal := chkCopyLocal.Checked;
  end;
end;

procedure TForm5.clbCompilersClick(Sender: TObject);
var
  j : Integer;
  vplatform : TTargetPlatform;
  compilerVersion : TCompilerVersion;
begin
  if clbCompilers.ItemIndex < 0 then
    Exit;

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
    cboTemplate.ItemIndex := cboTemplate.Items.IndexOf(vplatform.template);
   // Exit;
  end;

  if not Assigned(vplatform) then
    Exit;

  if vplatform.platforms.Contains('Win32') then
  begin
    j := clbPlatforms.Items.IndexOf('Win32');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.platforms.Contains('Win64') then
  begin
    j := clbPlatforms.Items.IndexOf('Win64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.platforms.Contains('Android32') then
  begin
    j := clbPlatforms.Items.IndexOf('Android');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.platforms.Contains('Android') then
  begin
    j := clbPlatforms.Items.IndexOf('Android');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.platforms.Contains('Android64') then
  begin
    j := clbPlatforms.Items.IndexOf('Android64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.platforms.Contains('iOS64') then
  begin
    j := clbPlatforms.Items.IndexOf('iOS64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;
  if vplatform.platforms.Contains('OSX64') then
  begin
    j := clbPlatforms.Items.IndexOf('OSX64');
    if j >= 0 then
      clbPlatforms.Checked[j] := j >= 0;
  end;

  cboTemplate.Clear;
  LoadTemplates;

  cboTemplate.ItemIndex := cboTemplate.Items.IndexOf(vplatform.template);
end;

procedure TForm5.clbCompilersClickCheck(Sender: TObject);
var
  vPlatform : TTargetPlatform;
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

procedure TForm5.clbPlatformsClickCheck(Sender: TObject);
var
  vPlatform : TTargetPlatform;
  compiler : string;
  platformString : string;
begin
  if clbCompilers.ItemIndex < 0 then
    Exit;
  if clbPlatforms.ItemIndex < 0 then
    Exit;


  compiler := clbCompilers.Items[clbCompilers.ItemIndex];
  vPlatform := FOpenfile.GetPlatform(compiler);

  platformString := clbPlatforms.Items[clbPlatforms.ItemIndex];

  StringToDPMPlatform(platformString);


end;

procedure TForm5.edtBuildIdChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.id := edtBuildId.Text;
  end;
end;

procedure TForm5.edtDestChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).source.dest := edtDest.Text;

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

procedure TForm5.LoadTemplates;
var
  node: TTreeNode;
  nodeSource: TTreeNode;
  nodeSearchPath: TTreeNode;
  nodeBuild: TTreeNode;
  nodeRuntime: TTreeNode;
  buildNode: TTemplateTreeNode;
  runtimeNode: TTemplateTreeNode;
  sourceNode: TTemplateTreeNode;
  searchPathNode: TTemplateTreeNode;
  i, j : Integer;
begin
  tvTemplates.Items.Clear;
  cboTemplate.Clear;
  for i := 0 to High(FOpenFile.structure.templates) do
  begin
    cboTemplate.Items.Add(FOpenFile.structure.templates[i].name);
    node := tvTemplates.Items.Add(nil, FOpenFile.structure.templates[i].name);
    (node as TTemplateTreeNode).Template := FOpenFile.structure.templates[i];
    nodeSource := tvTemplates.Items.AddChild(node, 'Source');
    (nodeSource as TTemplateTreeNode).Template := FOpenFile.structure.templates[i];
    for j := 0 to High(FOpenFile.structure.templates[i].source) do
    begin
      sourceNode := tvTemplates.Items.AddChild(nodeSource, FOpenFile.structure.templates[i].source[j].src) as TTemplateTreeNode;
      sourceNode.source := FOpenFile.structure.templates[i].source[j];
    end;
    nodeSearchPath := tvTemplates.Items.AddChild(node, 'SearchPaths');
    (nodeSearchPath as TTemplateTreeNode).Template := FOpenFile.structure.templates[i];
    for j := 0 to High(FOpenFile.structure.templates[i].searchPaths) do
    begin
      searchPathNode := tvTemplates.Items.AddChild(nodeSearchPath, FOpenFile.structure.templates[i].searchPaths[j].path) as TTemplateTreeNode;
      searchPathNode.searchpath := FOpenFile.structure.templates[i].searchPaths[j];
    end;
    nodeBuild := tvTemplates.Items.AddChild(node, 'Build');
    (nodeBuild as TTemplateTreeNode).Template := FOpenFile.structure.templates[i];
    for j := 0 to High(FOpenFile.structure.templates[i].build) do
    begin
      buildNode := tvTemplates.Items.AddChild(nodeBuild, FOpenFile.structure.templates[i].build[j].id) as TTemplateTreeNode;
      buildNode.build := FOpenFile.structure.templates[i].build[j];
    end;
    nodeRuntime := tvTemplates.Items.AddChild(node, 'Runtime');
    (nodeRuntime as TTemplateTreeNode).Template := FOpenFile.structure.templates[i];
    for j := 0 to High(FOpenFile.structure.templates[i].runtime) do
    begin
      runtimeNode := tvTemplates.Items.AddChild(nodeRuntime, FOpenFile.structure.templates[i].runtime[j].buildId) as TTemplateTreeNode;
      runtimeNode.runtime := FOpenFile.structure.templates[i].runtime[j];
    end;

    node.Expand(True);
  end;
  cboTemplate.Items.Add('Create New Template...');
end;

procedure TForm5.edtIdChange(Sender: TObject);
begin
  FOpenFile.structure.metadata.id := edtId.Text;
end;

procedure TForm5.edtProjectChange(Sender: TObject);
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

procedure TForm5.edtProjectURLChange(Sender: TObject);
begin
  FOpenFile.structure.metadata.projectUrl := edtProjectURL.Text;
end;

procedure TForm5.edtRuntimeBuildIdClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.buildId := edtRuntimeBuildId.Text;
  end;
end;

function TForm5.ReplaceVars(inputStr: String; compiler: TCompilerVersion): string;
begin
  Result := TClassReplacer.ReplaceVars(inputStr, compiler);
end;

procedure TForm5.edtRuntimeSrcChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.src := edtRuntimeSrc.Text;

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

procedure TForm5.edtSourceChange(Sender: TObject);
var
  str : string;
  compiler : TCompilerVersion;
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).source.src := edtSource.Text;

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

procedure TForm5.edtTagsChange(Sender: TObject);
begin
  FOpenFile.structure.metadata.tags := edtTags.Text;
end;

procedure TForm5.edtVersionChange(Sender: TObject);
begin
  FOpenFile.structure.metadata.version := edtVersion.Text;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  FOpenFile := TDSpecFile.Create;
  LoadDspecStructure;
  FSavefilename := '';
  Caption := 'Untitled - dspec Creator';
end;

procedure TForm5.LoadDspecStructure;
var
  i : Integer;
  j: Integer;
begin
  edtId.Text := FOpenFile.structure.metadata.id;
  edtVersion.Text := FOpenFile.structure.metadata.version;
  mmoDescription.Text := FOpenFile.structure.metadata.description;
  edtProjectURL.Text := FOpenFile.structure.metadata.projectUrl;
  edtRepositoryURL.Text := FOpenFile.structure.metadata.repositoryUrl;
  cboLicense.Text := FOpenFile.structure.metadata.license;
  edtTags.Text := FOpenFile.structure.metadata.tags;
  cboTemplate.Text := '';
  CardPanel1.Visible := False;
  for j := 0 to clbCompilers.Count - 1 do
  begin
    clbCompilers.Checked[j] := False;
  end;

  for i := 0 to High(FOpenFile.structure.targetPlatforms) do
  begin
     j := clbCompilers.Items.IndexOf(FOpenFile.structure.targetPlatforms[i].compiler);
     if j >= 0 then
       clbCompilers.Checked[j] := j >= 0;
  end;

  LoadTemplates;
end;

procedure TForm5.SaveDspecStructure(const filename: string);
begin
  FOpenFile.SaveToFile(filename);
  FSavefilename := Filename;
end;

function TForm5.SelectedPlatform: TTargetPlatform;
begin
  Result := nil;
  if clbPlatforms.ItemIndex < 0  then
    Exit;
  Result := FOpenFile.GetPlatform(clbPlatforms.Items[clbPlatforms.ItemIndex]);
end;

procedure TForm5.EnableDisablePlatform(compilerVersion : TCompilerVersion);
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


procedure TForm5.miExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm5.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
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

procedure TForm5.miNewClick(Sender: TObject);
begin
  FreeAndNil(FOpenFile);
  FOpenFile := TDSpecFile.Create;
  FSavefilename := '';
  Caption := 'Untitled - dspec Creator';
  LoadDspecStructure;
end;

procedure TForm5.miOpenClick(Sender: TObject);
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

procedure TForm5.miSaveAsClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    SaveDspecStructure(SaveDialog.Filename);
  end;
end;

procedure TForm5.miSaveClick(Sender: TObject);
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


procedure TForm5.mmoDescriptionChange(Sender: TObject);
begin
  FOpenFile.structure.metadata.description := mmoDescription.Text;
end;

procedure TForm5.PopupAddBuildItem(Sender: TObject);
var
  buildId : string;
begin
  buildId := InputBox('build id', 'Enter Build ID', 'default');
  FOpenFile.NewBuild(FTemplate.name, buildId);
  LoadTemplates;
end;

procedure TForm5.PopupAddRuntimeItem(Sender: TObject);
var
  buildId : string;
begin
  buildId := InputBox('build id', 'Enter Runtime build ID', 'default');

  FOpenFile.NewRuntime(FTemplate.name, buildId);
  LoadTemplates;
end;

procedure TForm5.PopupAddSearchPathItem(Sender: TObject);
var
  SearchPathId : string;
begin
  SearchPathId := InputBox('SearchPath', 'Enter SearchPath', 'default');
  FOpenFile.NewSearchPath(FTemplate.name, SearchPathId);
  LoadTemplates;
end;

procedure TForm5.PopupAddSourceItem(Sender: TObject);
var
  SearchPathId : string;
  source : TArray<TSource>;
begin
  SearchPathId := InputBox('Src', 'Enter Src', 'default');
  source := FTemplate.source;
  SetLength(source, length(source) + 1);
  source[High(source)] := TSource.Create;
  source[High(source)].src := SearchPathId;
  FTemplate.source := source;
  LoadTemplates;
end;

procedure TForm5.PopupDeleteBuildItem(Sender: TObject);
var
  build : TArray<TBuild>;
  buildNew : TArray<TBuild>;
  i, j: Integer;
begin
  build := FTemplate.build;
  SetLength(buildNew, Length(build) - 1);
  j := 0;
  for i := 0 to High(build) do
  begin
    if build[i].id <> FMenuBuild.id then
    begin
      buildNew[j] := build[i];
      Inc(j);
    end;
  end;
  FTemplate.build := buildNew;
  LoadTemplates;
end;

procedure TForm5.PopupDeleteRuntimeItem(Sender: TObject);
var
  runtimes : TArray<TRuntime>;
  runtimesNew : TArray<TRuntime>;
  i, j: Integer;
begin
  runtimes := FTemplate.runtime;
  SetLength(runtimesNew, Length(runtimes) - 1);
  j := 0;
  for i := 0 to High(runtimes) do
  begin
    if runtimes[i].buildId <> FMenuRuntime.buildId then
    begin
      runtimesNew[j] := runtimes[i];
      Inc(j);
    end;
  end;
  FTemplate.runtime := runtimesNew;
  LoadTemplates;
end;

procedure TForm5.PopupDeleteSearchPathItem(Sender: TObject);
var
  searchpath : TArray<TSearchPath>;
  searchpathNew : TArray<TSearchPath>;
  i, j : Integer;
begin
  searchpath := FTemplate.searchPaths;
  SetLength(searchpathNew, Length(searchpath) - 1);
  j := 0;
  for i := 0 to High(searchpath) do
  begin
    if searchpath[i].path <> FMenuSearchPath.path then
    begin
      searchpathNew[j] := searchpath[i];
      Inc(j);
    end;
  end;
  FTemplate.searchPaths := searchpathNew;
  LoadTemplates;
end;

procedure TForm5.PopupDeleteSourceItem(Sender: TObject);
var
  source : TArray<TSource>;
  sourceNew : TArray<TSource>;
  i, j : Integer;
begin
  source := FTemplate.source;
  SetLength(sourceNew, Length(source) - 1);
  j := 0;
  for i := 0 to High(source) do
  begin
    if source[i].src <> FMenuSource.src then
    begin
      sourceNew[j] := source[i];
      Inc(j);
    end;
  end;
  FTemplate.source := sourceNew;
  LoadTemplates;
end;


procedure TForm5.tvTemplatesChange(Sender: TObject; Node: TTreeNode);
begin
  if (node.Text = 'SearchPaths') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel1.ActiveCard := crdSearchPaths;
    CardPanel1.Visible := False;
  end
  else if (node.Text = 'Source') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel1.ActiveCard := crdSource;
    CardPanel1.Visible := False;
  end
  else if (Node.Text = 'Build') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel1.ActiveCard := crdBuild;
    CardPanel1.Visible := False;
  end
  else if (Node.Text = 'Runtime') and ((Node as TTemplateTreenode).IsHeading) then
  begin
    CardPanel1.ActiveCard := crdRuntime;
    CardPanel1.Visible := False;
  end
  else
  begin
    if (Node.Parent <> nil) then
    begin
      if (Node.Parent as TTemplateTreeNode).Text = 'SearchPaths' then
      begin
        CardPanel1.Visible := True;
        CardPanel1.ActiveCard := crdSearchPaths;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Source' then
      begin
        CardPanel1.Visible := True;
        CardPanel1.ActiveCard := crdSource;
        edtSource.Text := (Node as TTemplateTreeNode).source.src;
        chkFlatten.Checked := (Node as TTemplateTreeNode).source.flatten;
        edtDest.Text := (Node as TTemplateTreeNode).source.dest;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Build' then
      begin
        CardPanel1.Visible := True;
        CardPanel1.ActiveCard := crdBuild;
        edtBuildId.Text := (Node as TTemplateTreeNode).build.id;
        edtProject.Text := (Node as TTemplateTreeNode).build.project;
      end;
      if (Node.Parent as TTemplateTreeNode).Text = 'Runtime' then
      begin
        CardPanel1.Visible := True;
        CardPanel1.ActiveCard := crdRuntime;
        edtRuntimeBuildId.Text := (Node as TTemplateTreeNode).runtime.buildId;
        edtRuntimeSrc.Text := (Node as TTemplateTreeNode).runtime.src;
        chkCopyLocal.Checked := (Node as TTemplateTreeNode).runtime.copyLocal;
      end;
    end;
  end;
end;

procedure TForm5.tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := false;
end;

procedure TForm5.tvTemplatesContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  item : TMenuItem;
  localPos : TPoint;
  node : TTemplateTreeNode;
begin
  localPos := tvTemplates.ClientToScreen(MousePos);
  if Assigned(tvTemplates.Selected) then
  begin
    node := tvTemplates.Selected as TTemplateTreeNode;
    tvTemplates.PopupMenu.Items.Clear;
    node := tvTemplates.GetNodeAt(MousePos.X, MousePos.Y) as TTemplateTreeNode;

    if Assigned(node.Template) then
      FTemplate := node.Template
    else if Assigned(node.Parent) and Assigned((node.Parent as TTemplateTreeNode).Template) then
      FTemplate := (node.Parent as TTemplateTreeNode).Template
    else if Assigned(node.Parent.Parent) and Assigned((node.Parent.Parent as TTemplateTreeNode).Template) then
      FTemplate := (node.Parent.Parent as TTemplateTreeNode).Template;

    if node.IsBuild then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Build Item';
      item.OnClick := PopupAddBuildItem;
      tvTemplates.PopupMenu.Items.Add(item);

      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Build Item';
      item.OnClick := PopupDeleteBuildItem;
      tvTemplates.PopupMenu.Items.Add(item);
      FMenuBuild := (node as TTemplateTreeNode).build;
    end;
    if node.IsRuntime then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Runtime Item';
      item.OnClick := PopupAddRuntimeItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Runtime Item';
      item.OnClick := PopupDeleteRuntimeItem;
      tvTemplates.PopupMenu.Items.Add(item);
      FMenuRuntime := (node as TTemplateTreeNode).runtime;
    end;
    if node.IsSource then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add Source Item';
      item.OnClick := PopupAddSourceItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete Source Item';
      item.OnClick := PopupDeleteSourceItem;
      tvTemplates.PopupMenu.Items.Add(item);
      FMenuSource := (node as TTemplateTreeNode).source;
    end;
    if node.IsSearchPath then
    begin
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Add SearchPath Item';
      item.OnClick := PopupAddSearchPathItem;
      tvTemplates.PopupMenu.Items.Add(item);
      item := TMenuItem.Create(PopupMenu);
      item.Caption := 'Delete SearchPath Item';
      item.OnClick := PopupDeleteSearchPathItem;
      tvTemplates.PopupMenu.Items.Add(item);
      FMenuSearchPath := (node as TTemplateTreeNode).searchpath;
    end;

    tvTemplates.PopupMenu.Popup(localPos.X, localPos.Y);

    Handled := True;
  end;
end;

procedure TForm5.tvTemplatesCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
begin
  NodeClass := TTemplateTreeNode;
end;

{ TTemplateTreeNode }

function TTemplateTreeNode.IsBuild: Boolean;
begin
  Result := (build <> nil);
end;

function TTemplateTreeNode.IsHeading: Boolean;
begin
  Result := (build = nil) and (runtime = nil) and (source = nil) and (searchpath = nil);
end;

function TTemplateTreeNode.IsRuntime: Boolean;
begin
  Result := (runtime <> nil);
end;

function TTemplateTreeNode.IsSearchPath: Boolean;
begin
  Result := (searchpath <> nil);
end;

function TTemplateTreeNode.IsSource: Boolean;
begin
  Result := (source <> nil);
end;

end.
