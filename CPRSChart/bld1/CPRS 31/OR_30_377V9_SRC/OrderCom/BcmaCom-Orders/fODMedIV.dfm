inherited frmODMedIV: TfrmODMedIV
  Left = 246
  Top = 256
  Width = 668
  Height = 465
  Caption = 'Infusion Order'
  Constraints.MinHeight = 360
  Constraints.MinWidth = 500
  ExplicitWidth = 668
  ExplicitHeight = 465
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfusionRate: TLabel [0]
    Left = 486
    Top = 197
    Width = 100
    Height = 13
    Caption = 'Infusion Rate (ml/hr)*'
  end
  object lblPriority: TLabel [1]
    Left = 8
    Top = 238
    Width = 35
    Height = 13
    Caption = 'Priority*'
    Visible = False
  end
  object lblComponent: TLabel [2]
    Left = 8
    Top = 6
    Width = 85
    Height = 13
    Caption = 'Solution/Additive*'
  end
  object lblAmount: TLabel [3]
    Left = 168
    Top = 6
    Width = 84
    Height = 13
    Caption = 'Volume/Strength*'
    WordWrap = True
  end
  object lblComments: TLabel [4]
    Left = 8
    Top = 109
    Width = 49
    Height = 13
    Caption = 'Comments'
  end
  object lblLimit: TLabel [5]
    Left = 185
    Top = 238
    Width = 165
    Height = 13
    Caption = 'Duration or Total Volume (Optional)'
    Visible = False
  end
  object Label1: TLabel [6]
    Left = 10
    Top = 345
    Width = 44
    Height = 13
    Caption = 'Order Sig'
  end
  object lblRoute: TLabel [7]
    Left = 8
    Top = 197
    Width = 33
    Height = 13
    Caption = 'Route*'
  end
  object lblSchedule: TLabel [8]
    Left = 304
    Top = 197
    Width = 52
    Height = 13
    Caption = 'Schedule *'
  end
  object lblType: TLabel [9]
    Left = 184
    Top = 197
    Width = 28
    Height = 13
    Caption = 'Type*'
    ParentShowHint = False
    ShowHint = True
    Visible = False
  end
  object txtNSS: TLabel [10]
    Left = 361
    Top = 197
    Width = 69
    Height = 13
    Caption = '(Day-of-Week)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Visible = False
    OnClick = txtNSSClick
  end
  object txtAllIVRoutes: TLabel [11]
    Left = 47
    Top = 197
    Width = 129
    Height = 13
    Caption = '(Expanded Med Route List)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Visible = False
    OnClick = txtAllIVRoutesClick
  end
  object lblTypeHelp: TLabel [12]
    Left = 219
    Top = 197
    Width = 68
    Height = 13
    Caption = '(IV Type Help)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = False
    Visible = False
    OnClick = lblTypeHelpClick
  end
  object lblAddFreq: TLabel [13]
    Left = 463
    Top = 6
    Width = 95
    Height = 13
    Caption = 'Additive Frequency*'
  end
  object lblPrevAddFreq: TLabel [14]
    Left = 565
    Top = 6
    Width = 77
    Height = 13
    Caption = 'Prev. Add. Freq.'
  end
  object txtRate: TCaptionEdit [15]
    Left = 486
    Top = 211
    Width = 91
    Height = 21
    AutoSelect = False
    TabOrder = 10
    OnChange = txtRateChange
    Caption = 'Infusion Rate'
  end
  object cboPriority: TORComboBox [16]
    Left = 8
    Top = 252
    Width = 72
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = 'Priority'
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 12
    Text = ''
    Visible = False
    OnChange = cboPriorityChange
    OnExit = cboPriorityExit
    OnKeyUp = cboPriorityKeyUp
    CharsNeedMatch = 1
  end
  object grdSelected: TCaptionStringGrid [17]
    Left = 8
    Top = 18
    Width = 644
    Height = 76
    DefaultColWidth = 100
    DefaultRowHeight = 19
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ScrollBars = ssVertical
    TabOrder = 2
    OnDrawCell = grdSelectedDrawCell
    OnKeyPress = grdSelectedKeyPress
    OnMouseDown = grdSelectedMouseDown
    Caption = ''
  end
  object cmdRemove: TButton [18]
    Left = 443
    Top = 100
    Width = 72
    Height = 18
    Caption = 'Remove'
    TabOrder = 3
    Visible = False
    OnClick = cmdRemoveClick
  end
  object memComments: TCaptionMemo [19]
    Left = 8
    Top = 121
    Width = 643
    Height = 66
    Lines.Strings = (
      'memComments')
    ScrollBars = ssVertical
    TabOrder = 4
    OnChange = ControlChange
    Caption = 'Comments'
  end
  object txtSelected: TCaptionEdit [20]
    Tag = -1
    Left = 416
    Top = 45
    Width = 45
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    Text = 'meq.'
    Visible = False
    OnChange = txtSelectedChange
    OnExit = txtSelectedExit
    OnKeyDown = txtSelectedKeyDown
    Caption = 'Volume'
  end
  object cboSelected: TCaptionComboBox [21]
    Tag = -1
    Left = 462
    Top = 45
    Width = 53
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 6
    Visible = False
    OnCloseUp = cboSelectedCloseUp
    OnKeyDown = cboSelectedKeyDown
    Caption = 'Volume/Strength'
  end
  inherited memOrder: TCaptionMemo
    Top = 364
    Width = 475
    TabOrder = 17
    ExplicitTop = 364
    ExplicitWidth = 475
  end
  object pnlXDuration: TPanel [23]
    Left = 184
    Top = 252
    Width = 150
    Height = 21
    BevelOuter = bvNone
    TabOrder = 13
    OnEnter = pnlXDurationEnter
    object txtXDuration: TCaptionEdit
      Left = 0
      Top = 0
      Width = 68
      Height = 21
      TabOrder = 0
      Visible = False
      OnChange = txtXDurationChange
      OnExit = txtXDurationExit
      Caption = ''
    end
    object cboDuration: TComboBox
      Left = 70
      Top = 0
      Width = 75
      Height = 21
      TabOrder = 1
      Visible = False
      OnChange = cboDurationChange
      OnEnter = cboDurationEnter
    end
  end
  object pnlCombo: TPanel [24]
    Left = 8
    Top = 269
    Width = 200
    Height = 201
    Anchors = []
    BevelOuter = bvNone
    TabOrder = 26
    Visible = False
    object cboAdditive: TORComboBox
      Left = 0
      Top = 20
      Width = 200
      Height = 181
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Additives'
      Color = clWindow
      DropDownCount = 11
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '20'
      TabOrder = 1
      Text = ''
      Visible = False
      OnExit = cboAdditiveExit
      OnMouseClick = cboAdditiveMouseClick
      OnNeedData = cboAdditiveNeedData
      CharsNeedMatch = 1
    end
    object tabFluid: TTabControl
      Left = 0
      Top = 0
      Width = 200
      Height = 20
      Align = alTop
      Anchors = []
      TabHeight = 15
      TabOrder = 2
      Tabs.Strings = (
        '   Solutions   '
        '   Additives   ')
      TabIndex = 0
      Visible = False
      OnChange = tabFluidChange
    end
    object cboSolution: TORComboBox
      Left = 0
      Top = 20
      Width = 200
      Height = 181
      Style = orcsSimple
      Align = alClient
      AutoSelect = True
      Caption = 'Solutions'
      Color = clWindow
      DropDownCount = 11
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabPositions = '20'
      TabOrder = 0
      Text = ''
      Visible = False
      OnExit = cboSolutionExit
      OnMouseClick = cboSolutionMouseClick
      OnNeedData = cboSolutionNeedData
      CharsNeedMatch = 1
    end
  end
  object cboRoute: TORComboBox [25]
    Left = 8
    Top = 211
    Width = 168
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 0
    MaxLength = 0
    Pieces = '2'
    Sorted = False
    SynonymChars = '<>'
    TabOrder = 5
    Text = ''
    OnChange = cboRouteChange
    OnClick = cboRouteClick
    OnExit = cboRouteExit
    OnKeyDown = cboRouteKeyDown
    OnKeyUp = cboRouteKeyUp
    CharsNeedMatch = 1
    UniqueAutoComplete = True
  end
  object cboSchedule: TORComboBox [26]
    Left = 304
    Top = 211
    Width = 129
    Height = 21
    Style = orcsDropDown
    AutoSelect = True
    Caption = ''
    Color = clWindow
    DropDownCount = 8
    ItemHeight = 13
    ItemTipColor = clWindow
    ItemTipEnable = True
    ListItemsOnly = False
    LongList = False
    LookupPiece = 1
    MaxLength = 0
    Pieces = '1'
    Sorted = True
    SynonymChars = '<>'
    TabOrder = 8
    Text = ''
    OnChange = cboScheduleChange
    OnClick = cboScheduleClick
    OnExit = cboScheduleExit
    OnKeyDown = cboScheduleKeyDown
    OnKeyUp = cboScheduleKeyUp
    CharsNeedMatch = 1
    UniqueAutoComplete = True
  end
  object cboType: TComboBox [27]
    Left = 184
    Top = 211
    Width = 114
    Height = 21
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    Visible = False
    OnChange = cboTypeChange
    OnKeyDown = cboTypeKeyDown
  end
  object chkPRN: TCheckBox [28]
    Left = 436
    Top = 213
    Width = 45
    Height = 21
    Caption = 'PRN'
    TabOrder = 9
    Visible = False
    OnClick = chkPRNClick
  end
  object chkDoseNow: TCheckBox [29]
    Left = 8
    Top = 279
    Width = 147
    Height = 17
    Anchors = [akLeft]
    Caption = 'Give Additional Dose Now'
    Constraints.MinWidth = 147
    TabOrder = 14
    Visible = False
    OnClick = chkDoseNowClick
  end
  object cboInfusionTime: TComboBox [30]
    Left = 576
    Top = 211
    Width = 74
    Height = 21
    TabOrder = 11
    OnChange = cboInfusionTimeChange
    OnEnter = cboInfusionTimeEnter
  end
  object lblAdminTime: TVA508StaticText [31]
    Name = 'lblAdminTime'
    Left = 8
    Top = 308
    Width = 4
    Height = 4
    Alignment = taLeftJustify
    Caption = ''
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    TabStop = True
    Visible = False
    ShowAccelChar = True
  end
  object lblFirstDose: TVA508StaticText [32]
    Name = 'lblFirstDose'
    Left = 8
    Top = 323
    Width = 4
    Height = 4
    Alignment = taLeftJustify
    Caption = ''
    TabOrder = 16
    TabStop = True
    Visible = False
    ShowAccelChar = True
  end
  object cboAddFreq: TCaptionComboBox [33]
    Left = 488
    Top = 72
    Width = 145
    Height = 21
    TabOrder = 25
    Visible = False
    OnCloseUp = cboAddFreqCloseUp
    OnKeyDown = cboAddFreqKeyDown
    Caption = ''
  end
  inherited cmdAccept: TButton
    Left = 495
    Top = 364
    TabOrder = 18
    ExplicitLeft = 495
    ExplicitTop = 364
  end
  inherited cmdQuit: TButton
    Left = 495
    Top = 391
    TabOrder = 19
    ExplicitLeft = 495
    ExplicitTop = 391
  end
  object lbl508Required: TVA508StaticText [36]
    Name = 'lbl508Required'
    Left = 6
    Top = 318
    Width = 135
    Height = 15
    Alignment = taLeftJustify
    Caption = ' * Indicates a Required Field'
    TabOrder = 1
    ShowAccelChar = True
  end
  inherited pnlMessage: TPanel
    Left = 56
    Top = 341
    TabOrder = 20
    ExplicitLeft = 56
    ExplicitTop = 341
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = txtRate'
        'Label = lblInfusionRate'
        'Status = stsOK')
      (
        'Component = cboPriority'
        'Label = lblPriority'
        'Status = stsOK')
      (
        'Component = grdSelected'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = txtSelected'
        'Status = stsDefault')
      (
        'Component = cboSelected'
        'Status = stsDefault')
      (
        'Component = pnlXDuration'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Label = lblLimit'
        'Status = stsOK')
      (
        'Component = pnlCombo'
        'Status = stsDefault')
      (
        'Component = cboAdditive'
        'Status = stsDefault')
      (
        'Component = tabFluid'
        'Status = stsDefault')
      (
        'Component = cboSolution'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Label = lblRoute'
        'Status = stsOK')
      (
        'Component = cboSchedule'
        'Label = lblSchedule'
        'Status = stsOK')
      (
        'Component = cboType'
        'Label = lblType'
        'Status = stsOK')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
      (
        'Component = memOrder'
        'Label = Label1'
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
        'Component = frmODMedIV'
        'Status = stsDefault')
      (
        'Component = cboInfusionTime'
        'Text = Infusion Rate Time'
        'Status = stsOK')
      (
        'Component = cboDuration'
        'Text = Duration/Volume Units'
        'Status = stsOK')
      (
        'Component = lblAdminTime'
        'Status = stsDefault')
      (
        'Component = lblFirstDose'
        'Status = stsDefault')
      (
        'Component = cboAddFreq'
        'Status = stsDefault')
      (
        'Component = lbl508Required'
        'Status = stsDefault'))
  end
  object VA508CompOrderSig: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompOrderSigStateQuery
    Left = 24
    Top = 368
  end
  object VA508CompRoute: TVA508ComponentAccessibility
    Component = cboRoute
    OnInstructionsQuery = VA508CompRouteInstructionsQuery
    Left = 104
    Top = 240
  end
  object VA508CompType: TVA508ComponentAccessibility
    Component = cboType
    OnInstructionsQuery = VA508CompTypeInstructionsQuery
    Left = 224
    Top = 280
  end
  object VA508CompSchedule: TVA508ComponentAccessibility
    Component = cboSchedule
    OnInstructionsQuery = VA508CompScheduleInstructionsQuery
    Left = 384
    Top = 240
  end
  object VA508CompGrdSelected: TVA508ComponentAccessibility
    Component = grdSelected
    OnCaptionQuery = VA508CompGrdSelectedCaptionQuery
    Left = 288
    Top = 64
  end
end
