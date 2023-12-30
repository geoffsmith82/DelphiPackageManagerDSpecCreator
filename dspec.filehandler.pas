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
    procedure RenameTemplate(originalName: string; newName: string);
    procedure LoadFromFile(filename: string);
    procedure SaveToFile(filename: string);
    function IsModified: Boolean;
  end;


implementation

uses
  System.IOUtils,
  System.SysUtils
  ;

{ TDSpecFile }

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
begin

end;

procedure TDSpecFile.SaveToFile(filename: string);
begin
  TFile.WriteAllText(Filename, TJson.ObjectToJsonObject(structure).Format);
end;

end.
