object frmNotificationProcessor: TfrmNotificationProcessor
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CPRS Notification Processor'
  ClientHeight = 372
  ClientWidth = 598
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    598
    372)
  PixelsPerInch = 96
  TextHeight = 13
  object bvlBottom: TBevel
    Left = 0
    Top = 332
    Width = 598
    Height = 40
    Align = alBottom
    Shape = bsSpacer
    ExplicitTop = 312
    ExplicitWidth = 484
  end
  object memNotificationSpecifications: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 26
    Width = 592
    Height = 103
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'memNotificationSpecifications'
      
        '1234567890123456789012345678901234567890123456789012345678901234' +
        '5678901234567890')
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object stxtNotificationName: TStaticText
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 592
    Height = 17
    Align = alTop
    Caption = 'stxtNotificationName'
    TabOrder = 0
  end
  object rbtnNewNote: TRadioButton
    AlignWithMargins = True
    Left = 3
    Top = 135
    Width = 592
    Height = 17
    Align = alTop
    Caption = 'Create New Note'
    TabOrder = 2
    OnClick = NewOrAddendClick
  end
  object rbtnAddendOneOfTheFollowing: TRadioButton
    AlignWithMargins = True
    Left = 3
    Top = 158
    Width = 592
    Height = 17
    Align = alTop
    Caption = 'Addend one of the following notes'
    TabOrder = 3
    OnClick = NewOrAddendClick
  end
  object lbxCurrentNotesAvailable: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 181
    Width = 592
    Height = 148
    Align = alClient
    ItemHeight = 13
    TabOrder = 4
    OnClick = NewOrAddendClick
  end
  object btnCancel: TButton
    Left = 515
    Top = 339
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 434
    Top = 339
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&OK'
    ModalResult = 1
    TabOrder = 6
    OnClick = btnOKClick
  end
end
