object frmDeferDialog: TfrmDeferDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Defer Item'
  ClientHeight = 265
  ClientWidth = 516
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 223
    Width = 516
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 419
    DesignSize = (
      516
      42)
    object cmdCancel: TButton
      Left = 427
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 330
    end
    object cmdDefer: TButton
      Left = 346
      Top = 9
      Width = 75
      Height = 25
      Action = acDefer
      Anchors = [akRight, akBottom]
      TabOrder = 1
      ExplicitLeft = 249
    end
  end
  object gbxDeferBy: TGroupBox
    AlignWithMargins = True
    Left = 329
    Top = 3
    Width = 184
    Height = 217
    Align = alRight
    Caption = ' Defer Until '
    TabOrder = 1
    ExplicitLeft = 232
    DesignSize = (
      184
      217)
    object Bevel2: TBevel
      Left = 10
      Top = 150
      Width = 163
      Height = 4
      Anchors = [akLeft, akBottom]
      Shape = bsTopLine
      ExplicitTop = 136
    end
    object lblDate: TLabel
      Left = 10
      Top = 161
      Width = 27
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Date:'
      ExplicitTop = 147
    end
    object lblTime: TLabel
      Left = 10
      Top = 188
      Width = 26
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Time:'
      ExplicitTop = 181
    end
    object lblCustom: TLabel
      Left = 10
      Top = 130
      Width = 36
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Custom'
      Transparent = False
      ExplicitTop = 116
    end
    object dtpDate: TDateTimePicker
      Left = 67
      Top = 158
      Width = 106
      Height = 21
      Anchors = [akLeft, akBottom]
      Date = 41835.573142557870000000
      Time = 41835.573142557870000000
      TabOrder = 0
    end
    object dtpTime: TDateTimePicker
      Left = 67
      Top = 185
      Width = 106
      Height = 21
      Anchors = [akLeft, akBottom]
      Date = 41835.573435787040000000
      Format = 'h:mm tt'
      Time = 41835.573435787040000000
      Kind = dtkTime
      TabOrder = 1
    end
    object cbxDeferBy: TComboBox
      Left = 10
      Top = 25
      Width = 163
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnChange = acNewDeferalClickedExecute
    end
    object stxtDeferUntilDate: TStaticText
      AlignWithMargins = True
      Left = 10
      Top = 60
      Width = 94
      Height = 17
      Caption = 'stxtDeferUntilDate'
      TabOrder = 3
    end
    object stxtDeferUntilTime: TStaticText
      AlignWithMargins = True
      Left = 10
      Top = 90
      Width = 93
      Height = 17
      Caption = 'stxtDeferUntilTime'
      TabOrder = 4
    end
  end
  object pnlLeft: TPanel
    Left = 0
    Top = 0
    Width = 326
    Height = 223
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlLeft'
    ShowCaption = False
    TabOrder = 2
    ExplicitWidth = 229
    object stxtDescription: TStaticText
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 76
      Height = 17
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Caption = 'stxtDescription'
      TabOrder = 0
    end
  end
  object acList: TActionList
    Left = 40
    Top = 56
    object acNewDeferalClicked: TAction
      Caption = 'acNewDeferalClicked'
      OnExecute = acNewDeferalClickedExecute
    end
    object acDefer: TAction
      Caption = 'Defer'
      OnExecute = acDeferExecute
    end
  end
end
