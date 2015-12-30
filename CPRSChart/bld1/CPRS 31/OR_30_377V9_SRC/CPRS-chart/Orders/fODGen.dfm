inherited frmODGen: TfrmODGen
  Left = 223
  Top = 290
  Height = 295
  Caption = 'frmODGen'
  ExplicitHeight = 295
  PixelsPerInch = 120
  TextHeight = 16
  object lblOrderSig: TLabel [0]
    Left = 10
    Top = 238
    Width = 57
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Order Sig'
  end
  inherited memOrder: TCaptionMemo
    Top = 257
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 257
  end
  object sbxMain: TScrollBox [2]
    Left = 0
    Top = 0
    Width = 615
    Height = 228
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 4
    ExplicitWidth = 640
  end
  inherited cmdAccept: TButton
    Top = 257
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 257
  end
  inherited cmdQuit: TButton
    Top = 288
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 288
  end
  inherited pnlMessage: TPanel
    Top = 235
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitTop = 235
    inherited imgMessage: TImage
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
    end
    inherited memMessage: TRichEdit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
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
