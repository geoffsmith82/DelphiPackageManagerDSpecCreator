program DspecCreator;

uses
  Vcl.Forms,
  frmDSpecCreator in 'frmDSpecCreator.pas' {Form5},
  dpm.dspec.format in 'dpm.dspec.format.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
