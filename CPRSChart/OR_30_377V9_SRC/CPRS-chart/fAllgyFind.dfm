inherited frmAllgyFind: TfrmAllgyFind
  Left = 408
  Top = 234
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Causative Agent Lookup'
  ClientHeight = 472
  ClientWidth = 445
  Position = poScreenCenter
  OnCreate = FormCreate
  ExplicitWidth = 451
  ExplicitHeight = 504
  PixelsPerInch = 96
  TextHeight = 13
  object lblSearch: TLabel [0]
    Left = 0
    Top = 0
    Width = 445
    Height = 25
    Align = alTop
    AutoSize = False
    Caption = 'Enter causative agent for Allergy or Adverse Drug Reaction:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Layout = tlBottom
  end
  object lblSelect: TLabel [1]
    Left = 5
    Top = 124
    Width = 152
    Height = 13
    Caption = 'Select one of the following items'
    Visible = False
  end
  object lblDetail: TLabel [2]
    Left = 0
    Top = 25
    Width = 445
    Height = 39
    Align = alTop
    AutoSize = False
    Caption = 
      '(Enter the FIRST FEW LETTERS of the causative agent (minimum of ' +
      '3) to allow for a comprehensive search. Only one reactant may be' +
      ' entered at a time)'
    Layout = tlBottom
    WordWrap = True
  end
  object lblSearchCaption: TLabel [3]
    Left = 6
    Top = 73
    Width = 52
    Height = 13
    Caption = 'Search for:'
  end
  object txtSearch: TCaptionEdit [4]
    Left = 4
    Top = 88
    Width = 331
    Height = 21
    TabOrder = 0
    OnChange = txtSearchChange
  end
  object cmdSearch: TButton [5]
    Left = 362
    Top = 88
    Width = 75
    Height = 21
    Caption = '&Search'
    Default = True
    TabOrder = 1
    OnClick = cmdSearchClick
  end
  object cmdOK: TButton [6]
    Left = 263
    Top = 422
    Width = 75
    Height = 22
    Caption = '&OK'
    TabOrder = 5
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton [7]
    Left = 345
    Top = 422
    Width = 75
    Height = 22
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 6
    OnClick = cmdCancelClick
  end
  object stsFound: TStatusBar [8]
    Left = 0
    Top = 453
    Width = 445
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object ckNoKnownAllergies: TCheckBox [9]
    Left = 320
    Top = 118
    Width = 119
    Height = 17
    Caption = '&No Known Allergies'
    TabOrder = 4
    OnClick = ckNoKnownAllergiesClick
  end
  object tvAgent: TORTreeView [10]
    Left = 2
    Top = 138
    Width = 437
    Height = 270
    HideSelection = False
    Indent = 19
    ReadOnly = True
    StateImages = imTree
    TabOrder = 2
    TabStop = False
    OnDblClick = tvAgentDblClick
    Caption = 'Select from one of the following items'
    NodePiece = 0
  end
  object NoAllergylbl508: TVA508StaticText [11]
    Name = 'NoAllergylbl508'
    Left = 320
    Top = 120
    Width = 12
    Height = 12
    Alignment = taLeftJustify
    BevelInner = bvLowered
    BorderStyle = bsSingle
    Enabled = False
    TabOrder = 3
    TabStop = True
    Visible = False
    ShowAccelChar = True
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtSearch'
        
          'Text = Enter causative agent for Allergy or Adverse Drug Reactio' +
          'n (Enter the FIRST FEW LETTERS of the causative agent (minimum o' +
          'f 3) to allow for a comprehensive search. Only one reactant may ' +
          'be entered at a time)   Search for:'
        'Status = stsOK')
      (
        'Component = cmdSearch'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = stsFound'
        'Status = stsDefault')
      (
        'Component = ckNoKnownAllergies'
        'Status = stsDefault')
      (
        'Component = tvAgent'
        'Status = stsDefault')
      (
        'Component = frmAllgyFind'
        'Status = stsDefault')
      (
        'Component = NoAllergylbl508'
        'Text = No Known Allergies checkbox disabled'
        'Status = stsOK'))
  end
  object imTree: TImageList
    Left = 396
    Top = 150
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFFFF00000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B00FFFFFF00FFFFFF00000000007B7B7B00FFFFFF00FFFFFF000000
      00007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B00FFFFFF007B7B7B007B7B7B007B7B7B00FFFFFF007B7B
      7B007B7B7B007B7B7B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B007B7B7B00FFFFFF007B7B7B00000000007B7B7B007B7B
      7B007B7B7B000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B007B7B7B007B7B7B00000000007B7B7B007B7B7B007B7B
      7B00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000007B7B7B00000000007B7B7B00FFFFFF007B7B7B000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008484840000FF000000FF
      0000000000000000000000FF000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008484840000FF0000000000000000
      000000000000000000000000000000FF000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000007B7B7B007B7B7B007B7B7B0000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000007B7B7B00000000007B7B7B007B7B7B007B7B7B00000000007B7B
      7B00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00007B7B7B007B7B7B00000000007B7B7B007B7B7B007B7B7B00000000007B7B
      7B007B7B7B00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000007B7B
      7B007B7B7B007B7B7B00000000007B7B7B007B7B7B007B7B7B00FFFFFF007B7B
      7B007B7B7B007B7B7B00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008484840000FF
      00000000000000000000000000000000000000000000000000007B7B7B007B7B
      7B007B7B7B000000000000000000000000007B7B7B0000000000000000000000
      00007B7B7B007B7B7B007B7B7B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      840000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFE3380000
      FFFFF9FFC1110000FFFFF0FFE0030000FFFFF0FFF0470000FFFFE07FF88F0000
      FFFFC07FFD1F0000FFFF843FFE0F0000FFFF1E3FFE270000FFFFFE1FFA230000
      FFFFFF1FF2210000FFFFFF8FE2000000FFFFFFC7C7710000FFFFFFE3FFFF0000
      FFFFFFF8FFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
  object imgLblAllgyFindTree: TVA508ImageListLabeler
    Components = <
      item
        Component = tvAgent
      end>
    ImageList = imTree
    Labels = <
      item
        ImageIndex = 0
        OverlayIndex = -1
      end
      item
        Caption = 'Check'
        ImageIndex = 1
        OverlayIndex = -1
      end
      item
        Caption = 'No Matches'
        ImageIndex = 2
        OverlayIndex = -1
      end>
    Left = 400
    Top = 192
  end
end
