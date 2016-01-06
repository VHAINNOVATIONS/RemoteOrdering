inherited frmTIUView: TfrmTIUView
  Left = 357
  Top = 111
  BorderIcons = []
  Caption = 'List Selected Documents'
  ClientHeight = 537
  ClientWidth = 441
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 366
  ExplicitHeight = 463
  PixelsPerInch = 120
  TextHeight = 16
  object pnlBase: TORAutoPanel [0]
    Left = 0
    Top = 0
    Width = 441
    Height = 537
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lblBeginDate: TLabel
      Left = 235
      Top = 123
      Width = 92
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Beginning Date'
    end
    object lblEndDate: TLabel
      Left = 235
      Top = 188
      Width = 74
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Ending Date'
    end
    object lblAuthor: TLabel
      Left = 12
      Top = 119
      Width = 38
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Author'
    end
    object lblStatus: TLabel
      Left = 14
      Top = 6
      Width = 37
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Status'
    end
    object lblMaxDocs: TLabel
      Left = 236
      Top = 6
      Width = 132
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Max Number to Return'
    end
    object lblContains: TLabel
      Left = 240
      Top = 436
      Width = 55
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Contains:'
    end
    object Bevel1: TBevel
      Left = 10
      Top = 430
      Width = 422
      Height = 59
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object Bevel2: TBevel
      Left = 11
      Top = 252
      Width = 422
      Height = 5
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
    end
    object calBeginDate: TORDateBox
      Left = 235
      Top = 140
      Width = 192
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 3
      DateOnly = False
      RequireTime = False
      Caption = 'Beginning Date'
    end
    object calEndDate: TORDateBox
      Left = 235
      Top = 207
      Width = 192
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      TabOrder = 4
      DateOnly = False
      RequireTime = False
      Caption = 'Ending Date'
    end
    object lstStatus: TORListBox
      Left = 12
      Top = 22
      Width = 207
      Height = 91
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ExtendedSelect = False
      Items.Strings = (
        '1^Signed documents (all)'
        '2^Unsigned documents  '
        '3^Uncosigned documents'
        '4^Signed documents/author'
        '5^Signed documents/date range')
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Caption = 'Status'
      ItemTipColor = clWindow
      LongList = False
      Pieces = '2'
      OnChange = lstStatusSelect
    end
    object cmdOK: TButton
      Left = 241
      Top = 501
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'OK'
      Default = True
      TabOrder = 10
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 342
      Top = 501
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 11
      OnClick = cmdCancelClick
    end
    object cboAuthor: TORComboBox
      Left = 12
      Top = 138
      Width = 208
      Height = 108
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Style = orcsSimple
      AutoSelect = True
      Caption = 'Author'
      Color = clWindow
      DropDownCount = 8
      ItemHeight = 13
      ItemTipColor = clWindow
      ItemTipEnable = True
      ListItemsOnly = True
      LongList = True
      LookupPiece = 0
      MaxLength = 0
      Pieces = '2'
      Sorted = True
      SynonymChars = '<>'
      TabOrder = 2
      Text = ''
      OnNeedData = cboAuthorNeedData
      CharsNeedMatch = 1
    end
    object edMaxDocs: TCaptionEdit
      Left = 236
      Top = 22
      Width = 192
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      MaxLength = 6
      TabOrder = 1
      Caption = 'Max Number to Return'
    end
    object txtKeyword: TCaptionEdit
      Left = 240
      Top = 454
      Width = 178
      Height = 21
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      Caption = 'Contains'
    end
    object grpListView: TGroupBox
      Left = 239
      Top = 263
      Width = 194
      Height = 160
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Sort Note List'
      TabOrder = 6
      object lblSortBy: TLabel
        Left = 14
        Top = 87
        Width = 46
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Sort By:'
      end
      object radListSort: TRadioGroup
        Left = 10
        Top = 25
        Width = 175
        Height = 60
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Note List Sort Order'
        Items.Strings = (
          '&Ascending'
          '&Descending')
        TabOrder = 0
      end
      object cboSortBy: TORComboBox
        Left = 14
        Top = 105
        Width = 168
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Sort By'
        Color = clWindow
        DropDownCount = 8
        Items.Strings = (
          'R^Date of Note'
          'D^Title'
          'S^Subject'
          'A^Author'
          'L^Location')
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
        TabOrder = 1
        Text = ''
        CharsNeedMatch = 1
      end
      object ckShowSubject: TCheckBox
        Left = 14
        Top = 135
        Width = 161
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Show subject in list'
        TabOrder = 2
      end
    end
    object grpTreeView: TGroupBox
      Left = 10
      Top = 263
      Width = 215
      Height = 160
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Note Tree View'
      TabOrder = 5
      object lblGroupBy: TOROffsetLabel
        Left = 11
        Top = 97
        Width = 60
        Height = 19
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Group By:'
        HorzOffset = 2
        Transparent = False
        VertOffset = 2
        WordWrap = False
      end
      object cboGroupBy: TORComboBox
        Left = 11
        Top = 114
        Width = 188
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Style = orcsDropDown
        AutoSelect = True
        Caption = 'Group By'
        Color = clWindow
        DropDownCount = 8
        Items.Strings = (
          'D^Visit Date'
          'L^Location'
          'T^Title'
          'A^Author')
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
        TabOrder = 1
        Text = ''
        CharsNeedMatch = 1
      end
      object radTreeSort: TRadioGroup
        Left = 11
        Top = 25
        Width = 191
        Height = 60
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Note Tree View Sort Order'
        Items.Strings = (
          '&Chronological'
          '&Reverse chronological')
        TabOrder = 0
      end
    end
    object cmdClear: TButton
      Left = 10
      Top = 501
      Width = 180
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Clear Sort/Group/Search'
      TabOrder = 9
      OnClick = cmdClearClick
    end
    object grpWhereEitherOf: TGroupBox
      Left = 20
      Top = 433
      Width = 208
      Height = 51
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Caption = 'Where either of:'
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 7
      object ckTitle: TCheckBox
        Left = 60
        Top = 20
        Width = 62
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Title'
        TabOrder = 0
      end
      object ckSubject: TCheckBox
        Left = 126
        Top = 20
        Width = 80
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Subject'
        TabOrder = 1
      end
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
        'Component = lstStatus'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = cboAuthor'
        'Status = stsDefault')
      (
        'Component = edMaxDocs'
        'Status = stsDefault')
      (
        'Component = txtKeyword'
        'Status = stsDefault')
      (
        'Component = grpListView'
        'Status = stsDefault')
      (
        'Component = radListSort'
        'Status = stsDefault')
      (
        'Component = cboSortBy'
        'Status = stsDefault')
      (
        'Component = ckShowSubject'
        'Status = stsDefault')
      (
        'Component = grpTreeView'
        'Status = stsDefault')
      (
        'Component = cboGroupBy'
        'Status = stsDefault')
      (
        'Component = radTreeSort'
        'Status = stsDefault')
      (
        'Component = cmdClear'
        'Status = stsDefault')
      (
        'Component = grpWhereEitherOf'
        'Status = stsDefault')
      (
        'Component = ckTitle'
        'Status = stsDefault')
      (
        'Component = ckSubject'
        'Status = stsDefault')
      (
        'Component = frmTIUView'
        'Status = stsDefault'))
  end
end
