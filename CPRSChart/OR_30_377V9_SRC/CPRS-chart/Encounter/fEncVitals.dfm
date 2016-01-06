inherited frmEncVitals: TfrmEncVitals
  Left = 353
  Top = 210
  Caption = 'Vitals'
  OnActivate = FormActivate
  OnShow = FormShow
  ExplicitWidth = 784
  ExplicitHeight = 530
  PixelsPerInch = 96
  TextHeight = 16
  object lvVitals: TCaptionListView [0]
    Left = 0
    Top = 0
    Width = 768
    Height = 453
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    Columns = <>
    Constraints.MinHeight = 62
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object pnlBottom: TPanel [1]
    Left = 0
    Top = 453
    Width = 768
    Height = 39
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object btnEnterVitals: TButton
      Left = 10
      Top = 7
      Width = 92
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Enter Vitals'
      TabOrder = 0
      OnClick = btnEnterVitalsClick
    end
    object btnOKkludge: TButton
      Left = 534
      Top = 7
      Width = 92
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancelkludge: TButton
      Left = 642
      Top = 7
      Width = 93
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Cancel'
      TabOrder = 2
      OnClick = btnCancelClick
    end
  end
  inherited btnOK: TBitBtn
    Left = 256
    Top = 460
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'OK No Show'
    TabOrder = 2
    Visible = False
    ExplicitLeft = 256
    ExplicitTop = 460
  end
  inherited btnCancel: TBitBtn
    Left = 356
    Top = 460
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Cancel No Show'
    TabOrder = 3
    Visible = False
    ExplicitLeft = 356
    ExplicitTop = 460
  end
  object pnlmain: TPanel [4]
    Left = 34
    Top = 30
    Width = 701
    Height = 267
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    Visible = False
    object lblVitPointer: TOROffsetLabel
      Left = 623
      Top = 59
      Width = 21
      Height = 19
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = '<--'
      Color = clBtnFace
      HorzOffset = 5
      ParentColor = False
      Transparent = False
      VertOffset = 2
      WordWrap = False
    end
    object lblDate: TStaticText
      Left = 69
      Top = 28
      Width = 37
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object lblDateBP: TStaticText
      Tag = 3
      Left = 62
      Top = 150
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 17
    end
    object lblDateTemp: TStaticText
      Left = 62
      Top = 64
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 4
    end
    object lblDateResp: TStaticText
      Tag = 2
      Left = 62
      Top = 121
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 13
    end
    object lblDatePulse: TStaticText
      Tag = 1
      Left = 62
      Top = 92
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 9
    end
    object lblDateHeight: TStaticText
      Tag = 4
      Left = 62
      Top = 178
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 21
    end
    object lblDateWeight: TStaticText
      Tag = 5
      Left = 62
      Top = 208
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 26
    end
    object lblLstMeas: TStaticText
      Left = 222
      Top = 28
      Width = 97
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Last Measure'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object lbllastBP: TStaticText
      Tag = 3
      Left = 231
      Top = 150
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 18
    end
    object lblLastTemp: TStaticText
      Left = 231
      Top = 64
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 5
    end
    object lblLastResp: TStaticText
      Tag = 2
      Left = 231
      Top = 121
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 14
    end
    object lblLastPulse: TStaticText
      Tag = 1
      Left = 231
      Top = 92
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 10
    end
    object lblLastHeight: TStaticText
      Tag = 4
      Left = 231
      Top = 178
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 22
    end
    object lblLastWeight: TStaticText
      Tag = 5
      Left = 231
      Top = 208
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 27
    end
    object lblVital: TStaticText
      Left = 423
      Top = 28
      Width = 35
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Vital'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
    end
    object lblVitBP: TStaticText
      Left = 423
      Top = 150
      Width = 28
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'B/P'
      TabOrder = 19
    end
    object lnlVitTemp: TStaticText
      Left = 423
      Top = 64
      Width = 40
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Temp'
      TabOrder = 6
    end
    object lblVitResp: TStaticText
      Left = 423
      Top = 121
      Width = 37
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Resp'
      TabOrder = 15
    end
    object lblVitPulse: TStaticText
      Left = 423
      Top = 92
      Width = 38
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Pulse'
      TabOrder = 11
    end
    object lblVitHeight: TStaticText
      Left = 423
      Top = 178
      Width = 43
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Height'
      TabOrder = 23
    end
    object lblVitWeight: TStaticText
      Left = 423
      Top = 208
      Width = 46
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Weight'
      TabOrder = 28
    end
    object lblVitPain: TStaticText
      Left = 423
      Top = 238
      Width = 69
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Pain Scale'
      TabOrder = 33
    end
    object lblLastPain: TStaticText
      Tag = 5
      Left = 231
      Top = 238
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 32
    end
    object lblDatePain: TStaticText
      Tag = 5
      Left = 62
      Top = 238
      Width = 29
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'N/A'
      TabOrder = 31
    end
    object txtMeasBP: TCaptionEdit
      Tag = 1
      Left = 500
      Top = 146
      Width = 123
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 20
      OnEnter = SetVitPointer
      OnExit = txtMeasBPExit
      Caption = 'Blood Pressure'
    end
    object cboTemp: TCaptionComboBox
      Tag = 7
      Left = 551
      Top = 59
      Width = 71
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      DropDownCount = 2
      TabOrder = 8
      OnChange = cboTempChange
      OnEnter = SetVitPointer
      OnExit = cboTempExit
      Items.Strings = (
        'F'
        'C')
      Caption = 'Temperature'
    end
    object txtMeasTemp: TCaptionEdit
      Tag = 2
      Left = 500
      Top = 59
      Width = 53
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 7
      OnEnter = SetVitPointer
      OnExit = txtMeasTempExit
      Caption = 'Temperature'
    end
    object txtMeasResp: TCaptionEdit
      Tag = 3
      Left = 500
      Top = 117
      Width = 123
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 16
      OnEnter = SetVitPointer
      OnExit = txtMeasRespExit
      Caption = 'Resp'
    end
    object cboHeight: TCaptionComboBox
      Tag = 8
      Left = 553
      Top = 175
      Width = 70
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 25
      OnChange = cboHeightChange
      OnEnter = SetVitPointer
      OnExit = cboHeightExit
      Items.Strings = (
        'IN'
        'CM')
      Caption = 'Height'
    end
    object txtMeasWt: TCaptionEdit
      Tag = 6
      Left = 500
      Top = 204
      Width = 53
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 29
      OnEnter = SetVitPointer
      OnExit = txtMeasWtExit
      Caption = 'Weight'
    end
    object cboWeight: TCaptionComboBox
      Tag = 9
      Left = 553
      Top = 204
      Width = 70
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 30
      OnChange = cboWeightChange
      OnEnter = SetVitPointer
      OnExit = cboWeightExit
      Items.Strings = (
        'LB'
        'KG')
      Caption = 'Weight'
    end
    object txtMeasDate: TORDateBox
      Tag = 11
      Left = 500
      Top = 20
      Width = 149
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 0
      OnEnter = SetVitPointer
      DateOnly = False
      RequireTime = False
      Caption = 'Current Vital Date '
    end
    object cboPain: TORComboBox
      Tag = 10
      Left = 500
      Top = 234
      Width = 125
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Pain Scale'
      Color = clWindow
      DropDownCount = 12
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '1,2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 34
      TabStop = True
      Text = ''
      OnEnter = SetVitPointer
      CharsNeedMatch = 1
    end
    object txtMeasPulse: TCaptionEdit
      Tag = 4
      Left = 500
      Top = 89
      Width = 123
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 12
      OnEnter = SetVitPointer
      OnExit = txtMeasPulseExit
      Caption = 'Pulse'
    end
    object txtMeasHt: TCaptionEdit
      Tag = 5
      Left = 500
      Top = 175
      Width = 53
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 24
      OnEnter = SetVitPointer
      OnExit = txtMeasHtExit
      Caption = 'Height'
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = lvVitals'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = btnEnterVitals'
        'Status = stsDefault')
      (
        'Component = btnOKkludge'
        'Status = stsDefault')
      (
        'Component = btnCancelkludge'
        'Status = stsDefault')
      (
        'Component = pnlmain'
        'Status = stsDefault')
      (
        'Component = lblDate'
        'Status = stsDefault')
      (
        'Component = lblDateBP'
        'Status = stsDefault')
      (
        'Component = lblDateTemp'
        'Status = stsDefault')
      (
        'Component = lblDateResp'
        'Status = stsDefault')
      (
        'Component = lblDatePulse'
        'Status = stsDefault')
      (
        'Component = lblDateHeight'
        'Status = stsDefault')
      (
        'Component = lblDateWeight'
        'Status = stsDefault')
      (
        'Component = lblLstMeas'
        'Status = stsDefault')
      (
        'Component = lbllastBP'
        'Status = stsDefault')
      (
        'Component = lblLastTemp'
        'Status = stsDefault')
      (
        'Component = lblLastResp'
        'Status = stsDefault')
      (
        'Component = lblLastPulse'
        'Status = stsDefault')
      (
        'Component = lblLastHeight'
        'Status = stsDefault')
      (
        'Component = lblLastWeight'
        'Status = stsDefault')
      (
        'Component = lblVital'
        'Status = stsDefault')
      (
        'Component = lblVitBP'
        'Status = stsDefault')
      (
        'Component = lnlVitTemp'
        'Status = stsDefault')
      (
        'Component = lblVitResp'
        'Status = stsDefault')
      (
        'Component = lblVitPulse'
        'Status = stsDefault')
      (
        'Component = lblVitHeight'
        'Status = stsDefault')
      (
        'Component = lblVitWeight'
        'Status = stsDefault')
      (
        'Component = lblVitPain'
        'Status = stsDefault')
      (
        'Component = lblLastPain'
        'Status = stsDefault')
      (
        'Component = lblDatePain'
        'Status = stsDefault')
      (
        'Component = txtMeasBP'
        'Status = stsDefault')
      (
        'Component = cboTemp'
        'Status = stsDefault')
      (
        'Component = txtMeasTemp'
        'Status = stsDefault')
      (
        'Component = txtMeasResp'
        'Status = stsDefault')
      (
        'Component = cboHeight'
        'Status = stsDefault')
      (
        'Component = txtMeasWt'
        'Status = stsDefault')
      (
        'Component = cboWeight'
        'Status = stsDefault')
      (
        'Component = txtMeasDate'
        'Status = stsDefault')
      (
        'Component = cboPain'
        'Status = stsDefault')
      (
        'Component = txtMeasPulse'
        'Status = stsDefault')
      (
        'Component = txtMeasHt'
        'Status = stsDefault')
      (
        'Component = btnOK'
        'Status = stsDefault')
      (
        'Component = btnCancel'
        'Status = stsDefault')
      (
        'Component = frmEncVitals'
        'Status = stsDefault'))
  end
end
