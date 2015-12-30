inherited frmODBase: TfrmODBase
  Left = 277
  Top = 179
  Width = 528
  Height = 275
  HorzScrollBar.Position = 125
  HorzScrollBar.Range = 615
  HorzScrollBar.Tracking = True
  HorzScrollBar.Visible = True
  VertScrollBar.Position = 68
  VertScrollBar.Range = 277
  VertScrollBar.Visible = True
  BorderIcons = [biSystemMenu]
  Caption = ''
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  ExplicitWidth = 528
  ExplicitHeight = 275
  PixelsPerInch = 120
  TextHeight = 16
  object memOrder: TCaptionMemo [0]
    Left = -118
    Top = 171
    Width = 530
    Height = 59
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Color = clCream
    Ctl3D = True
    ParentCtl3D = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    Caption = ''
  end
  object cmdAccept: TButton [1]
    Left = 419
    Top = 171
    Width = 89
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Accept Order'
    TabOrder = 1
    OnClick = cmdAcceptClick
  end
  object cmdQuit: TButton [2]
    Left = 419
    Top = 204
    Width = 48
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Cancel = True
    Caption = 'Quit'
    TabOrder = 2
    OnClick = cmdQuitClick
  end
  object pnlMessage: TPanel [3]
    Left = -95
    Top = 149
    Width = 468
    Height = 54
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvRaised
    BorderStyle = bsSingle
    TabOrder = 3
    Visible = False
    OnExit = pnlMessageExit
    OnMouseDown = pnlMessageMouseDown
    OnMouseMove = pnlMessageMouseMove
    object imgMessage: TImage
      Left = 5
      Top = 5
      Width = 39
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      OnMouseUp = memMessageMouseUp
    end
    object memMessage: TRichEdit
      Left = 49
      Top = 5
      Width = 409
      Height = 39
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Color = clInfoBk
      Font.Charset = ANSI_CHARSET
      Font.Color = clInfoText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      WantReturns = False
      OnMouseDown = pnlMessageMouseDown
      OnMouseMove = pnlMessageMouseMove
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = memOrder'
        'Status = stsDefault')
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
        'Component = frmODBase'
        'Status = stsDefault'))
  end
end
