inherited frmODGen: TfrmODGen
  Left = 223
  Top = 290
  Height = 295
  Caption = 'frmODGen'
  ExplicitHeight = 295
  PixelsPerInch = 96
  TextHeight = 13
  object lblOrderSig: TLabel [0]
    Left = 8
    Top = 193
    Width = 44
    Height = 13
    Caption = 'Order Sig'
  end
  inherited memOrder: TCaptionMemo
    Top = 209
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ExplicitTop = 209
  end
  object sbxMain: TScrollBox [2]
    Left = 0
    Top = 0
    Width = 512
    Height = 185
    Align = alTop
    TabOrder = 4
  end
  inherited cmdAccept: TButton
    Top = 209
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ExplicitTop = 209
  end
  inherited cmdQuit: TButton
    Top = 234
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ExplicitTop = 234
  end
  inherited pnlMessage: TPanel
    Top = 191
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    ExplicitTop = 191
    inherited imgMessage: TImage
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    inherited memMessage: TRichEdit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = sbxMain'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Label = lblOrderSig'
        'Status = stsOK')
      (
        'Component = cmdAccept'
        'Status = stsDefault')
      (
        'Component = cmdQuit'
        'Status = stsDefault')
      (
        'Component = pnlMessage'
        'Status = stsDefault')
      (
        'Component = memMessage'
        'Status = stsDefault')
      (
        'Component = frmODGen'
        'Status = stsDefault'))
  end
  object VA508CompMemOrder: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompMemOrderStateQuery
    Left = 96
    Top = 232
  end
end
