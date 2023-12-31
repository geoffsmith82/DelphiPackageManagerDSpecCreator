unit frmSource;

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
  Vcl.StdCtrls
  ;

type
  TSourceForm = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SourceForm: TSourceForm;

implementation

{$R *.dfm}

end.
