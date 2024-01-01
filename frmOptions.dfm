object OptionsForm: TOptionsForm
  Left = 0
  Top = 0
  Caption = 'OptionsForm'
  ClientHeight = 504
  ClientWidth = 859
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  inline DPMOptionsFrame1: TDPMOptionsFrame
    Left = 0
    Top = 0
    Width = 859
    Height = 504
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 859
    inherited pgOptions: TPageControl
      Width = 859
      ExplicitWidth = 859
      inherited tsSources: TTabSheet
        ExplicitWidth = 851
        inherited Panel1: TPanel
          Width = 851
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 851
          inherited lblPackageSources: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label3: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited btnAdd: TSpeedButton
            Left = 668
            ExplicitLeft = 668
          end
          inherited btnRemove: TSpeedButton
            Left = 715
            ExplicitLeft = 715
          end
          inherited btnUp: TSpeedButton
            Left = 760
            ExplicitLeft = 760
          end
          inherited btnDown: TSpeedButton
            Left = 805
            ExplicitLeft = 805
          end
          inherited txtPackageCacheLocation: TButtonedEdit
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited Panel2: TPanel
          Width = 851
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 851
          inherited Label1: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label2: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label5: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label6: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label8: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited txtName: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited txtUri: TButtonedEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited txtUserName: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited txtPassword: TEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited cboSourceType: TComboBox
            StyleElements = [seFont, seClient, seBorder]
          end
        end
        inherited Panel3: TPanel
          Width = 851
          StyleElements = [seFont, seClient, seBorder]
          ExplicitWidth = 851
          inherited lvSources: TListView
            Width = 851
            ExplicitWidth = 851
          end
        end
      end
      inherited tsIDEOptions: TTabSheet
        inherited pnlIDEOptions: TPanel
          StyleElements = [seFont, seClient, seBorder]
          inherited Label4: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label7: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label9: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label10: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited Label11: TLabel
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited spAutoCloseDelay: TSpinEdit
            StyleElements = [seFont, seClient, seBorder]
          end
          inherited cboLogLevel: TComboBox
            StyleElements = [seFont, seClient, seBorder]
          end
        end
      end
    end
  end
end
