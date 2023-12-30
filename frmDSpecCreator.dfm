object Form5: TForm5
  Left = 0
  Top = 0
  Caption = '.dspec Creator'
  ClientHeight = 441
  ClientWidth = 871
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 871
    Height = 441
    ActivePage = tsInfo
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 709
    object tsInfo: TTabSheet
      Caption = 'Package Info'
      object lblId: TLabel
        Left = 70
        Top = 32
        Width = 13
        Height = 15
        Caption = 'Id:'
      end
      object lblVersion: TLabel
        Left = 42
        Top = 61
        Width = 41
        Height = 15
        Caption = 'Version:'
      end
      object lblDescription: TLabel
        Left = 20
        Top = 99
        Width = 63
        Height = 15
        Caption = 'Description:'
      end
      object lblProjectURL: TLabel
        Left = 19
        Top = 194
        Width = 64
        Height = 15
        Caption = 'Project URL:'
      end
      object lblRepositoryURL: TLabel
        Left = 0
        Top = 223
        Width = 83
        Height = 15
        Caption = 'Repository URL:'
      end
      object lblLicense: TLabel
        Left = 41
        Top = 255
        Width = 42
        Height = 15
        Caption = 'License:'
      end
      object lblTags: TLabel
        Left = 57
        Top = 295
        Width = 26
        Height = 15
        Caption = 'Tags:'
      end
      object edtId: TEdit
        Left = 89
        Top = 29
        Width = 376
        Height = 23
        TabOrder = 0
        Text = 'edtId'
        OnChange = edtIdChange
      end
      object edtVersion: TEdit
        Left = 89
        Top = 58
        Width = 376
        Height = 23
        TabOrder = 1
        OnChange = edtVersionChange
      end
      object mmoDescription: TMemo
        Left = 89
        Top = 96
        Width = 376
        Height = 89
        Lines.Strings = (
          'mmoDescription')
        TabOrder = 2
        OnChange = mmoDescriptionChange
      end
      object edtProjectURL: TEdit
        Left = 89
        Top = 191
        Width = 376
        Height = 23
        TabOrder = 3
        OnChange = edtProjectURLChange
      end
      object edtRepositoryURL: TEdit
        Left = 89
        Top = 220
        Width = 376
        Height = 23
        TabOrder = 4
      end
      object cboLicense: TComboBox
        Left = 89
        Top = 252
        Width = 376
        Height = 23
        TabOrder = 5
        Text = 'cboLicense'
        OnChange = cboLicenseChange
        Items.Strings = (
          'Apache 2.0'
          'GNU General Public License v3.0'
          'GNU General Public License v2.0'
          'MIT License'
          'BSD 2-Clause "Simplified" License'
          'BSD 3-Clause "New" or "Revised" License'
          'Boost Software License 1.0'
          'Creative Commons Zero v1.0 Universal'
          'Eclipse Public License 2.0'
          'GNU Affero General Public License v3.0'
          'GNU Lesser General Public License v2.1'
          'Mozilla Public License 2.0'
          'The Unlicense')
      end
      object edtTags: TEdit
        Left = 89
        Top = 292
        Width = 376
        Height = 23
        TabOrder = 6
        OnChange = edtTagsChange
      end
    end
    object tsPlatforms: TTabSheet
      Caption = 'Platforms'
      ImageIndex = 1
      object lblTemplate: TLabel
        Left = 256
        Top = 203
        Width = 48
        Height = 15
        Caption = 'Template'
      end
      object clbCompilers: TCheckListBox
        Left = 72
        Top = 48
        Width = 161
        Height = 329
        ItemHeight = 17
        Items.Strings = (
          'XE2'
          'XE3'
          'XE4'
          'XE5'
          'XE6'
          'XE7'
          'XE8'
          '10.0'
          '10.1'
          '10.2'
          '10.3'
          '10.4'
          '11.0'
          '12.0')
        TabOrder = 0
        OnClick = clbCompilersClick
        OnDblClick = clbCompilersClick
        OnMouseEnter = clbCompilersClick
      end
      object cboTemplate: TComboBox
        Left = 256
        Top = 224
        Width = 161
        Height = 23
        TabOrder = 1
        Text = 'cboTemplate'
      end
      object clbPlatforms: TCheckListBox
        Left = 256
        Top = 48
        Width = 161
        Height = 137
        DoubleBuffered = True
        ItemHeight = 17
        Items.Strings = (
          'Win32'
          'Win64'
          'Linux'
          'Android'
          'Android64'
          'IOS'
          'OSX64')
        ParentDoubleBuffered = False
        TabOrder = 2
      end
    end
    object tsTemplates: TTabSheet
      Caption = 'Templates'
      ImageIndex = 2
      DesignSize = (
        863
        411)
      object btnAddTemplate: TButton
        Left = 3
        Top = 328
        Width = 86
        Height = 25
        Caption = 'Add Template'
        TabOrder = 0
        OnClick = btnAddTemplateClick
      end
      object btnDeleteTemplate: TButton
        Left = 95
        Top = 328
        Width = 98
        Height = 25
        Caption = 'Delete Template'
        TabOrder = 1
      end
      object tvTemplates: TTreeView
        Left = 3
        Top = 57
        Width = 286
        Height = 265
        AutoExpand = True
        DoubleBuffered = True
        HideSelection = False
        Indent = 19
        ParentDoubleBuffered = False
        PopupMenu = PopupMenu
        ReadOnly = True
        RightClickSelect = True
        RowSelect = True
        TabOrder = 2
        OnChange = tvTemplatesChange
        OnCollapsing = tvTemplatesCollapsing
        OnContextPopup = tvTemplatesContextPopup
        OnCreateNodeClass = tvTemplatesCreateNodeClass
      end
      object CardPanel1: TCardPanel
        Left = 312
        Top = 3
        Width = 526
        Height = 342
        Anchors = [akLeft, akTop, akRight, akBottom]
        ActiveCard = crdSource
        Caption = 'CardPanel1'
        TabOrder = 3
        object crdSource: TCard
          Left = 1
          Top = 1
          Width = 524
          Height = 340
          Caption = 'crdSource'
          CardIndex = 0
          TabOrder = 0
          ExplicitWidth = 450
          DesignSize = (
            524
            340)
          object lblSrc: TLabel
            Left = 48
            Top = 48
            Width = 19
            Height = 15
            Caption = 'Src:'
          end
          object lblDest: TLabel
            Left = 41
            Top = 100
            Width = 26
            Height = 15
            Caption = 'Dest:'
          end
          object edtSource: TEdit
            Left = 74
            Top = 45
            Width = 370
            Height = 23
            CustomHint = BalloonHint1
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            Text = 'edtSource'
            OnChange = edtSourceChange
          end
          object chkFlatten: TCheckBox
            Left = 74
            Top = 74
            Width = 97
            Height = 17
            Caption = 'Flatten'
            TabOrder = 1
          end
          object edtDest: TEdit
            Left = 73
            Top = 97
            Width = 370
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            Text = 'Edit1'
            OnChange = edtDestChange
          end
          object lbExclude: TListBox
            Left = 74
            Top = 126
            Width = 370
            Height = 97
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 15
            TabOrder = 3
            ExplicitWidth = 296
          end
          object btnAddExclude: TButton
            Left = 192
            Top = 229
            Width = 75
            Height = 25
            Caption = 'Add Exclude'
            TabOrder = 4
            OnClick = btnAddExcludeClick
          end
          object btnDeleteExclude: TButton
            Left = 282
            Top = 229
            Width = 88
            Height = 25
            Caption = 'Delete Exclude'
            TabOrder = 5
          end
        end
        object crdSearchPaths: TCard
          Left = 1
          Top = 1
          Width = 524
          Height = 340
          Caption = 'crdSearchPaths'
          CardIndex = 1
          TabOrder = 1
          ExplicitWidth = 450
          object lblSearchPaths: TLabel
            Left = 64
            Top = 32
            Width = 67
            Height = 15
            Caption = 'Search Paths'
          end
        end
        object crdBuild: TCard
          Left = 1
          Top = 1
          Width = 524
          Height = 340
          Caption = 'crdBuild'
          CardIndex = 2
          TabOrder = 2
          ExplicitWidth = 450
          DesignSize = (
            524
            340)
          object lblBuild: TLabel
            Left = 40
            Top = 16
            Width = 27
            Height = 15
            Caption = 'Build'
          end
          object lblBuildId: TLabel
            Left = 40
            Top = 48
            Width = 40
            Height = 15
            Caption = 'BuildId:'
          end
          object lblProject: TLabel
            Left = 40
            Top = 77
            Width = 40
            Height = 15
            Caption = 'Project:'
          end
          object edtBuildId: TEdit
            Left = 96
            Top = 45
            Width = 411
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            Text = 'edtBuildId'
            OnChange = edtBuildIdChange
            ExplicitWidth = 337
          end
          object edtProject: TEdit
            Left = 96
            Top = 74
            Width = 411
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            Text = 'Edit1'
            OnChange = edtProjectChange
          end
        end
        object crdRuntime: TCard
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 518
          Height = 334
          Caption = 'crdRuntime'
          CardIndex = 3
          TabOrder = 3
          ExplicitWidth = 444
          DesignSize = (
            518
            334)
          object lblRuntime: TLabel
            Left = 64
            Top = 32
            Width = 45
            Height = 15
            Caption = 'Runtime'
          end
          object lblRuntimeBuildId: TLabel
            Left = 40
            Top = 72
            Width = 40
            Height = 15
            Caption = 'BuildId:'
          end
          object lblRuntimeSrc: TLabel
            Left = 61
            Top = 112
            Width = 19
            Height = 15
            Caption = 'Src:'
          end
          object edtRuntimeBuildId: TEdit
            Left = 86
            Top = 69
            Width = 413
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 0
            OnClick = edtRuntimeBuildIdClick
            ExplicitWidth = 339
          end
          object edtRuntimeSrc: TEdit
            Left = 86
            Top = 109
            Width = 413
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnChange = edtRuntimeSrcChange
          end
          object chkCopyLocal: TCheckBox
            Left = 86
            Top = 144
            Width = 97
            Height = 17
            Caption = 'Copy Local'
            TabOrder = 2
            OnClick = chkCopyLocalClick
          end
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 12
    Top = 386
    object File1: TMenuItem
      Caption = '&File'
      object miNew: TMenuItem
        Caption = '&New'
        OnClick = miNewClick
      end
      object miOpen: TMenuItem
        Caption = '&Open...'
        OnClick = miOpenClick
      end
      object miSave: TMenuItem
        Caption = '&Save'
      end
      object miSaveAs: TMenuItem
        Caption = 'Save &As...'
        OnClick = miSaveAsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object miPrint: TMenuItem
        Caption = '&Print...'
      end
      object miPrintSetup: TMenuItem
        Caption = 'P&rint Setup...'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = 'E&xit'
        OnClick = miExitClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.dspec'
    Filter = 'Delphi Package Manager Spec Files|*.dspec'
    Left = 372
    Top = 370
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '*.dspec'
    Filter = 'Delphi Package Manager Spec Files|*.dspec'
    Left = 460
    Top = 362
  end
  object PopupMenu: TPopupMenu
    Left = 84
    Top = 122
  end
  object BalloonHint1: TBalloonHint
    Left = 389
    Top = 286
  end
end
