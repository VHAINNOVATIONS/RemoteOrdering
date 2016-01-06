inherited frmODRTC: TfrmODRTC
  Left = 203
  Top = 183
  Width = 670
  Height = 456
  Caption = 'Return To Clinic'
  Constraints.MinHeight = 365
  Constraints.MinWidth = 300
  ExplicitWidth = 670
  ExplicitHeight = 456
  PixelsPerInch = 96
  TextHeight = 13
  inherited memOrder: TCaptionMemo
    Left = 10
    Top = 416
    Width = 555
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akBottom]
    Constraints.MinWidth = 25
    TabOrder = 1
    ExplicitLeft = 10
    ExplicitTop = 416
    ExplicitWidth = 555
  end
  object pnlRequired: TPanel [1]
    Left = 0
    Top = 0
    Width = 654
    Height = 361
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Align = alTop
    TabOrder = 5
    DesignSize = (
      654
      361)
    object lblClinic: TLabel
      Left = 28
      Top = 44
      Width = 32
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Clinic *'
    end
    object Label1: TLabel
      Left = 27
      Top = 89
      Width = 39
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Provider'
    end
    object lblQO: TLabel
      Left = 28
      Top = 5
      Width = 62
      Height = 13
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      Caption = 'Quick Orders'
    end
    object cboRTCClinic: TORComboBox
      Left = 27
      Top = 59
      Width = 261
      Height = 21
      CaseChanged = False
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Clinic'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 0
      Text = ''
      OnKeyUp = cboRTCClinicKeyUp
      OnMouseClick = cboRTCClinicMouseClick
      OnNeedData = cboRTCClinicNeedData
      CharsNeedMatch = 1
    end
    object cboProvider: TORComboBox
      Left = 27
      Top = 107
      Width = 261
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Provider'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      OnKeyUp = cboProviderKeyUp
      OnMouseClick = cboProviderMouseClick
      OnNeedData = cboProviderNeedData
      CharsNeedMatch = 1
    end
    object lblClinicallyIndicated: TStaticText
      Left = 27
      Top = 134
      Width = 117
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Clinically indicated date:'
      TabOrder = 2
    end
    object dateCIDC: TORDateBox
      Left = 27
      Top = 152
      Width = 98
      Height = 21
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      TabOrder = 3
      OnChange = dateCIDCChange
      DateOnly = False
      RequireTime = False
      Caption = ''
    end
    object lblNumberAppts: TStaticText
      Left = 27
      Top = 181
      Width = 123
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Number of Appointments:'
      TabOrder = 4
    end
    object txtNumAppts: TCaptionEdit
      Left = 27
      Top = 200
      Width = 60
      Height = 19
      AutoSize = False
      TabOrder = 6
      Text = '1'
      OnChange = txtNumApptsChange
      Caption = 'Nums of Appts'
    end
    object SpinNumAppt: TUpDown
      Left = 87
      Top = 200
      Width = 16
      Height = 19
      Associate = txtNumAppts
      Min = 1
      Max = 60
      Position = 1
      TabOrder = 8
    end
    object lblFrequency: TStaticText
      Left = 165
      Top = 181
      Width = 39
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Interval'
      TabOrder = 9
    end
    object cboInterval: TORComboBox
      Left = 165
      Top = 200
      Width = 83
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Interval'
      Color = clWindow
      DropDownCount = 2
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 10
      Text = ''
      OnChange = cboIntervalChange
      CharsNeedMatch = 1
    end
    object cboPreReq: TORComboBox
      Left = 28
      Top = 250
      Width = 261
      Height = 21
      CheckBoxes = True
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Pre-Req'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = False
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 11
      Text = ''
      CheckEntireLine = True
      OnChange = cboPreReqChange
      CharsNeedMatch = 1
    end
    object lblPReReq: TStaticText
      Left = 28
      Top = 231
      Width = 169
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Prerequisites: (Check all that apply)'
      TabOrder = 12
    end
    object memComments: TCaptionMemo
      Left = 27
      Top = 300
      Width = 493
      Height = 49
      TabOrder = 13
      OnChange = ControlChange
      Caption = ''
    end
    object lblComments: TStaticText
      Left = 27
      Top = 280
      Width = 53
      Height = 17
      Anchors = [akTop, akRight]
      Caption = 'Comments'
      TabOrder = 14
    end
    object cboPerQO: TORComboBox
      Left = 28
      Top = 19
      Width = 261
      Height = 21
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Clinic'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 2
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 16
      Text = ''
      OnKeyUp = cboPerQOKeyUp
      OnMouseClick = cboPerQOMouseClick
      CharsNeedMatch = 1
    end
  end
  inherited cmdAccept: TButton
    Left = 572
    Top = 417
    Width = 69
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 2
    ExplicitLeft = 572
    ExplicitTop = 417
    ExplicitWidth = 69
  end
  inherited cmdQuit: TButton
    Left = 578
    Top = 443
    Width = 48
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 3
    ExplicitLeft = 578
    ExplicitTop = 443
    ExplicitWidth = 48
  end
  inherited pnlMessage: TPanel
    Left = 228
    Top = 367
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    ExplicitLeft = 228
    ExplicitTop = 367
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
    Left = 592
    Top = 8
    Data = (
      (
        'Component = memOrder'
        'Text = Order Sig'
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
        'Component = frmODRTC'
        'Status = stsDefault')
      (
        'Component = pnlRequired'
        'Status = stsDefault')
      (
        'Component = cboRTCClinic'
        'Status = stsDefault')
      (
        'Component = cboProvider'
        'Status = stsDefault')
      (
        'Component = lblClinicallyIndicated'
        'Status = stsDefault')
      (
        'Component = dateCIDC'
        'Status = stsDefault')
      (
        'Component = lblNumberAppts'
        'Status = stsDefault')
      (
        'Component = txtNumAppts'
        'Status = stsDefault')
      (
        'Component = SpinNumAppt'
        'Status = stsDefault')
      (
        'Component = lblFrequency'
        'Status = stsDefault')
      (
        'Component = cboInterval'
        'Status = stsDefault')
      (
        'Component = cboPreReq'
        'Status = stsDefault')
      (
        'Component = lblPReReq'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = lblComments'
        'Status = stsDefault')
      (
        'Component = cboPerQO'
        'Status = stsDefault'))
  end
end
