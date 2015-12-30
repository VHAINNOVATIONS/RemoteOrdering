object rpcConfig: TrpcConfig
  Left = 421
  Top = 329
  HelpContext = 4
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Connect To'
  ClientHeight = 142
  ClientWidth = 428
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    428
    142)
  PixelsPerInch = 96
  TextHeight = 17
  object cboServer: TComboBox
    Left = 8
    Top = 16
    Width = 416
    Height = 25
    Hint = 'Choose a Server Name'
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    DropDownCount = 6
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = cboServerClick
    OnDblClick = cboServerClick
  end
  object btnOk: TBitBtn
    Left = 21
    Top = 81
    Width = 85
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&OK'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Glyph.Data = {
      BE060000424DBE06000000000000360400002800000024000000120000000100
      0800000000008802000000000000000000000001000000010000000000000000
      80000080000000808000800000008000800080800000C0C0C000C0DCC000F0C8
      A400000000000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F0FBFF00A4A0A000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00030303030303
      0303030303030303030303030303030303030303030303030303030303030303
      03030303030303030303030303030303030303030303FF030303030303030303
      03030303030303040403030303030303030303030303030303F8F8FF03030303
      03030303030303030303040202040303030303030303030303030303F80303F8
      FF030303030303030303030303040202020204030303030303030303030303F8
      03030303F8FF0303030303030303030304020202020202040303030303030303
      0303F8030303030303F8FF030303030303030304020202FA0202020204030303
      0303030303F8FF0303F8FF030303F8FF03030303030303020202FA03FA020202
      040303030303030303F8FF03F803F8FF0303F8FF03030303030303FA02FA0303
      03FA0202020403030303030303F8FFF8030303F8FF0303F8FF03030303030303
      FA0303030303FA0202020403030303030303F80303030303F8FF0303F8FF0303
      0303030303030303030303FA0202020403030303030303030303030303F8FF03
      03F8FF03030303030303030303030303FA020202040303030303030303030303
      0303F8FF0303F8FF03030303030303030303030303FA02020204030303030303
      03030303030303F8FF0303F8FF03030303030303030303030303FA0202020403
      030303030303030303030303F8FF0303F8FF03030303030303030303030303FA
      0202040303030303030303030303030303F8FF03F8FF03030303030303030303
      03030303FA0202030303030303030303030303030303F8FFF803030303030303
      030303030303030303FA0303030303030303030303030303030303F803030303
      0303030303030303030303030303030303030303030303030303030303030303
      0303}
    Margin = 2
    ModalResult = 1
    NumGlyphs = 2
    ParentFont = False
    Spacing = -1
    TabOrder = 1
    OnClick = btnOkClick
    IsControl = True
  end
  object btnCancel: TBitBtn
    Left = 124
    Top = 80
    Width = 85
    Height = 26
    Anchors = [akLeft, akBottom]
    Caption = '&Cancel'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Kind = bkCancel
    Margin = 2
    NumGlyphs = 2
    ParentFont = False
    Spacing = -1
    TabOrder = 2
    OnClick = butCancelClick
    IsControl = True
  end
  object btnHelp: TBitBtn
    Left = 226
    Top = 81
    Width = 85
    Height = 25
    Anchors = [akRight, akBottom]
    Kind = bkHelp
    NumGlyphs = 2
    TabOrder = 3
  end
  object btnNew: TButton
    Left = 327
    Top = 81
    Width = 85
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&New'
    TabOrder = 4
    OnClick = btnNewClick
  end
  object grd: TGridPanel
    Left = 0
    Top = 113
    Width = 428
    Height = 29
    Align = alBottom
    ColumnCollection = <
      item
        Value = 38.337248395211010000
      end
      item
        Value = 42.574581154771610000
      end
      item
        Value = 19.088170450017370000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = pnlNameBase
        Row = 0
      end
      item
        Column = 1
        Control = pnlIPBase
        Row = 0
      end
      item
        Column = 2
        Control = pnlPortBase
        Row = 0
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 5
    object pnlNameBase: TPanel
      Left = 1
      Top = 1
      Width = 163
      Height = 27
      Align = alClient
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = 'Name:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object pnlName: TPanel
        Left = 43
        Top = 2
        Width = 118
        Height = 23
        Align = alRight
        BevelOuter = bvLowered
        Caption = 'BROKERSERVER'
        TabOrder = 0
      end
    end
    object pnlIPBase: TPanel
      Left = 164
      Top = 1
      Width = 181
      Height = 27
      Align = alClient
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = 'IP Address:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object pnlIP: TPanel
        Left = 76
        Top = 2
        Width = 103
        Height = 23
        Align = alRight
        BevelOuter = bvLowered
        Caption = '255.255.255.255'
        TabOrder = 0
      end
    end
    object pnlPortBase: TPanel
      Left = 345
      Top = 1
      Width = 82
      Height = 27
      Align = alClient
      Alignment = taLeftJustify
      BevelInner = bvLowered
      BevelOuter = bvNone
      BorderWidth = 1
      Caption = 'Port:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object pnlPort: TPanel
        Left = 40
        Top = 2
        Width = 40
        Height = 23
        Align = alRight
        BevelOuter = bvLowered
        Caption = '99999'
        TabOrder = 0
      end
    end
  end
end
