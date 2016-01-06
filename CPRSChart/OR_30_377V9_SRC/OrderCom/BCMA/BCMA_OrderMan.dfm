object frmCPRSOrderManager: TfrmCPRSOrderManager
  Left = 983
  Top = 314
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Order Manager'
  ClientHeight = 394
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 0
    Top = 97
    Width = 372
    Height = 105
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 50
      Top = 20
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Provider: '
    end
    object Label2: TLabel
      Left = 28
      Top = 46
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = 'Injection Site: '
    end
    object Label3: TLabel
      Left = 8
      Top = 72
      Width = 87
      Height = 13
      Hint = 'Enter action date@time, or '#39'N'#39' for now'
      Alignment = taRightJustify
      Caption = 'Action Date/Time:'
      ParentShowHint = False
      ShowHint = True
    end
    object cbxInjectionSite: TComboBox
      Left = 104
      Top = 42
      Width = 257
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = FieldChange
    end
    object edtActionDateTime: TEdit
      Left = 104
      Top = 69
      Width = 257
      Height = 21
      Hint = 'Enter action date@time, or '#39'N'#39' for now'
      CharCase = ecUpperCase
      MaxLength = 50
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnChange = FieldChange
      OnExit = edtActionDateTimeExit
    end
    object edtProvider: TEdit
      Left = 104
      Top = 15
      Width = 256
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 50
      TabOrder = 0
      OnExit = edtProviderExit
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 202
    Width = 372
    Height = 91
    Align = alTop
    Caption = 'Medications and/or Solutions Scanned'
    TabOrder = 3
    DesignSize = (
      372
      91)
    object lstMedSol: TListBox
      Left = 9
      Top = 15
      Width = 353
      Height = 66
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object btnReviewSign: TButton
    Left = 25
    Top = 355
    Width = 97
    Height = 25
    Caption = '&Review/Sign'
    Enabled = False
    TabOrder = 4
    OnClick = btnReviewSignClick
  end
  object Button2: TButton
    Left = 137
    Top = 355
    Width = 97
    Height = 25
    Caption = '&Order'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 250
    Top = 355
    Width = 97
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 6
    OnClick = Button3Click
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 372
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox3: TGroupBox
      Left = 145
      Top = 0
      Width = 227
      Height = 97
      Align = alClient
      Caption = 'IV'#39's: '
      TabOrder = 1
      object lblIVType: TLabel
        Left = 11
        Top = 19
        Width = 40
        Height = 13
        Caption = 'IV Type:'
      end
      object lblIntSyringe: TLabel
        Left = 11
        Top = 45
        Width = 53
        Height = 13
        Caption = 'Int Syringe:'
        Enabled = False
      end
      object lblSchedule: TLabel
        Left = 11
        Top = 71
        Width = 48
        Height = 13
        Caption = 'Schedule:'
        Enabled = False
      end
      object cbxIVType: TComboBox
        Left = 67
        Top = 15
        Width = 149
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbxIVTypeChange
        Items.Strings = (
          'Admixture'
          'Piggyback'
          'Syringe')
      end
      object cbxIntSyringe: TComboBox
        Left = 67
        Top = 41
        Width = 149
        Height = 21
        Style = csDropDownList
        Enabled = False
        TabOrder = 1
        OnChange = cbxIntSyringeChange
        Items.Strings = (
          'Yes'
          'No')
      end
      object cbxSchedule: TComboBox
        Left = 67
        Top = 67
        Width = 149
        Height = 21
        Style = csDropDownList
        Enabled = False
        TabOrder = 2
        Visible = False
        Items.Strings = (
          'Now'
          'Stat')
      end
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 145
      Height = 97
      Align = alLeft
      Caption = 'Order Type: '
      TabOrder = 0
      object rbtnUD: TRadioButton
        Left = 8
        Top = 24
        Width = 73
        Height = 17
        Caption = 'Unit Dose'
        TabOrder = 0
        TabStop = True
        OnClick = rbtnIVClick
      end
      object rbtnIV: TRadioButton
        Left = 8
        Top = 40
        Width = 73
        Height = 17
        Caption = 'IV'
        TabOrder = 1
        OnClick = rbtnIVClick
      end
    end
  end
  object pnlLower: TPanel
    Left = 0
    Top = 293
    Width = 372
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object GroupBox5: TGroupBox
      Left = 0
      Top = 0
      Width = 113
      Height = 57
      Align = alLeft
      Caption = 'Scanner Status: '
      TabOrder = 0
      object Label6: TLabel
        Left = 2
        Top = 39
        Width = 109
        Height = 16
        Align = alClient
        Alignment = taCenter
        Caption = 'Not Ready'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 51
        ExplicitHeight = 13
      end
      object pnlScannerIndicator: TPanel
        Left = 2
        Top = 15
        Width = 109
        Height = 24
        Hint = 'Enable Bar Code Scanner'
        Align = alTop
        BevelInner = bvLowered
        BorderWidth = 1
        Color = clRed
        ParentBackground = False
        TabOrder = 0
        OnClick = pnlScannerIndicatorClick
      end
    end
    object GroupBox6: TGroupBox
      Left = 113
      Top = 0
      Width = 259
      Height = 57
      Align = alClient
      Caption = 'Scan Medication Bar Code: '
      TabOrder = 1
      DesignSize = (
        259
        57)
      object edtOMScannerInput: TEdit
        Left = 8
        Top = 18
        Width = 241
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        CharCase = ecUpperCase
        MaxLength = 40
        TabOrder = 0
        OnChange = FieldChange
        OnEnter = edtOMScannerInputEnter
        OnExit = edtOMScannerInputExit
        OnKeyPress = edtOMScannerInputKeyPress
      end
    end
  end
end
