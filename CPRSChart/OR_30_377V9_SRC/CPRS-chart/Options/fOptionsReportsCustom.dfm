inherited frmOptionsReportsCustom: TfrmOptionsReportsCustom
  Left = 414
  Top = 329
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Individual CPRS Report Settings'
  ClientHeight = 476
  ClientWidth = 619
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 625
  ExplicitHeight = 504
  PixelsPerInch = 96
  TextHeight = 16
  object Bevel3: TBevel [0]
    Left = 0
    Top = 438
    Width = 619
    Height = 3
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    ExplicitTop = 433
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 441
    Width = 619
    Height = 35
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 436
    object btnApply: TButton
      Left = 532
      Top = 5
      Width = 61
      Height = 27
      Hint = 'Click to save new settings'
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Apply'
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnApplyClick
    end
    object btnCancel: TButton
      Left = 453
      Top = 5
      Width = 61
      Height = 27
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 374
      Top = 5
      Width = 63
      Height = 27
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
  end
  object Panel2: TPanel [2]
    Left = 0
    Top = 0
    Width = 619
    Height = 434
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 0
    object grdReport: TCaptionStringGrid
      Left = 1
      Top = 90
      Width = 617
      Height = 335
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      ColCount = 4
      DefaultRowHeight = 20
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 16
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goTabs]
      ScrollBars = ssVertical
      TabOrder = 5
      OnDrawCell = grdReportDrawCell
      OnKeyDown = grdReportKeyDown
      OnKeyPress = grdReportKeyPress
      OnMouseDown = grdReportMouseDown
      Caption = 'Report Grid'
      ColWidths = (
        219
        97
        89
        71)
    end
    object edtMax: TCaptionEdit
      Left = 325
      Top = 404
      Width = 109
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BorderStyle = bsNone
      TabOrder = 1
      Visible = False
      OnExit = edtMaxExit
      OnKeyPress = edtMaxKeyPress
      Caption = ''
    end
    object odbStop: TORDateBox
      Left = 167
      Top = 404
      Width = 139
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 3
      Visible = False
      OnExit = odbStopExit
      OnKeyPress = odbStopKeyPress
      DateOnly = True
      RequireTime = False
      Caption = 'Stop Date'
    end
    object odbStart: TORDateBox
      Left = 10
      Top = 404
      Width = 139
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 2
      Visible = False
      OnExit = odbStartExit
      OnKeyPress = odbStartKeyPress
      DateOnly = True
      RequireTime = False
      Caption = 'Start Date'
    end
    object odbTool: TORDateBox
      Left = 443
      Top = 404
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 4
      Visible = False
      DateOnly = True
      RequireTime = False
      Caption = 'Date'
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 617
      Height = 89
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      TabOrder = 0
      object Label1: TLabel
        Left = 20
        Top = 10
        Width = 327
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Type the first few letters of the report you are looking for:'
      end
      object edtSearch: TCaptionEdit
        Left = 30
        Top = 39
        Width = 532
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 0
        OnChange = edtSearchChange
        OnKeyPress = edtSearchKeyPress
        Caption = 'Type the first few letters of the report you are looking for:'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = btnApply'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = grdReport'
        'Status = stsDefault')
      (
        'Component = edtMax'
        'Status = stsDefault')
      (
        'Component = odbStop'
        'Status = stsDefault')
      (
        'Component = odbStart'
        'Status = stsDefault')
      (
        'Component = odbTool'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = edtSearch'
        'Status = stsDefault')
      (
        'Component = frmOptionsReportsCustom'
        'Status = stsDefault'))
  end
end
