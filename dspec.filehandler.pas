unit dspec.filehandler;

interface

uses
  System.JSON,
  DPM.Core.Logging,
  DPM.Core.Spec.Interfaces,
  DPM.Core.Spec.Reader,
  DPM.Core.Spec.Writer
  ;


type
  TDSpecFile = class
  private
    FLogger: ILogger;
    FReader: IPackageSpecReader;
    FFilename : string;
    FLoadedSpec : IPackageSpec;
  public
    spec : IPackageSpec;
    function NewTemplate(const templateName: string): ISpecTemplate;
    procedure DeleteTemplate(const templateName: string);
    procedure RenameTemplate(const originalName: string; const newName: string);
    function DuplicateTemplate(const sourceTemplate: ISpecTemplate; const newTemplateName: string): ISpecTemplate;
    function DoesTemplateExist(const templateName: string): Boolean;
    function GetTemplate(const templateName: string): ISpecTemplate;
    function NewSource(const templateName: string; srcPath: string): ISpecFileEntry;
    function NewFile(const templateName: string; srcPath: string): ISpecFileEntry;
    function NewLib(const templateName: string; srcPath: string): ISpecFileEntry;
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
  vplatform : ISpecTargetPlatform;
begin
  if Assigned(GetPlatform(compiler)) then
    raise Exception.Create('Platform already exists in file');

  vplatform := TSpecTargetPlatform.Create(FLogger);
  vplatform.Compiler := StringToCompilerVersion(compiler);

  spec.TargetPlatforms.Add(vplatform);
end;

function TDSpecFile.AsString: string;
begin
  Result := spec.ToJSON;
end;

constructor TDSpecFile.Create(logger: ILogger);
begin
  FLogger := logger;
  spec := TSpec.Create(FLogger, '');
  FLoadedSpec := TSpec.Create(FLogger, '');
end;

procedure TDSpecFile.DeleteTemplate(const templateName: string);
begin
  spec.DeleteTemplate(templateName);
end;

procedure TDSpecFile.DeleteCompiler(const compiler: string);
var
  i : Integer;
begin
  for i := 0 to spec.TargetPlatforms.Count - 1 do
  begin
    if SameText(CompilerToString(spec.TargetPlatforms[i].compiler), compiler) then
    begin
      spec.TargetPlatforms.Delete(i);
      Exit;
    end;
  end;
end;


destructor TDSpecFile.Destroy;
begin
  inherited;
end;

function TDSpecFile.DoesTemplateExist(const templateName: string): Boolean;
var
  i : Integer;
begin
  Result := Assigned(spec.FindTemplate(templateName));
end;

function TDSpecFile.DuplicateTemplate(const sourceTemplate: ISpecTemplate; const newTemplateName: string): ISpecTemplate;
begin
  Result := spec.DuplicateTemplate(sourceTemplate, NewTemplateName);
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
begin
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

function TDSpecFile.NewFile(const templateName: string; srcPath: string): ISpecFileEntry;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if srcPath.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  Result := template.NewFiles(srcPath);
end;

function TDSpecFile.NewLib(const templateName: string; srcPath: string): ISpecFileEntry;
var
  template : ISpecTemplate;
begin
  Result := nil;
  if srcPath.IsEmpty then
    Exit;
  if not DoesTemplateExist(templateName) then
    raise Exception.Create('Template does not exist');

  template := GetTemplate(templateName);

  Result := template.NewLib(srcPath);
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
  Result := not SameText(spec.ToJSON, FLoadedSpec.ToJSON);
end;

procedure TDSpecFile.LoadFromFile(const filename: string);
begin
  FReader := TPackageSpecReader.Create(FLogger);
  spec := FReader.ReadSpec(filename);
  FLoadedSpec := FReader.ReadSpec(filename);
  FFilename := Filename;
end;

procedure TDSpecFile.SaveToFile(const filename: string);
var
  writer : TPackageSpecWriter;
begin
  writer := TPackageSpecWriter.Create(FLogger, spec);
  writer.SaveToFile(filename);
end;

function TDSpecFile.WorkingDir: string;
begin
  Result := TPath.GetDirectoryName(FFilename);
end;

end.
