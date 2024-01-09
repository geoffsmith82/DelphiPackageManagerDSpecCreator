unit DPM.Creator.RuntimeForm;

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
  TRuntimeForm = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    chkCopyLocal: TCheckBox;
    lblRuntimeSrc: TLabel;
    edtRuntimeSrc: TEdit;
    lblRuntimeBuildId: TLabel;
    edtRuntimeBuildId: TEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TRuntimeForm.btnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TRuntimeForm.btnOkClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

end.
