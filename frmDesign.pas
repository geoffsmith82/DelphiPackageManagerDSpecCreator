unit frmDesign;

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
  TDesignForm = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    chkInstall: TCheckBox;
    lblDesignSrc: TLabel;
    edtDesignSrc: TEdit;
    lblDesignBuildId: TLabel;
    edtDesignBuildId: TEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TDesignForm.btnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TDesignForm.btnOkClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

end.
