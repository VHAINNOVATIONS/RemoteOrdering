object frmMultipleOrderedDrugs: TfrmMultipleOrderedDrugs
  Left = 437
  Top = 377
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 10
  Caption = 'Multiple Drugs for Selected Order'
  ClientHeight = 159
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 443
    Height = 16
    Align = alTop
    Caption = 'Please Select One Ordered Drug!'
    Color = clBtnFace
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    ExplicitWidth = 193
  end
  object pnlButton: TPanel
    Left = 0
    Top = 124
    Width = 443
    Height = 35
    Align = alBottom
    Anchors = [akRight]
    BevelOuter = bvNone
    TabOrder = 0
    object btnOk: TButton
      Left = 280
      Top = 5
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 368
      Top = 5
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object lbxSelectList: TListBox
    Left = 0
    Top = 16
    Width = 443
    Height = 108
    Hint = 'Select One Ordered Drug'
    HelpContext = 155
    Align = alClient
    ItemHeight = 15
    Items.Strings = (
      '012345678901234567890123456789012345678901234567890123456789')
    ParentShowHint = False
    ShowHint = True
    Sorted = True
    TabOrder = 1
  end
end
