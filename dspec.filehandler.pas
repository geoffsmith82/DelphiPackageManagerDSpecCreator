unit dspec.filehandler;

interface

uses
  System.JSON,
  REST.Json,
  dpm.dspec.format
  ;


type
  TDSpecFile = class
  private
    FLoaded : TDPMSpecFormat;
  public
    structure : TDPMSpecFormat;
    procedure NewTemplate(const templateName: string);
    procedure DeleteTemplate(const templateName: string);
    procedure RenameTemplate(const originalName: string; const newName: string);
    function DoesTemplateExist(const templateName: string): Boolean;
    function GetTemplate(const templateName: string): TTemplate;
    function NewSource(const templateName: string; srcPath: string): TSource;
    function NewBuild(const templateName: string; BuildId: string): TBuild;
    function NewRuntime(const templateName: string; const BuildId: string): TRuntime;
    function NewSearchPath(const templateName: string; const SearchPathId: string): TSearchPath;
    function GetPlatform(const compiler: string): TTargetPlatform;
    function AddCompiler(const compiler: string): TTargetPlatform;
    procedure DeleteCompiler(const compiler: string);
    procedure LoadFromFile(const filename: string);
    procedure SaveToFile(const filename: string);
    function IsModified: Boolean;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

uses
  System.IOUtils,
  System.SysUtils
  ;

{ TDSpecFile }

function TDSpecFile.AddCompiler(const compiler: string): TTargetPlatform;
var
  platforms : TArray<TTargetPlatform>;
begin
  if Assigned(GetPlatform(compiler)) then
    raise Exception.Create('Platform already exists in file');
  platforms := structure.targetPlatforms;
  SetLength(platforms, Length(platforms) + 1);
  platforms[High(platforms)] := TTargetPlatform.Create;
  platforms[High(platforms)].compiler := compiler;
  structure.targetPlatforms := platforms;
  Result := platforms[High(platforms)];
end;

constructor TDSpecFile.Create;
begin
  structure := TDPMSpecFormat.Create;
  FLoaded := TDPMSpecFormat.Create;
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

function TDSpecFile.GetTemplate(const templateName: string): TTemplate;
var
  i : Integer;
begin
  Result := nil;
  for i := 0 to High(structure.templates) do
  begin
    if structure.templates[i].name = templateName then
    begin
      Result := structure.templates[i];
      Exit;
    end;
  end;
end;

function TDSpecFile.IsModified: Boolean;
begin
  Result := TJson.ObjectToJsonObject(structure).Format <> TJson.ObjectToJsonObject(FLoaded).Format;
end;

procedure TDSpecFile.LoadFromFile(const filename: string);
var
  json : TJSONObject;
begin
  json := TJSONObject.ParseJSONValue(TFile.ReadAllText(Filename)) as TJSONObject;
  try
    structure := TJson.JsonToObject<TDPMSpecFormat>(json as TJSONObject);
    FLoaded := TJson.JsonToObject<TDPMSpecFormat>(json as TJSONObject);
  finally
    FreeAndNil(json);
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
end;

procedure TDSpecFile.NewTemplate(const templateName: string);
var
  templates : TArray<TTemplate>;
begin
  if templateName.IsEmpty then
    Exit;
  templates := structure.templates;
  SetLength(templates, length(templates) + 1);
  templates[High(templates)] := TTemplate.Create;
  templates[High(templates)].name := templateName;
  structure.templates := templates;
end;

function TDSpecFile.NewBuild(const templateName: string; BuildId: string): TBuild;
var
  builds : TArray<TBuild>;
  template : TTemplate;
begin
  Result := nil;
  if BuildId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  builds := template.build;
  SetLength(builds, length(builds) + 1);
  builds[High(builds)] := TBuild.Create;
  builds[High(builds)].id := BuildId;
  Result := builds[High(builds)];
  template.build := builds;
end;

function TDSpecFile.NewRuntime(const templateName: string; const BuildId: string): TRuntime;
var
  runtime : TArray<TRuntime>;
  template : TTemplate;
begin
  Result := nil;
  if BuildId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  runtime := template.runtime;
  SetLength(runtime, length(runtime) + 1);
  runtime[High(runtime)] := TRuntime.Create;
  runtime[High(runtime)].buildId := BuildId;
  Result := runtime[High(runtime)];
  template.runtime := runtime;
end;

function TDSpecFile.NewSearchPath(const templateName: string; const SearchPathId: string): TSearchPath;
var
  searchPaths : TArray<TSearchPath>;
  template : TTemplate;
begin
  Result := nil;
  if SearchPathId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  searchPaths := template.searchPaths;
  SetLength(searchPaths, length(searchPaths) + 1);
  searchPaths[High(searchPaths)] := TSearchPath.Create;
  searchPaths[High(searchPaths)].path := SearchPathId;
  Result := searchPaths[High(searchPaths)];
  template.searchPaths := searchPaths;
end;

function TDSpecFile.NewSource(const templateName: string; srcPath: string): TSource;
var
  sources : TArray<TSource>;
  template : TTemplate;
begin
  Result := nil;
  if srcPath.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  sources := template.source;
  SetLength(sources, length(sources) + 1);
  sources[High(sources)] := TSource.Create;
  sources[High(sources)].src := srcPath;
  Result := sources[High(sources)];
  template.source := sources;
end;

function TDSpecFile.GetPlatform(const compiler: string): TTargetPlatform;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to length(structure.targetPlatforms) - 1 do
  begin
    if structure.targetPlatforms[i].compiler = compiler then
    begin
      Result := structure.targetPlatforms[i];
      Exit;
    end;
  end;
end;

procedure TDSpecFile.SaveToFile(const filename: string);
begin
  TFile.WriteAllText(Filename, TJson.ObjectToJsonObject(structure).Format);
end;

end.
