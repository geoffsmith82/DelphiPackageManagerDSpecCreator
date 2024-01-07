unit frmOptions;

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
  DPM.Core.Types,
  DPM.Core.Logging,
  DPM.IDE.AddInOptionsFrame,
  DPM.Core.Configuration.Interfaces,
  DPM.Core.Configuration.Manager,
  DPM.IDE.Options
  ;

type
  TFakeIDE = class(TInterfacedObject, IDPMIDEOptions)
    function LoadFromFile(const fileName : string = '') : boolean;
    function SaveToFile(const fileName : string = '') : boolean;

    function GetOptionsFileName : string;

    function GetLogVerbosity : TVerbosity;
    procedure SetLogVebosity(const value : TVerbosity);

    function GetShowLogForRestore : boolean;
    procedure SetShowLogForRestore(const value : boolean);
    function GetShowLogForInstall : boolean;
    procedure SetShowLogForInstall(const value : boolean);
    function GetShowLogForUnInstall : boolean;
    procedure SetShowLogForUnInstall(const value : boolean);

    function GetAutoCloseLogOnSuccess : boolean;
    procedure SetAutoCloseLogOnSuccess(const value : boolean);
    function GetAutoCloseLogDelaySeconds : integer;
    procedure SetAutoCloseLogDelaySelcond(const value : integer);

    function GetAddDPMToProjectTree : boolean;
    procedure SetAddDPMToProjectTree(const value : boolean);

    function GetLogWindowWidth : integer;
    procedure SetLogWindowWidth(const value : integer);
    function GetLogWindowHeight : integer;
    procedure SetLogWindowHeight(const value : integer);
  end;

  TOptionsForm = class(TForm)
    DPMOptionsFrame1: TDPMOptionsFrame;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FConfigManager : IConfigurationManager;
    FLogger: ILogger;
    FIDEOptions : IDPMIDEOptions;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; logger: ILogger); reintroduce;
  end;


implementation

{$R *.dfm}

constructor TOptionsForm.Create(AOwner: TComponent; logger: ILogger);
begin
  inherited Create(AOwner);
  FLogger := logger;
  FIDEOptions := TFakeIDE.Create;
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
begin
  FConfigManager := TConfigurationManager.Create(FLogger);
  DPMOptionsFrame1.Configure(FConfigManager, FIDEOptions, FLogger, '');
  DPMOptionsFrame1.LoadSettings;
end;

{ TFakeIDE }

function TFakeIDE.GetAddDPMToProjectTree: boolean;
begin

end;

function TFakeIDE.GetAutoCloseLogDelaySeconds: integer;
begin

end;

function TFakeIDE.GetAutoCloseLogOnSuccess: boolean;
begin

end;

function TFakeIDE.GetLogVerbosity: TVerbosity;
begin

end;

function TFakeIDE.GetLogWindowHeight: integer;
begin

end;

function TFakeIDE.GetLogWindowWidth: integer;
begin

end;

function TFakeIDE.GetOptionsFileName: string;
begin

end;

function TFakeIDE.GetShowLogForInstall: boolean;
begin

end;

function TFakeIDE.GetShowLogForRestore: boolean;
begin

end;

function TFakeIDE.GetShowLogForUnInstall: boolean;
begin

end;

function TFakeIDE.LoadFromFile(const fileName: string): boolean;
begin

end;

function TFakeIDE.SaveToFile(const fileName: string): boolean;
begin

end;

procedure TFakeIDE.SetAddDPMToProjectTree(const value: boolean);
begin

end;

procedure TFakeIDE.SetAutoCloseLogDelaySelcond(const value: integer);
begin

end;

procedure TFakeIDE.SetAutoCloseLogOnSuccess(const value: boolean);
begin

end;

procedure TFakeIDE.SetLogVebosity(const value: TVerbosity);
begin

end;

procedure TFakeIDE.SetLogWindowHeight(const value: integer);
begin

end;

procedure TFakeIDE.SetLogWindowWidth(const value: integer);
begin

end;

procedure TFakeIDE.SetShowLogForInstall(const value: boolean);
begin

end;

procedure TFakeIDE.SetShowLogForRestore(const value: boolean);
begin

end;

procedure TFakeIDE.SetShowLogForUnInstall(const value: boolean);
begin

end;

end.
