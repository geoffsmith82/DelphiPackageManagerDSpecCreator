unit dspec.filehandler;

interface

uses
  System.JSON,
  DPM.Core.Logging,
  DPM.Core.Spec.Interfaces,
  DPM.Core.Spec.Reader,
  DPM.Core.Spec.Writer,
  dpm.dspec.format
  ;


type
  TDSpecFile = class
  private
    FLoaded : TDPMSpecFormat;
    FLogger: ILogger;
    FReader: IPackageSpecReader;
    FFilename : string;
    structure : TDPMSpecFormat;
  public
    spec : IPackageSpec;
    function NewTemplate(const templateName: string): ISpecTemplate;
    procedure DeleteTemplate(const templateName: string);
    procedure RenameTemplate(const originalName: string; const newName: string);
    function DuplicateTemplate(const sourceTemplate: ISpecTemplate; const newTemplateName: string): ISpecTemplate;
    function DoesTemplateExist(const templateName: string): Boolean;
    function GetTemplate(const templateName: string): ISpecTemplate;
    function NewSource(const templateName: string; srcPath: string): ISpecFileEntry;
    function NewBuild(const templateName: string; BuildId: string): ISpecBuildEntry;
    function NewDesign(const templateName, designSrc: string): ISpecBPLEntry;
    function NewDependency(const templateName: string; DependencyId: string): ISpecDependency;
    function NewRuntime(const templateName: string; const runtimeBuildId: string): ISpecBPLEntry;
    function NewSearchPath(const templateName: string; const SearchPathId: string): ISpecSearchPath;
    function GetPlatform(const compiler: string): ISpecTargetPlatform;
    function AddCompiler(const compiler: string): ISpecTargetPlatform;
    procedure DeleteCompiler(const compiler: string);
    procedure LoadFromFile(const filename: string);
    procedure SaveToFile(const filename: string);
    function WorkingDir: string;
    function IsModified: Boolean;
    function AsString: string;
    constructor Create(logger: ILogger);
    destructor Destroy; override;
  end;


implementation

uses
  System.IOUtils,
  System.Classes,
  System.SysUtils,
  System.JSON.Writers,
  REST.Json,
  DPM.Core.Spec,
  DPM.Core.Spec.Template,
  DPM.Core.Spec.TargetPlatform,
  DPM.Core.Types
  ;

{ TDSpecFile }

function TDSpecFile.AddCompiler(const compiler: string): ISpecTargetPlatform;
var
//  platforms : TArray<TTargetPlatform>;
  vplatform : ISpecTargetPlatform;
begin
  if Assigned(GetPlatform(compiler)) then
    raise Exception.Create('Platform already exists in file');
//  platforms := structure.targetPlatforms;
//  SetLength(platforms, Length(platforms) + 1);
//  platforms[High(platforms)] := TTargetPlatform.Create;
//  platforms[High(platforms)].compiler := compiler;
//  structure.targetPlatforms := platforms;
//  Result := platforms[High(platforms)];

  vplatform := TSpecTargetPlatform.Create(FLogger);
  vplatform.Compiler := StringToCompilerVersion(compiler);

  spec.TargetPlatforms.Add(vplatform);
end;

function TDSpecFile.AsString: string;
var
  json : TJSONObject;
begin
  json := TJson.ObjectToJsonObject(structure);
  try
    Result := json.Format;
  finally
    FreeAndNil(json);
  end;
end;

constructor TDSpecFile.Create(logger: ILogger);
begin
  structure := TDPMSpecFormat.Create;
  FLoaded := TDPMSpecFormat.Create;
  FLogger := logger;
  spec := TSpec.Create(FLogger, '');
end;

procedure TDSpecFile.DeleteTemplate(const templateName: string);
var
  templates : TArray<TTemplate>;
  templateNew : TArray<TTemplate>;
  i, j: Integer;
begin
  templates := structure.templates;
  SetLength(templateNew, Length(templates) - 1);
  j := 0;

  for i := 0 to High(structure.targetPlatforms) do
  begin
    if structure.targetPlatforms[i].template = templateName then
    begin
      structure.targetPlatforms[i].template := '';
    end;
  end;

  for i := 0 to High(templates) do
  begin
    if templates[i].name <> templateName then
    begin
      templateNew[j] := templates[i];
      Inc(j);
    end;
  end;

  structure.templates := templateNew;

  spec.DeleteTemplate(templateName);
end;

procedure TDSpecFile.DeleteCompiler(const compiler: string);
var
  targetPlatforms : TArray<TTargetPlatform>;
  targetPlatformsNew : TArray<TTargetPlatform>;
  i, j: Integer;
begin
  targetPlatforms := structure.targetPlatforms;
  SetLength(targetPlatformsNew, Length(targetPlatforms) - 1);
  j := 0;
  for i := 0 to High(targetPlatforms) do
  begin
    if targetPlatforms[i].compiler <> compiler then
    begin
      targetPlatformsNew[j] := targetPlatforms[i];
      Inc(j);
    end;
  end;
  structure.targetPlatforms := targetPlatformsNew;
end;


destructor TDSpecFile.Destroy;
begin
  FreeAndNil(structure);
  FreeAndNil(FLoaded);
  inherited;
end;

function TDSpecFile.DoesTemplateExist(const templateName: string): Boolean;
var
  i : Integer;
begin
  Result := False;
  for i := 0 to High(structure.templates) do
  begin
    if structure.templates[i].name = templateName then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

function TDSpecFile.DuplicateTemplate(const sourceTemplate: ISpecTemplate; const newTemplateName: string): ISpecTemplate;
var
  json : TJSONObject;
begin
  { TODO : Complete this method }

{  sourceTemplate
  Result := nil;
  json := TJson.ObjectToJsonObject(sourceTemplate);
  try
    templates := structure.templates;
    SetLength(templates, length(templates) + 1);
    templates[High(templates)] := TJson.JsonToObject<TTemplate>(json);
    if not DoesTemplateExist(newTemplateName) then
    begin
      templates[High(templates)].name := newTemplateName;
      structure.templates := templates;
    end;
    Result := templates[High(templates)];
  finally
    FreeAndNil(json);
  end; }
end;

function TDSpecFile.GetTemplate(const templateName: string): ISpecTemplate;
var
  i : Integer;
begin
  Result := nil;
  for i := 0 to spec.templates.Count - 1 do
  begin
    if spec.templates[i].name = templateName then
    begin
      Result := spec.templates[i];
      Exit;
    end;
  end;
end;

procedure TDSpecFile.RenameTemplate(const originalName: string; const newName: string);
var
  i : Integer;
begin
  if DoesTemplateExist(newName) then
    raise Exception.Create('Template already Exists');
  for i := 0 to High(structure.templates) do
  begin
    if SameText(structure.templates[i].name, originalName) then
    begin
      structure.templates[i].name := newName;
    end;
  end;

  for i := 0 to High(structure.targetPlatforms) do
  begin
    if SameText(structure.targetPlatforms[i].template, originalName) then
    begin
      structure.targetPlatforms[i].template := newName;
    end;
  end;

//
  spec.RenameTemplate(originalName, newName);
end;

function TDSpecFile.NewTemplate(const templateName: string): ISpecTemplate;
begin
  Result := nil;
  if templateName.IsEmpty then
    Exit;

  Result := spec.NewTemplate(templateName);
end;

function TDSpecFile.NewBuild(const templateName: string; BuildId: string): ISpecBuildEntry;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if BuildId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  Result := template.NewBuildEntryById(BuildId);
end;

function TDSpecFile.NewDependency(const templateName: string; DependencyId: string): ISpecDependency;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if DependencyId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);
  Result := template.NewDependencyById(DependencyId);
end;

function TDSpecFile.NewRuntime(const templateName: string; const runtimeBuildId: string): ISpecBPLEntry;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if runtimeBuildId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);
  Result := template.NewRuntimeBplBySrc(runtimeBuildId);
end;

function TDSpecFile.NewDesign(const templateName: string; const designSrc: string): ISpecBPLEntry;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if designSrc.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  Result := template.NewDesignBplBySrc(designSrc);
end;

function TDSpecFile.NewSearchPath(const templateName: string; const SearchPathId: string): ISpecSearchPath;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if SearchPathId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  Result := template.NewSearchPath(SearchPathId);
end;

function TDSpecFile.NewSource(const templateName: string; srcPath: string): ISpecFileEntry;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if srcPath.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  Result := template.NewSource(srcPath);
end;

function TDSpecFile.GetPlatform(const compiler: string): ISpecTargetPlatform;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to spec.targetPlatforms.Count - 1 do
  begin
    if spec.targetPlatforms[i].compiler = StringToCompilerVersion(compiler) then
    begin
      Result := spec.targetPlatforms[i];
      Exit;
    end;
  end;
end;

function TDSpecFile.IsModified: Boolean;
begin
  Result := TJSON.ObjectToJsonObject(structure).Format <> TJson.ObjectToJsonObject(FLoaded).Format;
end;

procedure TDSpecFile.LoadFromFile(const filename: string);
var
  json : TJSONObject;
begin
  FReader := TPackageSpecReader.Create(FLogger);
  spec := FReader.ReadSpec(filename);
  //spec.MetaData.
  json := TJSONObject.ParseJSONValue(TFile.ReadAllText(Filename)) as TJSONObject;
  try
    if not Assigned(json) then
    begin
      raise Exception.Create('Failed to load ' + filename);
    end;

//    structure := TJson.JsonToObject<TDPMSpecFormat>(json as TJSONObject);
//    FLoaded := TJson.JsonToObject<TDPMSpecFormat>(json as TJSONObject);
    FFilename := Filename;
  finally
    FreeAndNil(json);
  end;
end;

procedure TDSpecFile.SaveToFile(const filename: string);
var
  json : TJSONObject;
  writer : TPackageSpecWriter;
begin
  writer := TPackageSpecWriter.Create(FLogger, spec);
  writer.SaveToFile(filename);

  json := TJson.ObjectToJsonObject(structure);
  try
//    TFile.WriteAllText(Filename, json.Format);
    LoadFromFile(filename);
  finally
    FreeAndNil(json);
  end;
end;

function TDSpecFile.WorkingDir: string;
begin
  Result := TPath.GetDirectoryName(FFilename);
end;

end.
