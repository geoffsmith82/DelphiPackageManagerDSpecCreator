object RuntimeForm: TRuntimeForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'RuntimeForm'
  ClientHeight = 206
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object btnCancel: TButton
    Left = 413
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnOk: TButton
    Left = 494
    Top = 152
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
end
