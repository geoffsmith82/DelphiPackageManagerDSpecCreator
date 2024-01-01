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
  DPM.IDE.AddInOptionsFrame
  ;

type
  TOptionsForm = class(TForm)
    DPMOptionsFrame1: TDPMOptionsFrame;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

end.
