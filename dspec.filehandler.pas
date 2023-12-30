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
    procedure NewTemplate(templateName: string);
    procedure DeleteTemplate(templateName: string);
    procedure RenameTemplate(originalName: string; newName: string);
    function DoesTemplateExist(templateName: string): Boolean;
    function GetTemplate(templateName: string): TTemplate;
    procedure NewBuild(templateName: string; BuildId: string);
    procedure NewRuntime(templateName, BuildId: string);
    procedure NewSearchPath(templateName, SearchPathId: string);
    function GetPlatform(const compiler: string): TTargetPlatform;
    procedure LoadFromFile(filename: string);
    procedure SaveToFile(filename: string);
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

constructor TDSpecFile.Create;
begin
  structure := TDPMSpecFormat.Create;
  FLoaded := TDPMSpecFormat.Create;
end;

procedure TDSpecFile.DeleteTemplate(templateName: string);
var
  templates : TArray<TTemplate>;
  templateNew : TArray<TTemplate>;
  i, j: Integer;
begin
  templates := structure.templates;
  SetLength(templateNew, Length(templates) - 1);
  j := 0;
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

destructor TDSpecFile.Destroy;
begin
  FreeAndNil(structure);
  FreeAndNil(FLoaded);
  inherited;
end;

function TDSpecFile.DoesTemplateExist(templateName: string): Boolean;
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

function TDSpecFile.GetTemplate(templateName: string): TTemplate;
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

procedure TDSpecFile.LoadFromFile(filename: string);
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

procedure TDSpecFile.RenameTemplate(originalName, newName: string);
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

procedure TDSpecFile.NewTemplate(templateName: string);
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

procedure TDSpecFile.NewBuild(templateName: string; BuildId: string);
var
  builds : TArray<TBuild>;
  template : TTemplate;
begin
  if BuildId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  builds := template.build;
  SetLength(builds, length(builds) + 1);
  builds[High(builds)] := TBuild.Create;
  builds[High(builds)].id := BuildId;
  template.build := builds;
end;

procedure TDSpecFile.NewRuntime(templateName: string; BuildId: string);
var
  runtime : TArray<TRuntime>;
  template : TTemplate;
begin
  if BuildId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  runtime := template.runtime;
  SetLength(runtime, length(runtime) + 1);
  runtime[High(runtime)] := TRuntime.Create;
  runtime[High(runtime)].buildId := BuildId;
  template.runtime := runtime;
end;

procedure TDSpecFile.NewSearchPath(templateName: string; SearchPathId: string);
var
  searchPaths : TArray<TSearchPath>;
  template : TTemplate;
begin
  if SearchPathId.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  searchPaths := template.searchPaths;
  SetLength(searchPaths, length(searchPaths) + 1);
  searchPaths[High(searchPaths)] := TSearchPath.Create;
  searchPaths[High(searchPaths)].path := SearchPathId;
  template.searchPaths := searchPaths;
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

procedure TDSpecFile.SaveToFile(filename: string);
begin
  TFile.WriteAllText(Filename, TJson.ObjectToJsonObject(structure).Format);
end;

end.
