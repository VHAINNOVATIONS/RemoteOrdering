inherited frmODMeds: TfrmODMeds
  Left = 321
  Top = 183
  Width = 696
  Height = 438
  AutoScroll = True
  Caption = 'Medication Order'
  Constraints.MinHeight = 400
  Constraints.MinWidth = 556
  OnShow = FormShow
  ExplicitWidth = 696
  ExplicitHeight = 438
  DesignSize = (
    680
    400)
  PixelsPerInch = 96
  TextHeight = 16
  object pnlMeds: TPanel [0]
    Left = 7
    Top = 42
    Width = 849
    Height = 462
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 6
    ExplicitWidth = 709
    ExplicitHeight = 424
    object sptSelect: TSplitter
      Left = 0
      Top = 164
      Width = 849
      Height = 5
      Cursor = crVSplit
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      ExplicitWidth = 834
    end
    object lstQuick: TCaptionListView
      Left = 0
      Top = 0
      Width = 849
      Height = 164
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelInner = bvLowered
      BevelOuter = bvSpace
      Columns = <
        item
          Width = 517
        end>
      ColumnClick = False
      HideSelection = False
      HotTrack = True
      HoverTime = 2147483647
      OwnerData = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 0
      ViewStyle = vsReport
      OnChange = lstChange
      OnClick = ListViewClick
      OnData = lstQuickData
      OnDataHint = lstQuickDataHint
      OnEditing = ListViewEditing
      OnEnter = ListViewEnter
      OnKeyUp = ListViewKeyUp
      OnResize = ListViewResize
      AutoSize = False
      Caption = 'Quick Orders'
      ExplicitWidth = 709
    end
    object lstAll: TCaptionListView
      Left = 0
      Top = 169
      Width = 849
      Height = 293
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvNone
      Columns = <
        item
          Width = 517
        end>
      ColumnClick = False
      HideSelection = False
      HotTrack = True
      HoverTime = 2147483647
      OwnerData = True
      ParentShowHint = False
      ShowColumnHeaders = False
      ShowHint = True
      TabOrder = 1
      ViewStyle = vsReport
      OnChange = lstChange
      OnClick = ListViewClick
      OnData = lstAllData
      OnDataHint = lstAllDataHint
      OnEditing = ListViewEditing
      OnEnter = ListViewEnter
      OnKeyUp = ListViewKeyUp
      OnResize = ListViewResize
      AutoSize = False
      Caption = 'All Medication orders'
      ExplicitWidth = 709
      ExplicitHeight = 255
    end
  end
  inherited memOrder: TCaptionMemo
    Tag = 13
    Top = 505
    Width = 752
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    ExplicitTop = 467
    ExplicitWidth = 612
  end
  object txtMed: TEdit [2]
    Left = 7
    Top = 15
    Width = 849
    Height = 24
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight]
    AutoSelect = False
    TabOrder = 0
    Text = '(Type a medication name or select from the orders below)'
    OnChange = txtMedChange
    OnExit = txtMedExit
    OnKeyDown = txtMedKeyDown
    OnKeyUp = txtMedKeyUp
    ExplicitWidth = 709
  end
  object btnSelect: TButton [3]
    Left = 768
    Top = 505
    Width = 89
    Height = 26
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    Enabled = False
    TabOrder = 5
    OnClick = btnSelectClick
    ExplicitLeft = 628
    ExplicitTop = 467
  end
  object pnlFields: TPanel [4]
    Left = 7
    Top = 54
    Width = 849
    Height = 472
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Enabled = False
    TabOrder = 2
    Visible = False
    OnResize = pnlFieldsResize
    ExplicitWidth = 709
    ExplicitHeight = 434
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 849
      Height = 136
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Constraints.MinHeight = 98
      TabOrder = 0
      ExplicitWidth = 709
      ExplicitHeight = 98
      DesignSize = (
        849
        136)
      object lblRoute: TLabel
        Left = 479
        Top = 28
        Width = 36
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Route'
        Visible = False
        ExplicitLeft = 465
      end
      object lblSchedule: TLabel
        Left = 620
        Top = 27
        Width = 57
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Schedule'
        Visible = False
        WordWrap = True
        ExplicitLeft = 606
      end
      object txtNSS: TLabel
        Left = 679
        Top = 27
        Width = 90
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = '(Day-Of-Week)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
        WordWrap = True
        OnClick = txtNSSClick
        ExplicitLeft = 665
      end
      object grdDoses: TCaptionStringGrid
        Left = 0
        Top = 44
        Width = 848
        Height = 86
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        ColCount = 7
        DefaultColWidth = 76
        DefaultRowHeight = 21
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goTabs]
        ScrollBars = ssVertical
        TabOrder = 4
        OnEnter = grdDosesEnter
        OnExit = grdDosesExit
        OnKeyDown = grdDosesKeyDown
        OnKeyPress = grdDosesKeyPress
        OnMouseDown = grdDosesMouseDown
        OnMouseUp = grdDosesMouseUp
        Caption = 'Complex Dosage'
        JustToTab = True
        ExplicitWidth = 708
        ExplicitHeight = 48
        ColWidths = (
          76
          76
          76
          76
          76
          76
          76)
      end
      object lblGuideline: TStaticText
        Left = 1
        Top = 6
        Width = 224
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Display Restrictions/Guidelines'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentColor = False
        ParentFont = False
        ShowAccelChar = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        Visible = False
        OnClick = lblGuidelineClick
      end
      object tabDose: TTabControl
        Left = 1
        Top = 23
        Width = 216
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 3
        Tabs.Strings = (
          'Dosage'
          'Complex')
        TabIndex = 0
        TabStop = False
        TabWidth = 86
        OnChange = tabDoseChange
      end
      object cboDosage: TORComboBox
        Left = 1
        Top = 44
        Width = 478
        Height = 85
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Dosage'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '5,3,6'
        Sorted = False
        SynonymChars = '<>'
        TabPositions = '27,32'
        TabOrder = 5
        Text = ''
        OnChange = cboDosageChange
        OnClick = cboDosageClick
        OnExit = cboDosageExit
        OnKeyUp = cboDosageKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
        ExplicitWidth = 338
        ExplicitHeight = 47
      end
      object cboRoute: TORComboBox
        Left = 479
        Top = 44
        Width = 139
        Height = 86
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = True
        Caption = 'Route'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        ParentShowHint = False
        Pieces = '2'
        ShowHint = True
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 6
        Text = ''
        OnChange = cboRouteChange
        OnClick = ControlChange
        OnExit = cboRouteExit
        OnKeyUp = cboRouteKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
        ExplicitLeft = 339
        ExplicitHeight = 48
      end
      object cboSchedule: TORComboBox
        Left = 620
        Top = 44
        Width = 219
        Height = 86
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight, akBottom]
        Style = orcsSimple
        AutoSelect = False
        Caption = 'Schedule'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = True
        SynonymChars = '<>'
        TabOrder = 7
        Text = ''
        OnChange = cboScheduleChange
        OnClick = cboScheduleClick
        OnEnter = cboScheduleEnter
        OnExit = cboScheduleExit
        OnKeyUp = cboScheduleKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
        ExplicitLeft = 480
        ExplicitHeight = 48
      end
      object chkPRN: TCheckBox
        Left = 787
        Top = 46
        Width = 52
        Height = 22
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        Color = clBtnFace
        ParentColor = False
        TabOrder = 8
        OnClick = chkPRNClick
        ExplicitLeft = 647
      end
      object btnXInsert: TButton
        Left = 626
        Top = 4
        Width = 97
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Insert Row'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnXInsertClick
      end
      object btnXRemove: TButton
        Left = 731
        Top = 4
        Width = 97
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Remove Row'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnXRemoveClick
      end
      object pnlXAdminTime: TPanel
        Left = 532
        Top = 183
        Width = 80
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'pnlXAdminTime'
        TabOrder = 9
        Visible = False
        OnClick = pnlXAdminTimeClick
      end
    end
    object cboXDosage: TORComboBox
      Left = 60
      Top = 150
      Width = 89
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Dosage'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '5'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 1
      Text = ''
      Visible = False
      OnChange = cboXDosageChange
      OnClick = cboXDosageClick
      OnEnter = cboXDosageEnter
      OnExit = cboXDosageExit
      OnKeyDown = memMessageKeyDown
      OnKeyUp = cboXDosageKeyUp
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object cboXRoute: TORComboBox
      Left = 150
      Top = 150
      Width = 89
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = False
      Caption = 'Route'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      Visible = False
      OnChange = cboXRouteChange
      OnClick = cboXRouteClick
      OnEnter = cboXRouteEnter
      OnExit = cboXRouteExit
      OnKeyDown = memMessageKeyDown
      CharsNeedMatch = 1
      UniqueAutoComplete = True
    end
    object pnlXDuration: TPanel
      Left = 369
      Top = 150
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BevelOuter = bvNone
      TabOrder = 4
      Visible = False
      OnEnter = pnlXDurationEnter
      OnExit = pnlXDurationExit
      DesignSize = (
        89
        26)
      object pnlXDurationButton: TKeyClickPanel
        Left = 48
        Top = 1
        Width = 41
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = 'Duration'
        TabOrder = 2
        TabStop = True
        OnClick = btnXDurationClick
        OnEnter = pnlXDurationButtonEnter
        object btnXDuration: TSpeedButton
          Left = 0
          Top = 0
          Width = 41
          Height = 23
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'days'
          Flat = True
          Glyph.Data = {
            AE000000424DAE0000000000000076000000280000000E000000070000000100
            0400000000003800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
            330033333333333333003330333333733300330003333F87330030000033FFFF
            F30033333333333333003333333333333300}
          Layout = blGlyphRight
          NumGlyphs = 2
          Spacing = 0
          Transparent = False
          OnClick = btnXDurationClick
        end
      end
      object txtXDuration: TCaptionEdit
        Left = 0
        Top = 0
        Width = 31
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akBottom]
        TabOrder = 0
        Text = '0'
        OnChange = txtXDurationChange
        OnKeyDown = memMessageKeyDown
        Caption = 'Duration'
      end
      object spnXDuration: TUpDown
        Left = 31
        Top = 0
        Width = 18
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akBottom]
        Associate = txtXDuration
        Max = 999
        TabOrder = 1
      end
    end
    object pnlXSchedule: TPanel
      Left = 240
      Top = 150
      Width = 130
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      BevelOuter = bvNone
      TabOrder = 3
      Visible = False
      OnEnter = pnlXScheduleEnter
      OnExit = pnlXScheduleExit
      DesignSize = (
        130
        26)
      object cboXSchedule: TORComboBox
        Left = 0
        Top = 0
        Width = 78
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Style = orcsDropDown
        AutoSelect = False
        Caption = 'Schedule'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = False
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '1'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 0
        TabStop = True
        Text = ''
        OnChange = cboXScheduleChange
        OnClick = cboXScheduleClick
        OnEnter = cboXScheduleEnter
        OnExit = cboXScheduleExit
        OnKeyDown = memMessageKeyDown
        OnKeyUp = cboXScheduleKeyUp
        CharsNeedMatch = 1
        UniqueAutoComplete = True
      end
      object chkXPRN: TCheckBox
        Left = 78
        Top = 5
        Width = 51
        Height = 13
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'PRN'
        TabOrder = 1
        OnClick = chkXPRNClick
        OnKeyDown = memMessageKeyDown
      end
    end
    object pnlBottom: TPanel
      Left = 0
      Top = 136
      Width = 849
      Height = 336
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alBottom
      TabOrder = 6
      ExplicitTop = 98
      ExplicitWidth = 709
      DesignSize = (
        849
        336)
      object lblComment: TLabel
        Left = 8
        Top = 8
        Width = 67
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Comments:'
      end
      object lblDays: TLabel
        Left = 5
        Top = 80
        Width = 77
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Days Supply'
      end
      object lblQuantity: TLabel
        Left = 100
        Top = 80
        Width = 48
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Quantity'
        ParentShowHint = False
        ShowHint = True
      end
      object lblRefills: TLabel
        Left = 172
        Top = 80
        Width = 37
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Refills'
      end
      object lblPriority: TLabel
        Left = 754
        Top = 75
        Width = 41
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Caption = 'Priority'
        ExplicitLeft = 740
      end
      object Image1: TImage
        Left = 6
        Top = 272
        Width = 38
        Height = 38
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akBottom]
        Visible = False
      end
      object chkDoseNow: TCheckBox
        Left = 4
        Top = 128
        Width = 304
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Give additional dose now'
        TabOrder = 14
        OnClick = chkDoseNowClick
      end
      object memComment: TCaptionMemo
        Left = 77
        Top = 2
        Width = 759
        Height = 53
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        ScrollBars = ssVertical
        TabOrder = 0
        OnChange = ControlChange
        OnClick = memCommentClick
        Caption = 'Comments'
      end
      object lblQtyMsg: TStaticText
        Left = 5
        Top = 58
        Width = 252
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '>> Quantity Dispensed: Multiples of 100 <<'
        TabOrder = 1
      end
      object txtSupply: TCaptionEdit
        Left = 2
        Top = 96
        Width = 74
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        TabOrder = 4
        Text = '0'
        OnChange = txtSupplyChange
        OnClick = txtSupplyClick
        Caption = 'Days Supply'
      end
      object spnSupply: TUpDown
        Left = 76
        Top = 96
        Width = 19
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Associate = txtSupply
        Max = 32766
        TabOrder = 5
      end
      object txtQuantity: TCaptionEdit
        Left = 98
        Top = 96
        Width = 50
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        TabOrder = 6
        Text = '0'
        OnChange = txtQuantityChange
        OnClick = txtQuantityClick
        Caption = 'Quantity'
      end
      object spnQuantity: TUpDown
        Left = 148
        Top = 96
        Width = 19
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Associate = txtQuantity
        Max = 32766
        TabOrder = 7
      end
      object txtRefills: TCaptionEdit
        Left = 172
        Top = 96
        Width = 37
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = False
        TabOrder = 8
        Text = '0'
        OnChange = txtRefillsChange
        OnClick = txtRefillsClick
        Caption = 'Refills'
      end
      object spnRefills: TUpDown
        Left = 209
        Top = 96
        Width = 19
        Height = 26
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Associate = txtRefills
        Max = 11
        TabOrder = 9
      end
      object grpPickup: TGroupBox
        Left = 231
        Top = 81
        Width = 212
        Height = 45
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Pick Up'
        TabOrder = 2
        object radPickWindow: TRadioButton
          Left = 129
          Top = 17
          Width = 72
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Window'
          TabOrder = 2
          OnClick = ControlChange
        end
        object radPickMail: TRadioButton
          Left = 71
          Top = 17
          Width = 47
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Mail'
          TabOrder = 1
          OnClick = ControlChange
        end
        object radPickClinic: TRadioButton
          Left = 9
          Top = 17
          Width = 54
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Clinic'
          TabOrder = 0
          OnClick = ControlChange
        end
      end
      object cboPriority: TORComboBox
        Left = 752
        Top = 94
        Width = 89
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akTop, akRight]
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Priority'
        Color = clWindow
        DropDownCount = 8
        ItemHeight = 16
        ItemTipColor = clWindow
        ItemTipEnable = True
        ListItemsOnly = True
        LongList = False
        LookupPiece = 0
        MaxLength = 0
        Pieces = '2'
        Sorted = False
        SynonymChars = '<>'
        TabOrder = 3
        Text = ''
        OnChange = ControlChange
        OnKeyUp = cboPriorityKeyUp
        CharsNeedMatch = 1
        ExplicitLeft = 612
      end
      object stcPI: TStaticText
        Left = 2
        Top = 151
        Width = 107
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Patient Instruction'
        TabOrder = 17
        Visible = False
      end
      object chkPtInstruct: TCheckBox
        Left = 5
        Top = 169
        Width = 17
        Height = 25
        Hint = 
          'A check in this box WILL INCLUDE the patientins tructions in thi' +
          's order.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        BiDiMode = bdLeftToRight
        Color = clBtnFace
        ParentBiDiMode = False
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 18
        Visible = False
        OnClick = chkPtInstructClick
      end
      object memPI: TMemo
        Left = 28
        Top = 171
        Width = 808
        Height = 43
        Hint = 
          'A check in this box below WILL INCLUDE the patients instructions' +
          ' in this order.'
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabStop = False
        Anchors = [akLeft, akTop, akRight]
        ParentShowHint = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 19
        Visible = False
        OnClick = memPIClick
        OnKeyDown = memPIKeyDown
        ExplicitWidth = 668
      end
      object memDrugMsg: TMemo
        Left = 46
        Top = 271
        Width = 790
        Height = 63
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akRight, akBottom]
        Color = clCream
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 20
        Visible = False
        ExplicitWidth = 650
      end
      object lblAdminSch: TMemo
        Left = 423
        Top = 148
        Width = 219
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Anchors = [akLeft, akTop, akRight]
        Color = clCream
        ParentShowHint = False
        ReadOnly = True
        ScrollBars = ssVertical
        ShowHint = True
        TabOrder = 16
        Visible = False
        ExplicitWidth = 79
      end
      object lblAdminTime: TVA508StaticText
        Name = 'lblAdminTime'
        Left = 202
        Top = 143
        Width = 85
        Height = 18
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Alignment = taLeftJustify
        Caption = 'lblAdminTime'
        TabOrder = 15
        TabStop = True
        ShowAccelChar = True
      end
    end
    object cboXSequence: TORComboBox
      Left = 539
      Top = 150
      Width = 79
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsDropDown
      AutoSelect = True
      Caption = 'Sequence'
      Color = clWindow
      DropDownCount = 8
      Items.Strings = (
        'and'
        'then')
      ItemHeight = 16
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = False
      LongList = False
      LookupPiece = 0
      MaxLength = 0
      Sorted = False
      SynonymChars = '<>'
      TabOrder = 5
      Text = ''
      Visible = False
      OnChange = cboXSequenceChange
      OnEnter = cboXSequenceEnter
      OnExit = cboXSequenceExit
      OnKeyDown = memMessageKeyDown
      OnKeyUp = cboXSequenceKeyUp
      CharsNeedMatch = 1
    end
  end
  inherited cmdAccept: TButton
    Left = 767
    Top = 505
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 4
    TabStop = False
    Visible = False
    ExplicitLeft = 627
    ExplicitTop = 467
  end
  inherited cmdQuit: TButton
    Left = 767
    Top = 536
    Width = 63
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    TabOrder = 8
    ExplicitLeft = 627
    ExplicitTop = 498
    ExplicitWidth = 63
  end
  inherited pnlMessage: TPanel
    Left = 38
    Top = 246
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 1
    OnEnter = pnlMessageEnter
    ExplicitLeft = 38
    ExplicitTop = 246
    inherited imgMessage: TImage
      Left = 2
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ExplicitLeft = 2
    end
    inherited memMessage: TRichEdit
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      OnKeyDown = memMessageKeyDown
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Data = (
      (
        'Component = pnlMeds'
        'Status = stsDefault')
      (
        'Component = lstQuick'
        'Text = Quick Orders'
        'Status = stsOK')
      (
        'Component = lstAll'
        'Text = Medications'
        'Status = stsOK')
      (
        'Component = txtMed'
        'Text = Medication'
        'Status = stsOK')
      (
        'Component = btnSelect'
        'Status = stsDefault')
      (
        'Component = pnlFields'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = grdDoses'
        'Status = stsDefault')
      (
        'Component = lblGuideline'
        'Status = stsDefault')
      (
        'Component = tabDose'
        'Status = stsDefault')
      (
        'Component = cboDosage'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = btnXInsert'
        'Status = stsDefault')
      (
        'Component = btnXRemove'
        'Status = stsDefault')
      (
        'Component = pnlXAdminTime'
        'Status = stsDefault')
      (
        'Component = cboXDosage'
        'Status = stsDefault')
      (
        'Component = cboXRoute'
        'Status = stsDefault')
      (
        'Component = pnlXDuration'
        'Status = stsDefault')
      (
        'Component = pnlXDurationButton'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Status = stsDefault')
      (
        'Component = spnXDuration'
        'Status = stsDefault')
      (
        'Component = pnlXSchedule'
        'Status = stsDefault')
      (
        'Component = cboXSchedule'
        'Status = stsDefault')
      (
        'Component = chkXPRN'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
      (
        'Component = memComment'
        'Status = stsDefault')
      (
        'Component = lblQtyMsg'
        'Status = stsDefault')
      (
        'Component = txtSupply'
        'Status = stsDefault')
      (
        'Component = spnSupply'
        'Status = stsDefault')
      (
        'Component = txtQuantity'
        'Status = stsDefault')
      (
        'Component = spnQuantity'
        'Status = stsDefault')
      (
        'Component = txtRefills'
        'Status = stsDefault')
      (
        'Component = spnRefills'
        'Status = stsDefault')
      (
        'Component = grpPickup'
        'Status = stsDefault')
      (
        'Component = radPickWindow'
        'Status = stsDefault')
      (
        'Component = radPickMail'
        'Status = stsDefault')
      (
        'Component = radPickClinic'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = stcPI'
        'Status = stsDefault')
      (
        'Component = chkPtInstruct'
        'Status = stsDefault')
      (
        'Component = memPI'
        'Status = stsDefault')
      (
        'Component = memDrugMsg'
        'Status = stsDefault')
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
        'Component = frmODMeds'
        'Status = stsDefault')
      (
        'Component = cboXSequence'
        'Status = stsDefault')
      (
        'Component = lblAdminSch'
        'Text = Admin Schedule.'
        'Status = stsOK')
      (
        'Component = lblAdminTime'
        'Status = stsDefault'))
  end
  object dlgStart: TORDateTimeDlg
    FMDateTime = 3001101.000000000000000000
    DateOnly = False
    RequireTime = True
    Left = 444
    Top = 336
  end
  object timCheckChanges: TTimer
    Enabled = False
    Interval = 500
    OnTimer = timCheckChangesTimer
    Left = 477
    Top = 336
  end
  object popDuration: TPopupMenu
    AutoHotkeys = maManual
    Left = 380
    Top = 145
    object popBlank: TMenuItem
      Caption = '(no selection)'
      OnClick = popDurationClick
    end
    object months1: TMenuItem
      Tag = 5
      Caption = 'months'
      OnClick = popDurationClick
    end
    object weeks1: TMenuItem
      Tag = 4
      Caption = 'weeks'
      OnClick = popDurationClick
    end
    object popDays: TMenuItem
      Tag = 3
      Caption = 'days'
      OnClick = popDurationClick
    end
    object hours1: TMenuItem
      Tag = 2
      Caption = 'hours'
      OnClick = popDurationClick
    end
    object minutes1: TMenuItem
      Tag = 1
      Caption = 'minutes'
      OnClick = popDurationClick
    end
  end
end
