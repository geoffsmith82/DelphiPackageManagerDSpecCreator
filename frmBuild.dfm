object BuildForm: TBuildForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'BuildForm'
  ClientHeight = 221
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
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 494
    Top = 168
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
  end
end
