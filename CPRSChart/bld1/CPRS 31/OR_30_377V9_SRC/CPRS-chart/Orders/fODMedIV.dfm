inherited frmODMedIV: TfrmODMedIV
  Left = 246
  Top = 256
  Width = 743
  Height = 667
  Caption = 'Infusion Order'
  Constraints.MinHeight = 400
  Constraints.MinWidth = 400
  DoubleBuffered = True
  ExplicitWidth = 743
  ExplicitHeight = 667
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlMessage: TPanel [0]
    Left = 104
    Top = 601
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 0
    ExplicitLeft = 104
    ExplicitTop = 601
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
  object ScrollBox1: TScrollBox [1]
    Left = 0
    Top = 0
    Width = 727
    Height = 629
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 5
    OnResize = ScrollBox1Resize
    ExplicitWidth = 722
    ExplicitHeight = 626
    object pnlForm: TPanel
      Left = 0
      Top = 0
      Width = 727
      Height = 600
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 722
      object pnlB1: TPanel
        Left = 0
        Top = 315
        Width = 727
        Height = 285
        Align = alBottom
        TabOrder = 0
        ExplicitWidth = 722
        object pnlBottom: TPanel
          Left = 1
          Top = 175
          Width = 725
          Height = 109
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 720
          object Label1: TLabel
            AlignWithMargins = True
            Left = 5
            Top = 24
            Width = 717
            Height = 13
            Margins.Left = 5
            Align = alTop
            Caption = 'Order Sig'
            ExplicitWidth = 44
          end
          object lbl508Required: TVA508StaticText
            Name = 'lbl508Required'
            AlignWithMargins = True
            Left = 5
            Top = 3
            Width = 717
            Height = 15
            Margins.Left = 5
            Align = alTop
            Alignment = taLeftJustify
            Caption = ' * Indicates a Required Field'
            TabOrder = 0
            ShowAccelChar = True
            ExplicitWidth = 712
          end
          object pnlButtons: TPanel
            Left = 634
            Top = 40
            Width = 91
            Height = 69
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitLeft = 629
          end
          object pnlMemOrder: TPanel
            Left = 0
            Top = 40
            Width = 634
            Height = 69
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 2
            ExplicitWidth = 629
          end
        end
        object lblFirstDose: TVA508StaticText
          Name = 'lblFirstDose'
          AlignWithMargins = True
          Left = 4
          Top = 129
          Width = 719
          Height = 15
          Align = alBottom
          Alignment = taLeftJustify
          Caption = 'First Dose'
          TabOrder = 1
          TabStop = True
          Visible = False
          ShowAccelChar = True
          ExplicitWidth = 714
        end
        object lblAdminTime: TVA508StaticText
          Name = 'lblAdminTime'
          AlignWithMargins = True
          Left = 4
          Top = 150
          Width = 719
          Height = 15
          Margins.Bottom = 10
          Align = alBottom
          Alignment = taLeftJustify
          Caption = 'Admin Time'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          TabStop = True
          Visible = False
          ShowAccelChar = True
          ExplicitWidth = 714
        end
        object pnlMiddle: TGridPanel
          Left = 1
          Top = 1
          Width = 725
          Height = 95
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end
            item
              Value = 25.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = pnlMiddleSub1
              Row = 0
            end
            item
              Column = 1
              Control = pnlMiddleSub2
              Row = 0
            end
            item
              Column = 2
              Control = pnlMiddleSub3
              Row = 0
            end
            item
              Column = 3
              Control = pnlMiddleSub4
              Row = 0
            end>
          RowCollection = <
            item
              Value = 100.000000000000000000
            end>
          TabOrder = 3
          ExplicitWidth = 720
          object pnlMiddleSub1: TGridPanel
            Left = 0
            Top = 0
            Width = 181
            Height = 95
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS11
                Row = 0
              end
              item
                Column = 0
                Control = pnlMS12
                Row = 1
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 0
            ExplicitWidth = 180
            object pnlMS11: TPanel
              Left = 0
              Top = 0
              Width = 181
              Height = 47
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 180
              object Panel8: TPanel
                Left = 0
                Top = 0
                Width = 181
                Height = 16
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                ExplicitWidth = 180
                object txtAllIVRoutes: TLabel
                  Left = 52
                  Top = 0
                  Width = 129
                  Height = 16
                  Align = alRight
                  Caption = '(Expanded Med Route List)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlue
                  Font.Height = -12
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  Visible = False
                  OnClick = txtAllIVRoutesClick
                  ExplicitLeft = 51
                  ExplicitHeight = 13
                end
                object lblRoute: TLabel
                  AlignWithMargins = True
                  Left = 5
                  Top = 0
                  Width = 47
                  Height = 16
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alClient
                  Caption = 'Route*'
                  ExplicitWidth = 33
                  ExplicitHeight = 13
                end
              end
              object cboRoute: TORComboBox
                AlignWithMargins = True
                Left = 3
                Top = 19
                Width = 175
                Height = 21
                Style = orcsDropDown
                Align = alClient
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
                TabOrder = 1
                Text = ''
                OnChange = cboRouteChange
                OnClick = cboRouteClick
                OnExit = cboRouteExit
                OnKeyDown = cboRouteKeyDown
                OnKeyUp = cboRouteKeyUp
                CharsNeedMatch = 1
                UniqueAutoComplete = True
                ExplicitWidth = 174
              end
            end
            object pnlMS12: TPanel
              Left = 0
              Top = 47
              Width = 181
              Height = 48
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitWidth = 180
              object lblPriority: TLabel
                AlignWithMargins = True
                Left = 5
                Top = 3
                Width = 173
                Height = 13
                Margins.Left = 5
                Align = alTop
                Caption = 'Priority*'
                ExplicitWidth = 35
              end
              object cboPriority: TORComboBox
                AlignWithMargins = True
                Left = 5
                Top = 19
                Width = 176
                Height = 21
                Margins.Left = 5
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                Style = orcsDropDown
                Align = alClient
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
                TabOrder = 0
                Text = ''
                OnChange = cboPriorityChange
                OnExit = cboPriorityExit
                OnKeyUp = cboPriorityKeyUp
                CharsNeedMatch = 1
                ExplicitWidth = 175
              end
            end
          end
          object pnlMiddleSub2: TGridPanel
            Left = 181
            Top = 0
            Width = 181
            Height = 95
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS21
                Row = 0
              end
              item
                Column = 0
                Control = pnlMS22
                Row = 1
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 1
            ExplicitLeft = 180
            ExplicitWidth = 180
            object pnlMS21: TPanel
              Left = 0
              Top = 0
              Width = 181
              Height = 47
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 180
              object Panel9: TPanel
                Left = 0
                Top = 0
                Width = 181
                Height = 16
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                ExplicitWidth = 180
                object lblType: TLabel
                  AlignWithMargins = True
                  Left = 5
                  Top = 0
                  Width = 78
                  Height = 16
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alClient
                  Caption = 'Type*'
                  ParentShowHint = False
                  ShowHint = True
                  ExplicitWidth = 28
                  ExplicitHeight = 13
                end
                object lblTypeHelp: TLabel
                  AlignWithMargins = True
                  Left = 83
                  Top = 0
                  Width = 68
                  Height = 16
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 30
                  Margins.Bottom = 0
                  Align = alRight
                  Caption = '(IV Type Help)'
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlue
                  Font.Height = -12
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentFont = False
                  ParentShowHint = False
                  ShowHint = False
                  OnClick = lblTypeHelpClick
                  ExplicitLeft = 82
                  ExplicitHeight = 13
                end
              end
              object cboType: TComboBox
                AlignWithMargins = True
                Left = 5
                Top = 19
                Width = 173
                Height = 21
                Margins.Left = 5
                Align = alClient
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnChange = cboTypeChange
                OnKeyDown = cboTypeKeyDown
                ExplicitWidth = 172
              end
            end
            object pnlMS22: TPanel
              Left = 0
              Top = 47
              Width = 181
              Height = 48
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 1
              ExplicitWidth = 180
              object lblLimit: TLabel
                Left = 0
                Top = 0
                Width = 181
                Height = 13
                Align = alTop
                Caption = 'Duration or Total Volume (Optional)'
                ExplicitWidth = 165
              end
              object pnlXDuration: TPanel
                Left = 0
                Top = 13
                Width = 181
                Height = 35
                Align = alClient
                BevelOuter = bvNone
                TabOrder = 0
                OnEnter = pnlXDurationEnter
                ExplicitWidth = 180
                object pnlDur: TGridPanel
                  Left = 0
                  Top = 0
                  Width = 181
                  Height = 35
                  Align = alClient
                  BevelOuter = bvNone
                  ColumnCollection = <
                    item
                      Value = 50.000000000000000000
                    end
                    item
                      Value = 50.000000000000000000
                    end>
                  ControlCollection = <
                    item
                      Column = 0
                      Control = pnlTxtDur
                      Row = 0
                    end
                    item
                      Column = 1
                      Control = pnlCbDur
                      Row = 0
                    end>
                  RowCollection = <
                    item
                      Value = 100.000000000000000000
                    end>
                  TabOrder = 0
                  ExplicitWidth = 180
                  object pnlTxtDur: TPanel
                    Left = 0
                    Top = 0
                    Width = 90
                    Height = 35
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 0
                    object txtXDuration: TCaptionEdit
                      AlignWithMargins = True
                      Left = 5
                      Top = 8
                      Width = 82
                      Height = 21
                      Margins.Left = 5
                      Margins.Top = 8
                      Margins.Bottom = 0
                      Align = alClient
                      Constraints.MaxHeight = 21
                      TabOrder = 0
                      OnChange = txtXDurationChange
                      OnExit = txtXDurationExit
                      Caption = ''
                    end
                  end
                  object pnlCbDur: TPanel
                    Left = 90
                    Top = 0
                    Width = 91
                    Height = 35
                    Align = alClient
                    BevelOuter = bvNone
                    TabOrder = 1
                    ExplicitWidth = 90
                    object cboDuration: TComboBox
                      AlignWithMargins = True
                      Left = 5
                      Top = 8
                      Width = 81
                      Height = 21
                      Margins.Left = 5
                      Margins.Top = 8
                      Margins.Right = 5
                      Align = alClient
                      AutoComplete = False
                      TabOrder = 0
                      OnChange = cboDurationChange
                      OnEnter = cboDurationEnter
                      ExplicitWidth = 80
                    end
                  end
                end
              end
            end
          end
          object pnlMiddleSub3: TGridPanel
            Left = 362
            Top = 0
            Width = 181
            Height = 95
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS31
                Row = 0
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end
              item
                SizeStyle = ssAuto
              end>
            TabOrder = 2
            ExplicitLeft = 360
            ExplicitWidth = 180
            object pnlMS31: TPanel
              Left = 0
              Top = 0
              Width = 181
              Height = 47
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 180
              object Panel10: TPanel
                Left = 0
                Top = 0
                Width = 181
                Height = 16
                Align = alTop
                BevelOuter = bvNone
                TabOrder = 0
                ExplicitWidth = 180
                object lblSchedule: TLabel
                  AlignWithMargins = True
                  Left = 5
                  Top = 0
                  Width = 87
                  Height = 16
                  Margins.Left = 5
                  Margins.Top = 0
                  Margins.Right = 0
                  Margins.Bottom = 0
                  Align = alClient
                  Caption = 'Schedule *'
                  ExplicitWidth = 52
                  ExplicitHeight = 13
                end
                object txtNSS: TLabel
                  AlignWithMargins = True
                  Left = 92
                  Top = 0
                  Width = 69
                  Height = 16
                  Margins.Left = 0
                  Margins.Top = 0
                  Margins.Right = 20
                  Margins.Bottom = 0
                  Align = alRight
                  AutoSize = False
                  Caption = '(Day-of-Week)'
                  Color = clBtnFace
                  Font.Charset = DEFAULT_CHARSET
                  Font.Color = clBlue
                  Font.Height = -12
                  Font.Name = 'MS Sans Serif'
                  Font.Style = []
                  ParentColor = False
                  ParentFont = False
                  OnClick = txtNSSClick
                  ExplicitLeft = 60
                  ExplicitTop = 1
                  ExplicitHeight = 13
                end
              end
              object cboSchedule: TORComboBox
                AlignWithMargins = True
                Left = 5
                Top = 19
                Width = 115
                Height = 21
                Margins.Left = 5
                Style = orcsDropDown
                Align = alClient
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
                TabOrder = 1
                Text = ''
                OnChange = cboScheduleChange
                OnClick = cboScheduleClick
                OnExit = cboScheduleExit
                OnKeyDown = cboScheduleKeyDown
                OnKeyUp = cboScheduleKeyUp
                CharsNeedMatch = 1
                UniqueAutoComplete = True
                ExplicitWidth = 114
              end
              object Panel6: TPanel
                Left = 123
                Top = 16
                Width = 58
                Height = 31
                Align = alRight
                BevelOuter = bvNone
                TabOrder = 2
                ExplicitLeft = 122
                object chkPRN: TCheckBox
                  AlignWithMargins = True
                  Left = 3
                  Top = 0
                  Width = 52
                  Height = 32
                  Margins.Top = 0
                  Margins.Bottom = 0
                  Align = alTop
                  Caption = 'PRN'
                  TabOrder = 0
                  OnClick = chkPRNClick
                end
              end
            end
          end
          object pnlMiddleSub4: TGridPanel
            Left = 543
            Top = 0
            Width = 182
            Height = 95
            Align = alClient
            BevelOuter = bvNone
            ColumnCollection = <
              item
                Value = 100.000000000000000000
              end>
            ControlCollection = <
              item
                Column = 0
                Control = pnlMS41
                Row = 0
              end>
            RowCollection = <
              item
                Value = 50.000000000000000000
              end
              item
                Value = 50.000000000000000000
              end>
            TabOrder = 3
            ExplicitLeft = 540
            ExplicitWidth = 180
            object pnlMS41: TPanel
              Left = 0
              Top = 0
              Width = 182
              Height = 47
              Align = alClient
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 180
              object lblInfusionRate: TLabel
                AlignWithMargins = True
                Left = 3
                Top = 0
                Width = 179
                Height = 13
                Margins.Top = 0
                Margins.Right = 0
                Margins.Bottom = 0
                Align = alTop
                Caption = 'Infusion Rate (ml/hr)*'
                ExplicitWidth = 100
              end
              object GridPanel1: TGridPanel
                Left = 0
                Top = 13
                Width = 182
                Height = 34
                Align = alClient
                BevelOuter = bvNone
                ColumnCollection = <
                  item
                    Value = 50.000000000000000000
                  end
                  item
                    Value = 50.000000000000000000
                  end>
                ControlCollection = <
                  item
                    Column = 0
                    Control = Panel1
                    Row = 0
                  end
                  item
                    Column = 1
                    Control = Panel3
                    Row = 0
                  end>
                RowCollection = <
                  item
                    Value = 100.000000000000000000
                  end>
                TabOrder = 0
                ExplicitWidth = 180
                object Panel1: TPanel
                  Left = 0
                  Top = 0
                  Width = 91
                  Height = 34
                  Align = alClient
                  BevelOuter = bvNone
                  TabOrder = 0
                  ExplicitWidth = 90
                  object txtRate: TCaptionEdit
                    AlignWithMargins = True
                    Left = 5
                    Top = 3
                    Width = 83
                    Height = 21
                    Margins.Left = 5
                    Align = alClient
                    AutoSelect = False
                    Constraints.MaxHeight = 21
                    TabOrder = 0
                    OnChange = txtRateChange
                    Caption = 'Infusion Rate'
                    ExplicitWidth = 82
                  end
                end
                object Panel3: TPanel
                  Left = 91
                  Top = 0
                  Width = 91
                  Height = 34
                  Align = alClient
                  BevelOuter = bvNone
                  TabOrder = 1
                  ExplicitLeft = 90
                  ExplicitWidth = 90
                  object cboInfusionTime: TComboBox
                    AlignWithMargins = True
                    Left = 5
                    Top = 3
                    Width = 83
                    Height = 21
                    Margins.Left = 5
                    Align = alClient
                    TabOrder = 0
                    OnChange = cboInfusionTimeChange
                    OnEnter = cboInfusionTimeEnter
                    ExplicitWidth = 82
                  end
                end
              end
            end
          end
        end
        object chkDoseNow: TCheckBox
          AlignWithMargins = True
          Left = 6
          Top = 99
          Width = 717
          Height = 17
          Margins.Left = 5
          Margins.Bottom = 10
          Align = alBottom
          Caption = 'Give Additional Dose Now'
          Constraints.MinWidth = 147
          TabOrder = 4
          OnClick = chkDoseNowClick
          ExplicitWidth = 712
        end
      end
      object pnlTop: TGridPanel
        Left = 0
        Top = 0
        Width = 727
        Height = 315
        Align = alClient
        ColumnCollection = <
          item
            Value = 32.654668176316890000
          end
          item
            Value = 67.345331823683110000
          end>
        ControlCollection = <
          item
            Column = 1
            Control = pnlTopRight
            Row = 0
          end
          item
            Column = 0
            Control = pnlCombo
            Row = 0
          end>
        RowCollection = <
          item
            Value = 100.000000000000000000
          end>
        TabOrder = 1
        ExplicitWidth = 722
        object pnlTopRight: TGridPanel
          Left = 237
          Top = 1
          Width = 489
          Height = 313
          Align = alClient
          BevelOuter = bvNone
          ColumnCollection = <
            item
              Value = 100.000000000000000000
            end>
          ControlCollection = <
            item
              Column = 0
              Control = pnlTopRightTop
              Row = 0
            end
            item
              Column = 0
              Control = Panel2
              Row = 2
            end
            item
              Column = 0
              Control = cmdRemove
              Row = 1
            end>
          RowCollection = <
            item
              Value = 48.495496523256290000
            end
            item
              Value = 8.240509903676616000
            end
            item
              Value = 43.263993573067100000
            end>
          TabOrder = 0
          ExplicitLeft = 236
          ExplicitWidth = 485
          object pnlTopRightTop: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 3
            Width = 483
            Height = 145
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
            ExplicitWidth = 479
            object pnlTopRightLbls: TPanel
              Left = 0
              Top = 0
              Width = 483
              Height = 24
              Align = alTop
              BevelOuter = bvNone
              TabOrder = 0
              ExplicitWidth = 479
              object lblAmount: TLabel
                Left = 107
                Top = 5
                Width = 84
                Height = 13
                Caption = 'Volume/Strength*'
                WordWrap = True
              end
              object lblComponent: TLabel
                Left = 4
                Top = 5
                Width = 85
                Height = 13
                Caption = 'Solution/Additive*'
              end
              object lblAddFreq: TLabel
                Left = 205
                Top = 5
                Width = 95
                Height = 13
                Caption = 'Additive Frequency*'
              end
              object lblPrevAddFreq: TLabel
                Left = 306
                Top = 5
                Width = 77
                Height = 13
                Caption = 'Prev. Add. Freq.'
              end
            end
            object grdSelected: TCaptionStringGrid
              Left = 0
              Top = 24
              Width = 483
              Height = 121
              Align = alClient
              DefaultColWidth = 100
              DefaultRowHeight = 19
              DefaultDrawing = False
              FixedCols = 0
              RowCount = 1
              FixedRows = 0
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
              ScrollBars = ssVertical
              TabOrder = 1
              OnDrawCell = grdSelectedDrawCell
              OnKeyPress = grdSelectedKeyPress
              OnMouseDown = grdSelectedMouseDown
              Caption = ''
              ExplicitWidth = 479
            end
            object txtSelected: TCaptionEdit
              Tag = -1
              Left = 22
              Top = 65
              Width = 45
              Height = 19
              Ctl3D = False
              ParentCtl3D = False
              TabOrder = 2
              Text = 'meq.'
              Visible = False
              OnChange = txtSelectedChange
              OnExit = txtSelectedExit
              OnKeyDown = txtSelectedKeyDown
              Caption = 'Volume'
            end
            object cboSelected: TCaptionComboBox
              Tag = -1
              Left = 73
              Top = 65
              Width = 53
              Height = 21
              Style = csDropDownList
              Ctl3D = False
              ParentCtl3D = False
              TabOrder = 4
              Visible = False
              OnCloseUp = cboSelectedCloseUp
              OnKeyDown = cboSelectedKeyDown
              Caption = 'Volume/Strength'
            end
            object cboAddFreq: TCaptionComboBox
              Left = 132
              Top = 65
              Width = 145
              Height = 21
              TabOrder = 6
              Visible = False
              OnCloseUp = cboAddFreqCloseUp
              OnKeyDown = cboAddFreqKeyDown
              Caption = ''
            end
          end
          object Panel2: TPanel
            AlignWithMargins = True
            Left = 3
            Top = 179
            Width = 483
            Height = 131
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            ExplicitWidth = 479
            object lblComments: TLabel
              Left = 0
              Top = 0
              Width = 483
              Height = 13
              Align = alTop
              Caption = 'Comments'
              ExplicitWidth = 49
            end
            object memComments: TCaptionMemo
              Left = 0
              Top = 13
              Width = 483
              Height = 118
              Align = alClient
              Lines.Strings = (
                'memComments')
              ScrollBars = ssVertical
              TabOrder = 0
              OnChange = ControlChange
              Caption = 'Comments'
              ExplicitWidth = 479
            end
          end
          object cmdRemove: TButton
            AlignWithMargins = True
            Left = 314
            Top = 151
            Width = 75
            Height = 25
            Margins.Left = 0
            Margins.Top = 0
            Margins.Right = 100
            Margins.Bottom = 0
            Align = alRight
            Caption = 'Remove'
            TabOrder = 2
            OnClick = cmdRemoveClick
            ExplicitLeft = 310
          end
        end
        object pnlCombo: TPanel
          AlignWithMargins = True
          Left = 6
          Top = 4
          Width = 228
          Height = 307
          Margins.Left = 5
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 1
          ExplicitWidth = 227
          object cboAdditive: TORComboBox
            Left = 0
            Top = 20
            Width = 228
            Height = 287
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
            OnExit = cboAdditiveExit
            OnMouseClick = cboAdditiveMouseClick
            OnNeedData = cboAdditiveNeedData
            CharsNeedMatch = 1
            ExplicitWidth = 227
          end
          object tabFluid: TTabControl
            Left = 0
            Top = 0
            Width = 228
            Height = 20
            Align = alTop
            TabHeight = 15
            TabOrder = 2
            Tabs.Strings = (
              '   Solutions   '
              '   Additives   ')
            TabIndex = 0
            OnChange = tabFluidChange
            ExplicitWidth = 227
          end
          object cboSolution: TORComboBox
            Left = 0
            Top = 20
            Width = 228
            Height = 287
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
            OnExit = cboSolutionExit
            OnMouseClick = cboSolutionMouseClick
            OnNeedData = cboSolutionNeedData
            CharsNeedMatch = 1
            ExplicitWidth = 227
          end
        end
      end
    end
  end
  inherited memOrder: TCaptionMemo [2]
    AlignWithMargins = True
    Left = 10
    Top = 534
    Width = 554
    Height = 49
    Margins.Left = 5
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    TabOrder = 1
    ExplicitLeft = 10
    ExplicitTop = 534
    ExplicitWidth = 554
    ExplicitHeight = 49
  end
  inherited cmdAccept: TButton [3]
    AlignWithMargins = True
    Left = 602
    Top = 536
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 2
    ExplicitLeft = 597
    ExplicitTop = 533
  end
  inherited cmdQuit: TButton [4]
    AlignWithMargins = True
    Left = 615
    Top = 565
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Anchors = [akRight, akBottom]
    TabOrder = 4
    ExplicitLeft = 610
    ExplicitTop = 562
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 32
    Top = 8
    Data = (
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
        'Component = lblAdminTime'
        'Status = stsDefault')
      (
        'Component = lblFirstDose'
        'Status = stsDefault')
      (
        'Component = lbl508Required'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault')
      (
        'Component = pnlTopRight'
        'Status = stsDefault')
      (
        'Component = pnlTopRightTop'
        'Status = stsDefault')
      (
        'Component = pnlTopRightLbls'
        'Status = stsDefault')
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
        'Component = Panel2'
        'Status = stsDefault')
      (
        'Component = memComments'
        'Status = stsDefault')
      (
        'Component = grdSelected'
        'Status = stsDefault')
      (
        'Component = txtSelected'
        'Status = stsDefault')
      (
        'Component = cboSelected'
        'Status = stsDefault')
      (
        'Component = cboAddFreq'
        'Status = stsDefault')
      (
        'Component = cmdRemove'
        'Status = stsDefault')
      (
        'Component = pnlMiddle'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub1'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub2'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub3'
        'Status = stsDefault')
      (
        'Component = pnlMiddleSub4'
        'Status = stsDefault')
      (
        'Component = pnlMS11'
        'Status = stsDefault')
      (
        'Component = pnlMS12'
        'Status = stsDefault')
      (
        'Component = pnlMS21'
        'Status = stsDefault')
      (
        'Component = pnlMS22'
        'Status = stsDefault')
      (
        'Component = pnlMS31'
        'Status = stsDefault')
      (
        'Component = pnlMS41'
        'Status = stsDefault')
      (
        'Component = Panel8'
        'Status = stsDefault')
      (
        'Component = Panel9'
        'Status = stsDefault')
      (
        'Component = Panel10'
        'Status = stsDefault')
      (
        'Component = cboPriority'
        'Status = stsDefault')
      (
        'Component = cboRoute'
        'Status = stsDefault')
      (
        'Component = cboType'
        'Status = stsDefault')
      (
        'Component = cboSchedule'
        'Status = stsDefault')
      (
        'Component = chkPRN'
        'Status = stsDefault')
      (
        'Component = pnlXDuration'
        'Status = stsDefault')
      (
        'Component = pnlDur'
        'Status = stsDefault')
      (
        'Component = pnlTxtDur'
        'Status = stsDefault')
      (
        'Component = txtXDuration'
        'Status = stsDefault')
      (
        'Component = pnlCbDur'
        'Status = stsDefault')
      (
        'Component = cboDuration'
        'Status = stsDefault')
      (
        'Component = GridPanel1'
        'Status = stsDefault')
      (
        'Component = Panel1'
        'Status = stsDefault')
      (
        'Component = txtRate'
        'Status = stsDefault')
      (
        'Component = Panel3'
        'Status = stsDefault')
      (
        'Component = cboInfusionTime'
        'Status = stsDefault')
      (
        'Component = chkDoseNow'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlButtons'
        'Status = stsDefault')
      (
        'Component = pnlMemOrder'
        'Status = stsDefault')
      (
        'Component = Panel6'
        'Status = stsDefault')
      (
        'Component = ScrollBox1'
        'Status = stsDefault')
      (
        'Component = pnlForm'
        'Status = stsDefault')
      (
        'Component = pnlB1'
        'Status = stsDefault'))
  end
  object VA508CompOrderSig: TVA508ComponentAccessibility
    Component = memOrder
    OnStateQuery = VA508CompOrderSigStateQuery
    Left = 24
    Top = 184
  end
  object VA508CompRoute: TVA508ComponentAccessibility
    Component = cboRoute
    OnInstructionsQuery = VA508CompRouteInstructionsQuery
    Left = 104
    Top = 64
  end
  object VA508CompType: TVA508ComponentAccessibility
    Component = cboType
    OnInstructionsQuery = VA508CompTypeInstructionsQuery
    Left = 104
    Top = 8
  end
  object VA508CompSchedule: TVA508ComponentAccessibility
    Component = cboSchedule
    OnInstructionsQuery = VA508CompScheduleInstructionsQuery
    Left = 32
    Top = 120
  end
  object VA508CompGrdSelected: TVA508ComponentAccessibility
    Component = grdSelected
    OnCaptionQuery = VA508CompGrdSelectedCaptionQuery
    Left = 40
    Top = 56
  end
end
