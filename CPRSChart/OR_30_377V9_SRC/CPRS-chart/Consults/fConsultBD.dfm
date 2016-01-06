inherited frmConsultsByDate: TfrmConsultsByDate
  Left = 372
  Top = 217
  BorderIcons = []
  Caption = 'List Consults by Date Range'
  ClientHeight = 151
  ClientWidth = 251
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 259
  ExplicitHeight = 178
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 251
    Height = 151
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblBeginDate: TLabel
      Left = 8
      Top = 8
      Width = 73
      Height = 13
      Caption = 'Beginning Date'
    end
    object lblEndDate: TLabel
      Left = 8
      Top = 51
      Width = 59
      Height = 13
      Caption = 'Ending Date'
    end
    object calBeginDate: TORDateBox
      Left = 8
      Top = 22
      Width = 155
      Height = 21
      TabOrder = 0
      DateOnly = False
      RequireTime = False
      Caption = 'Beginning Date'
    end
    object calEndDate: TORDateBox
      Left = 8
      Top = 65
      Width = 155
      Height = 21
      TabOrder = 1
      DateOnly = False
      RequireTime = False
      Caption = 'Ending Date'
    end
    object radSort: TRadioGroup
      Left = 8
      Top = 94
      Width = 155
      Height = 49
      Caption = 'Sort Order'
      Items.Strings = (
        '&Ascending (oldest first)'
        '&Descending (newest first)')
      TabOrder = 2
    end
    object cmdOK: TButton
      Left = 171
      Top = 95
      Width = 72
      Height = 21
      Caption = 'OK'
      Default = True
      TabOrder = 3
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 171
      Top = 122
      Width = 72
      Height = 21
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 4
      OnClick = cmdCancelClick
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlBase'
        'Status = stsDefault')
      (
        'Component = calBeginDate'
        'Status = stsDefault')
      (
        'Component = calEndDate'
        'Status = stsDefault')
      (
        'Component = radSort'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = frmConsultsByDate'
        'Status = stsDefault'))
  end
end
