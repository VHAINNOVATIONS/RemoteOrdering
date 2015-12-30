object frmViewNotifications: TfrmViewNotifications
  Left = 0
  Top = 0
  Caption = 'Patient Notifications'
  ClientHeight = 408
  ClientWidth = 755
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnResize = FormResize
  DesignSize = (
    755
    408)
  PixelsPerInch = 96
  TextHeight = 13
  object clvNotifications: TCaptionListView
    Left = 8
    Top = 8
    Width = 739
    Height = 354
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Info'
      end
      item
        Caption = 'Location'
      end
      item
        Caption = 'Urgency'
      end
      item
        Caption = 'Alert Date/Time'
      end
      item
        Caption = 'Message'
      end
      item
        Caption = 'Forwarded By/When'
      end
      item
        Alignment = taCenter
        Caption = 'Mine'
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    AutoSize = False
    Caption = 'clvNotifications'
  end
  object btnDefer: TButton
    Left = 592
    Top = 375
    Width = 75
    Height = 25
    Action = acDefer
    Anchors = [akRight, akBottom]
    TabOrder = 1
  end
  object pnlNavigator: TPanel
    Left = 248
    Top = 370
    Width = 226
    Height = 30
    Anchors = [akLeft, akBottom]
    BevelOuter = bvNone
    Caption = 'pnlNavigator'
    ShowCaption = False
    TabOrder = 2
    object lblCurrentPage: TLabel
      AlignWithMargins = True
      Left = 57
      Top = 3
      Width = 112
      Height = 24
      Align = alClient
      Alignment = taCenter
      Caption = 'lblCurrentPage'
      Layout = tlCenter
      ExplicitWidth = 71
      ExplicitHeight = 13
    end
    object btnFirst: TButton
      Left = 0
      Top = 0
      Width = 27
      Height = 30
      Action = acFirst
      Align = alLeft
      TabOrder = 0
    end
    object btnPrevious: TButton
      Left = 27
      Top = 0
      Width = 27
      Height = 30
      Action = acPrev
      Align = alLeft
      TabOrder = 1
    end
    object btnNext: TButton
      Left = 172
      Top = 0
      Width = 27
      Height = 30
      Action = acNext
      Align = alRight
      TabOrder = 2
    end
    object btnLast: TButton
      Left = 199
      Top = 0
      Width = 27
      Height = 30
      Action = acLast
      Align = alRight
      TabOrder = 3
    end
  end
  object btnProcess: TButton
    Left = 511
    Top = 375
    Width = 75
    Height = 25
    Action = acProcess
    Anchors = [akRight, akBottom]
    TabOrder = 3
  end
  object btnClose: TButton
    Left = 672
    Top = 375
    Width = 75
    Height = 25
    Action = acClose
    Anchors = [akRight, akBottom]
    TabOrder = 4
  end
  object acList: TActionList
    OnUpdate = acListUpdate
    Left = 24
    Top = 48
    object acFirst: TAction
      Caption = '<<'
      OnExecute = acFirstExecute
    end
    object acPrev: TAction
      Caption = '<'
      OnExecute = acPrevExecute
    end
    object acNext: TAction
      Caption = '>'
      OnExecute = acNextExecute
    end
    object acLast: TAction
      Caption = '>>'
      OnExecute = acLastExecute
    end
    object acProcess: TAction
      Caption = '&Process'
      OnExecute = acProcessExecute
    end
    object acDefer: TAction
      Caption = '&Defer'
      OnExecute = acDeferExecute
    end
    object acClose: TAction
      Caption = '&Close'
      OnExecute = acCloseExecute
    end
    object acClearList: TAction
      Caption = 'acClearList'
      OnExecute = acClearListExecute
    end
  end
end
