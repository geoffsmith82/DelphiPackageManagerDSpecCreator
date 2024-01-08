unit DPM.Creator.TemplateTreeNode;

interface

uses
  Vcl.ComCtrls,
  DPM.Core.Spec.Interfaces;

type
  TTemplateTreeNode = class (TTreeNode)
  public
    TemplateHeading: Boolean;
    Template: ISpecTemplate;
    build: ISpecBuildEntry;
    design: ISpecBPLEntry;
    runtime: ISpecBPLEntry;
    source: ISpecFileEntry;
    fileEntry: ISpecFileEntry;
    libEntry: ISpecFileEntry;
    searchpath: ISpecSearchPath;
    dependency: ISpecDependency;

    function CommonFileEntry: ISpecFileEntry;

    function IsHeading: Boolean;
    function IsBuild: Boolean;
    function IsDesign: Boolean;
    function IsRuntime: Boolean;
    function IsSource: Boolean;
    function IsFileEntry: Boolean;
    function IsLibEntry: Boolean;
    function IsSearchPath: Boolean;
    function IsDependency: Boolean;

    procedure DeleteBuild;
    procedure DeleteSource;
    procedure DeleteFileEntry;
    procedure DeleteLibEntry;
    procedure DeleteDesign;
    procedure DeleteRuntime;
    procedure DeleteSearchPath;
    procedure DeleteDependency;

  end;

implementation

{ TTemplateTreeNode }

function TTemplateTreeNode.CommonFileEntry: ISpecFileEntry;
begin
  if IsSource then
    Result := source
  else if IsFileEntry then
    Result := fileEntry
  else if IsLibEntry then
    Result := libEntry
  else
    Result := nil;

end;

procedure TTemplateTreeNode.DeleteBuild;
begin
  Template.DeleteBuildEntryById(Build.Id);
end;

procedure TTemplateTreeNode.DeleteDependency;
begin
  Template.DeleteDependencyById(dependency.Id);
end;

procedure TTemplateTreeNode.DeleteDesign;
begin
  Template.DeleteDesignBplBySrc(design.Source);
end;

procedure TTemplateTreeNode.DeleteFileEntry;
begin
  Template.DeleteFiles(fileEntry.Source);
end;

procedure TTemplateTreeNode.DeleteLibEntry;
begin
  Template.DeleteLib(LibEntry.Source);
end;

procedure TTemplateTreeNode.DeleteRuntime;
begin
  Template.DeleteRuntimeBplBySrc(runtime.Source);
end;

procedure TTemplateTreeNode.DeleteSearchPath;
begin
  Template.DeleteSearchPath(searchpath.Path);
end;

procedure TTemplateTreeNode.DeleteSource;
begin
  Template.DeleteSource(source.Source);
end;

function TTemplateTreeNode.IsBuild: Boolean;
begin
  Result := (build <> nil);
end;

function TTemplateTreeNode.IsDependency: Boolean;
begin
  Result := (dependency <> nil);
end;

function TTemplateTreeNode.IsDesign: Boolean;
begin
  Result := (design <> nil);
end;

function TTemplateTreeNode.IsFileEntry: Boolean;
begin
  Result := (fileEntry <> nil);
end;

function TTemplateTreeNode.IsHeading: Boolean;
begin
  Result := (build = nil) and (runtime = nil) and (source = nil) and (searchpath = nil);
end;

function TTemplateTreeNode.IsLibEntry: Boolean;
begin
  Result := (libEntry <> nil);
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
