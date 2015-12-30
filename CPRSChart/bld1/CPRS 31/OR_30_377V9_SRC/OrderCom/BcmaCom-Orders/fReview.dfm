object frmReview: TfrmReview
  Left = 289
  Top = 156
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 290
  ClientWidth = 586
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    586
    290)
  PixelsPerInch = 96
  TextHeight = 13
  object lblSig: TLabel
    Left = 8
    Top = 9
    Width = 201
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Signature will be Applied to Checked Items'
  end
  object pnlSignature: TPanel
    Left = 8
    Top = 232
    Width = 373
    Height = 49
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    TabOrder = 4
    object lblESCode: TLabel
      Left = 0
      Top = 0
      Width = 123
      Height = 13
      Caption = 'Electronic Signature Code'
    end
    object txtESCode: TEdit
      Left = 0
      Top = 14
      Width = 137
      Height = 21
      PasswordChar = '*'
      TabOrder = 0
      OnChange = txtESCodeChange
    end
  end
  object pnlOrderAction: TPanel
    Left = 4
    Top = 232
    Width = 381
    Height = 45
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object grpRelease: TGroupBox
      Left = 32
      Top = 4
      Width = 241
      Height = 42
      TabOrder = 0
      Visible = False
      object radVerbal: TRadioButton
        Left = 8
        Top = 19
        Width = 53
        Height = 17
        Caption = 'Verbal'
        Enabled = False
        TabOrder = 0
      end
      object radPhone: TRadioButton
        Left = 80
        Top = 19
        Width = 77
        Height = 17
        Caption = 'Telephone'
        Enabled = False
        TabOrder = 1
      end
    end
    object radRelease: TRadioButton
      Left = 48
      Top = 4
      Width = 113
      Height = 17
      Caption = 'Release to Service'
      Checked = True
      TabOrder = 1
      TabStop = True
      Visible = False
      OnClick = radReleaseClick
    end
  end
  object cmdOK: TButton
    Left = 394
    Top = 246
    Width = 72
    Height = 26
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = cmdOKClick
  end
  object cmdCancel: TButton
    Left = 490
    Top = 245
    Width = 72
    Height = 27
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = cmdCancelClick
  end
  object lstReview: TCheckListBox
    Left = 12
    Top = 36
    Width = 570
    Height = 182
    OnClickCheck = lstReviewClickCheck
    Anchors = [akLeft, akRight, akBottom]
    ItemHeight = 15
    ParentShowHint = False
    ShowHint = True
    Style = lbOwnerDrawVariable
    TabOrder = 1
    OnDrawItem = lstReviewDrawItem
    OnMeasureItem = lstReviewMeasureItem
    OnMouseMove = lstReviewMouseMove
  end
end
