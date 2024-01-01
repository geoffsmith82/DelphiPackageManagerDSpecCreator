object RuntimeForm: TRuntimeForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Runtime'
  ClientHeight = 206
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  DesignSize = (
    506
    206)
  TextHeight = 15
  object lblRuntimeSrc: TLabel
    Left = 50
    Top = 88
    Width = 19
    Height = 15
    Caption = 'Src:'
  end
  object lblRuntimeBuildId: TLabel
    Left = 29
    Top = 48
    Width = 40
    Height = 15
    Caption = 'BuildId:'
  end
  object btnCancel: TButton
    Left = 332
    Top = 152
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnOk: TButton
    Left = 413
    Top = 152
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object chkCopyLocal: TCheckBox
    Left = 75
    Top = 120
    Width = 97
    Height = 17
    Caption = 'Copy Local'
    TabOrder = 2
  end
  object edtRuntimeSrc: TEdit
    Left = 75
    Top = 85
    Width = 413
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
  end
  object edtRuntimeBuildId: TEdit
    Left = 75
    Top = 45
    Width = 413
    Height = 23
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
  end
end