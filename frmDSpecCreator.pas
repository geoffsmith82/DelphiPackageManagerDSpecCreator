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
  Data.Bind.Components,
  Data.Bind.DBScope,
  Vcl.WinXPanels,
  Vcl.ExtCtrls,
  DPM.Core.Types,
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
    MainMenu1: TMainMenu;
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
    procedure btnAddExcludeClick(Sender: TObject);
    procedure btnAddTemplateClick(Sender: TObject);
    procedure cboLicenseChange(Sender: TObject);
    procedure chkCopyLocalClick(Sender: TObject);
    procedure clbCompilersClick(Sender: TObject);
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
    FLoaded: TDPMSpecFormat;
    FOpenFile : TDPMSpecFormat;
    FTemplate : TTemplate;
    FSavefilename : string;
    function GetPlatform(compiler: string): TTargetPlatform;
    function GetTemplate(templateName: string): TTemplate;
    procedure LoadTemplates;
    procedure EnableDisablePlatform(compilerVersion : TCompilerVersion);
    function AddBuildItem: TBuild;

  public
    { Public declarations }
    procedure LoadDspecStructure;
    procedure SaveDspecStructure(filename: string);
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

uses
  System.JSON,
  REST.Json,
  System.IOUtils,
  System.UITypes
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
  templates : TArray<TTemplate>;
begin
  templateName := InputBox('Templates', 'Enter Template name', 'default');
  if templateName.IsEmpty then
    Exit;
  templates := FOpenFile.templates;
  SetLength(templates, length(templates) + 1);
  templates[High(templates)] := TTemplate.Create;
  templates[High(templates)].name := templateName;
  FOpenFile.templates := templates;
  LoadTemplates;
end;

procedure TForm5.cboLicenseChange(Sender: TObject);
begin
  FOpenFile.metadata.license := cboLicense.Text;
end;

procedure TForm5.chkCopyLocalClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.copyLocal := chkCopyLocal.Checked;
  end;
end;

function TForm5.GetPlatform(compiler: string): TTargetPlatform;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to length(FOpenFile.targetPlatforms) - 1 do
  begin
    if FOpenFile.targetPlatforms[i].compiler = compiler then
    begin
      Result := FOpenFile.targetPlatforms[i];
      Exit;
    end;
  end;
end;

function TForm5.GetTemplate(templateName: string): TTemplate;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to length(FOpenFile.targetPlatforms) - 1 do
  begin
    if FOpenFile.templates[i].name = templateName then
    begin
      Result := FOpenFile.templates[i];
      Exit;
    end;
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

  vplatform := GetPlatform(clbCompilers.Items[clbCompilers.ItemIndex]);
  compilerVersion := StringToCompilerVersion(clbCompilers.Items[clbCompilers.ItemIndex]);

  EnableDisablePlatform(compilerVersion);

  if not Assigned(vplatform) then
    Exit;

  if not Assigned(vplatform) then
  begin
    for j := 0 to clbPlatforms.Count - 1 do
    begin
      clbPlatforms.Checked[j] := False;
    end;
    cboTemplate.ItemIndex := -1;
    Exit;
  end;

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

procedure TForm5.edtBuildIdChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.id := edtBuildId.Text;
  end;
end;

procedure TForm5.edtDestChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).source.dest := edtDest.Text;
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
  for i := 0 to High(FOpenFile.templates) do
  begin
    cboTemplate.Items.Add(FOpenFile.templates[i].name);
    node := tvTemplates.Items.Add(nil, FOpenFile.templates[i].name);
    (node as TTemplateTreeNode).Template := FOpenFile.templates[i];
    nodeSource := tvTemplates.Items.AddChild(node, 'Source');
    (nodeSource as TTemplateTreeNode).Template := FOpenFile.templates[i];
    for j := 0 to High(FOpenFile.templates[i].source) do
    begin
      sourceNode := tvTemplates.Items.AddChild(nodeSource, FOpenFile.templates[i].source[j].src) as TTemplateTreeNode;
      sourceNode.source := FOpenFile.templates[i].source[j];
    end;
    nodeSearchPath := tvTemplates.Items.AddChild(node, 'SearchPaths');
    (nodeSearchPath as TTemplateTreeNode).Template := FOpenFile.templates[i];
    for j := 0 to High(FOpenFile.templates[i].searchPaths) do
    begin
      searchPathNode := tvTemplates.Items.AddChild(nodeSearchPath, FOpenFile.templates[i].searchPaths[j].path) as TTemplateTreeNode;
      searchPathNode.searchpath := FOpenFile.templates[i].searchPaths[j];
    end;
    nodeBuild := tvTemplates.Items.AddChild(node, 'Build');
    (nodeBuild as TTemplateTreeNode).Template := FOpenFile.templates[i];
    for j := 0 to High(FOpenFile.templates[i].build) do
    begin
      buildNode := tvTemplates.Items.AddChild(nodeBuild, FOpenFile.templates[i].build[j].id) as TTemplateTreeNode;
      buildNode.build := FOpenFile.templates[i].build[j];
    end;
    nodeRuntime := tvTemplates.Items.AddChild(node, 'Runtime');
    (nodeRuntime as TTemplateTreeNode).Template := FOpenFile.templates[i];
    for j := 0 to High(FOpenFile.templates[i].runtime) do
    begin
      runtimeNode := tvTemplates.Items.AddChild(nodeRuntime, FOpenFile.templates[i].runtime[j].buildId) as TTemplateTreeNode;
      runtimeNode.runtime := FOpenFile.templates[i].runtime[j];
    end;

    node.Expand(True);
  end;
end;

procedure TForm5.edtIdChange(Sender: TObject);
begin
  FOpenFile.metadata.id := edtId.Text;
end;

procedure TForm5.edtProjectChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).build.project := edtProject.Text;
  end;
end;

procedure TForm5.edtProjectURLChange(Sender: TObject);
begin
  FOpenFile.metadata.projectUrl := edtProjectURL.Text;
end;

procedure TForm5.edtRuntimeBuildIdClick(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.buildId := edtRuntimeBuildId.Text;
  end;
end;

procedure TForm5.edtRuntimeSrcChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).runtime.src := edtRuntimeSrc.Text;
  end;
end;

procedure TForm5.edtSourceChange(Sender: TObject);
begin
  if Assigned(tvTemplates.Selected) then
  begin
    (tvTemplates.Selected as TTemplateTreeNode).source.src := edtSource.Text;
  end;
end;

procedure TForm5.edtTagsChange(Sender: TObject);
begin
  FOpenFile.metadata.tags := edtTags.Text;
end;

procedure TForm5.edtVersionChange(Sender: TObject);
begin
  FOpenFile.metadata.version := edtVersion.Text;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  FOpenFile := TDPMSpecFormat.Create;
  FLoaded := TDPMSpecFormat.Create;
  LoadDspecStructure;
  FSavefilename := '';
end;

procedure TForm5.LoadDspecStructure;
var
  i : Integer;
  j: Integer;
begin
  edtId.Text := FOpenFile.metadata.id;
  edtVersion.Text := FOpenFile.metadata.version;
  mmoDescription.Text := FOpenFile.metadata.description;
  edtProjectURL.Text := FOpenFile.metadata.projectUrl;
  edtRepositoryURL.Text := FOpenFile.metadata.repositoryUrl;
  cboLicense.Text := FOpenFile.metadata.license;
  edtTags.Text := FOpenFile.metadata.tags;
  cboTemplate.Text := '';
  CardPanel1.Visible := False;
  for j := 0 to clbCompilers.Count - 1 do
  begin
    clbCompilers.Checked[j] := False;
  end;

  for i := 0 to High(FOpenFile.targetPlatforms) do
  begin
     j := clbCompilers.Items.IndexOf(FOpenFile.targetPlatforms[i].compiler);
     if j >= 0 then
       clbCompilers.Checked[j] := j >= 0;
  end;

  LoadTemplates;
end;

procedure TForm5.SaveDspecStructure(filename: string);
begin
  TFile.WriteAllText(Filename, TJson.ObjectToJsonObject(FOpenFile).Format);
  FSavefilename := Filename;
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
  if TJson.ObjectToJsonObject(FOpenFile).Format <> TJson.ObjectToJsonObject(FLoaded).Format then
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
  FOpenFile := TDPMSpecFormat.Create;
  FLoaded := TDPMSpecFormat.Create;
  FSavefilename := '';
  LoadDspecStructure;
end;

procedure TForm5.miOpenClick(Sender: TObject);
var
  json : TJSONObject;
  dspecFilename : string;
begin
  json := nil;
  if OpenDialog.Execute then
  begin
    dspecFilename := OpenDialog.FileName;
    try
      json := TJSONObject.ParseJSONValue(TFile.ReadAllText(dspecFilename)) as TJSONObject;
      FOpenFile := TJson.JsonToObject<TDPMSpecFormat>(json as TJSONObject);
      FLoaded := TJson.JsonToObject<TDPMSpecFormat>(json as TJSONObject);
      FSavefilename := dspecFilename;
      LoadDspecStructure;
    finally
      FreeAndNil(json);
    end;
  end;
end;

procedure TForm5.miSaveAsClick(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    SaveDspecStructure(SaveDialog.Filename);
  end;
end;


procedure TForm5.mmoDescriptionChange(Sender: TObject);
begin
  FOpenFile.metadata.description := mmoDescription.Text;
end;

function TForm5.AddBuildItem: TBuild;
var
  build : TBuild;
begin

end;

procedure TForm5.PopupAddBuildItem(Sender: TObject);
var
  templateName : string;
  builds : TArray<TBuild>;
begin
  templateName := InputBox('build id', 'Enter Build ID', 'default');
  builds := FTemplate.build;
  SetLength(builds, length(builds) + 1);
  builds[High(builds)] := TBuild.Create;
  builds[High(builds)].id := templateName;
  FTemplate.build := builds;
  LoadTemplates;
end;

procedure TForm5.PopupAddRuntimeItem(Sender: TObject);
var
  buildId : string;
  runtimes : TArray<TRuntime>;
begin
  buildId := InputBox('build id', 'Enter Runtime build ID', 'default');
  runtimes := FTemplate.runtime;
  SetLength(runtimes, length(runtimes) + 1);
  runtimes[High(runtimes)] := TRuntime.Create;
  runtimes[High(runtimes)].buildId := buildId;
  FTemplate.runtime := runtimes;
  LoadTemplates;
end;

procedure TForm5.PopupAddSearchPathItem(Sender: TObject);
var
  SearchPathId : string;
  searchpath : TArray<TSearchPath>;
begin
  SearchPathId := InputBox('SearchPath', 'Enter SearchPath', 'default');
  searchpath := FTemplate.searchPaths;
  SetLength(searchpath, length(searchpath) + 1);
  searchpath[High(searchpath)] := TSearchPath.Create;
  searchpath[High(searchpath)].path := SearchPathId;
  FTemplate.searchPaths := searchpath;
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
  builds : TArray<TBuild>;
begin
//
  LoadTemplates;
end;

procedure TForm5.PopupDeleteRuntimeItem(Sender: TObject);
var
  buildId : string;
  runtimes : TArray<TRuntime>;
begin
//
  LoadTemplates;
end;

procedure TForm5.PopupDeleteSearchPathItem(Sender: TObject);
var
  SearchPathId : string;
  searchpath : TArray<TSearchPath>;
begin
//
  LoadTemplates;
end;

procedure TForm5.PopupDeleteSourceItem(Sender: TObject);
var
  SearchPathId : string;
  source : TArray<TSource>;
begin
  source := FTemplate.source;

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
