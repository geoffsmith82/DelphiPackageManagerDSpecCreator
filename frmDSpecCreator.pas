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
    Label1: TLabel;
    edtTags: TEdit;
    clbCompilers: TCheckListBox;
    tsTemplates: TTabSheet;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Print1: TMenuItem;
    PrintSetup1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    cboTemplate: TComboBox;
    clbPlatforms: TCheckListBox;
    lblTemplate: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    btnAddTemplate: TButton;
    Button1: TButton;
    tvTemplates: TTreeView;
    CardPanel1: TCardPanel;
    crdSource: TCard;
    crdSearchPaths: TCard;
    Label2: TLabel;
    edtSource: TEdit;
    chkFlatten: TCheckBox;
    Label3: TLabel;
    edtDest: TEdit;
    lbExclude: TListBox;
    btnAddExclude: TButton;
    Button2: TButton;
    crdBuild: TCard;
    crdRuntime: TCard;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblBuildId: TLabel;
    edtBuildId: TEdit;
    Label7: TLabel;
    edtProject: TEdit;
    lblRuntimeBuildId: TLabel;
    edtRuntimeBuildId: TEdit;
    lblRuntimeSrc: TLabel;
    edtRuntimeSrc: TEdit;
    chkCopyLocal: TCheckBox;
    procedure btnAddExcludeClick(Sender: TObject);
    procedure btnAddTemplateClick(Sender: TObject);
    procedure cboLicenseChange(Sender: TObject);
    procedure clbCompilersClick(Sender: TObject);
    procedure edtIdChange(Sender: TObject);
    procedure edtProjectURLChange(Sender: TObject);
    procedure edtTagsChange(Sender: TObject);
    procedure edtVersionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mmoDescriptionChange(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure tvTemplatesChange(Sender: TObject; Node: TTreeNode);
    procedure tvTemplatesCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure tvTemplatesCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
  private
    { Private declarations }
    FLoaded: TDPMSpecFormat;
    FOpenFile : TDPMSpecFormat;
    FTemplate : TTemplate;
    FSavefilename : string;
    function GetPlatform(compiler: string): TTargetPlatform;
    function GetTemplate(templateName: string): TTemplate;
    procedure LoadTemplates;
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
  templateName := InputBox('Templates','Enter Template name','');
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
begin
  if clbCompilers.ItemIndex < 0 then
    Exit;

  vplatform := GetPlatform(clbCompilers.Items[clbCompilers.ItemIndex]);

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

procedure TForm5.edtProjectURLChange(Sender: TObject);
begin
  FOpenFile.metadata.projectUrl := edtProjectURL.Text;
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
  edtRepositoryURL.Text := '';
  cboLicense.Text := FOpenFile.metadata.license;
  edtTags.Text := FOpenFile.metadata.tags;
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


procedure TForm5.Exit1Click(Sender: TObject);
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

procedure TForm5.mmoDescriptionChange(Sender: TObject);
begin
  FOpenFile.metadata.description := mmoDescription.Text;
end;

procedure TForm5.New1Click(Sender: TObject);
begin
  FreeAndNil(FOpenFile);
  FOpenFile := TDPMSpecFormat.Create;
  FLoaded := TDPMSpecFormat.Create;
  FSavefilename := '';
  LoadDspecStructure;
end;

procedure TForm5.Open1Click(Sender: TObject);
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

procedure TForm5.SaveAs1Click(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    SaveDspecStructure(SaveDialog.Filename);
  end;
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

procedure TForm5.tvTemplatesCreateNodeClass(Sender: TCustomTreeView; var NodeClass: TTreeNodeClass);
begin
  NodeClass := TTemplateTreeNode;
end;

{ TTemplateTreeNode }

function TTemplateTreeNode.IsHeading: Boolean;
begin
  Result := (build = nil) and (runtime = nil) and (source = nil) and (searchpath = nil);
end;

end.
