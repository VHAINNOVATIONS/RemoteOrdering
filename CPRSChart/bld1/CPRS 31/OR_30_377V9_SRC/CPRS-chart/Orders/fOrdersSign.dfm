inherited frmSignOrders: TfrmSignOrders
  Left = 337
  Top = 142
  Caption = 'Sign Orders'
  ClientHeight = 643
  ClientWidth = 852
  Constraints.MinHeight = 554
  Constraints.MinWidth = 862
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = nil
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 868
  ExplicitHeight = 681
  PixelsPerInch = 96
  TextHeight = 16
  object laDiagnosis: TLabel [0]
    Left = 226
    Top = 228
    Width = 61
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Diagnosis'
    Visible = False
  end
  object pnlDEAText: TPanel [1]
    AlignWithMargins = True
    Left = 4
    Top = 527
    Width = 844
    Height = 53
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 844
      Height = 53
      Margins.Left = 7
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Caption = 
        'By completing the two-factor authentication protocol at this tim' +
        'e, you are legally signing the prescription(s) and authorizing t' +
        'he transmission of the above informationto the pharmacy for disp' +
        'ensing.  The two-factor authentication protocol may only be comp' +
        'leted by the practitioner whose name and DEA registration number' +
        ' appear above. '
      TabOrder = 0
    end
  end
  object pnlEsig: TPanel [2]
    Left = 0
    Top = 584
    Width = 852
    Height = 59
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    DesignSize = (
      852
      59)
    object lblESCode: TLabel
      Left = 9
      Top = -1
      Width = 155
      Height = 16
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft]
      Caption = 'Electronic Signature Code'
    end
    object txtESCode: TCaptionEdit
      Left = 7
      Top = 22
      Width = 169
      Height = 24
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft]
      PasswordChar = '*'
      TabOrder = 0
      Caption = 'Electronic Signature Code'
    end
    object cmdOK: TButton
      Left = 650
      Top = 23
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight]
      Caption = 'Sign'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 751
      Top = 23
      Width = 88
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
  end
  object pnlCombined: TORAutoPanel [3]
    Left = 0
    Top = 209
    Width = 852
    Height = 314
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    object pnlCSOrderList: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 157
      Width = 844
      Height = 153
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object lblCSOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 844
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object lblSmartCardNeeded: TStaticText
        Left = 226
        Top = -1
        Width = 164
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'SMART card required'
        Color = clBtnFace
        DoubleBuffered = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentDoubleBuffered = False
        ParentFont = False
        TabOrder = 1
        Transparent = False
      end
      object clstCSOrders: TCaptionCheckListBox
        Left = 0
        Top = 20
        Width = 844
        Height = 133
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = clstOrdersClickCheck
        DoubleBuffered = True
        ParentDoubleBuffered = False
        Style = lbOwnerDrawVariable
        TabOrder = 2
        OnDrawItem = clstOrdersDrawItem
        OnKeyUp = clstOrdersKeyUp
        OnMeasureItem = clstOrdersMeasureItem
        OnMouseMove = clstOrdersMouseMove
        Caption = 'The following orders will be signed -'
      end
    end
    object pnlOrderList: TPanel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 844
      Height = 145
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lblOrderList: TStaticText
        Left = 0
        Top = 0
        Width = 844
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        DoubleBuffered = True
        ParentDoubleBuffered = False
        TabOrder = 0
      end
      object clstOrders: TCaptionCheckListBox
        Left = 0
        Top = 28
        Width = 844
        Height = 117
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = clstOrdersClickCheck
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 1
        OnDrawItem = clstOrdersDrawItem
        OnKeyUp = clstOrdersKeyUp
        OnMeasureItem = clstOrdersMeasureItem
        OnMouseMove = clstOrdersMouseMove
        Caption = 'The following orders will be signed -'
      end
    end
  end
  object pnlTop: TPanel [4]
    Left = 0
    Top = 0
    Width = 852
    Height = 209
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    DesignSize = (
      852
      209)
    inline fraCoPay: TfraCoPayDesc
      Left = 0
      Top = 0
      Width = 852
      Height = 193
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      AutoSize = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitWidth = 852
      ExplicitHeight = 193
      inherited pnlRight: TPanel
        Left = 516
        Width = 336
        Height = 193
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitLeft = 516
        ExplicitWidth = 336
        ExplicitHeight = 193
        inherited Spacer2: TLabel
          Top = 0
          Width = 336
          Height = 4
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitTop = 0
          ExplicitWidth = 336
          ExplicitHeight = 4
        end
        inherited lblCaption: TStaticText
          Left = 20
          Width = 296
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          ExplicitLeft = 20
          ExplicitWidth = 296
          ExplicitHeight = 20
        end
        inherited ScrollBox1: TScrollBox
          Top = 4
          Width = 336
          Height = 189
          ExplicitTop = 4
          ExplicitWidth = 336
          ExplicitHeight = 189
          inherited pnlMain: TPanel
            Width = 315
            Height = 201
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitWidth = 315
            ExplicitHeight = 201
            inherited spacer1: TLabel
              Top = 25
              Width = 315
              Height = 4
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 21
              ExplicitWidth = 322
              ExplicitHeight = 4
            end
            inherited pnlHNC: TPanel
              Top = 179
              Width = 315
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 179
              ExplicitWidth = 315
              ExplicitHeight = 22
              inherited lblHNC2: TVA508StaticText
                Left = 62
                Width = 158
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 158
                ExplicitHeight = 22
              end
              inherited lblHNC: TVA508StaticText
                Left = 15
                Width = 38
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 15
                ExplicitWidth = 38
                ExplicitHeight = 22
              end
            end
            inherited pnlMST: TPanel
              Top = 139
              Width = 315
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 139
              ExplicitWidth = 315
              ExplicitHeight = 22
              inherited lblMST2: TVA508StaticText
                Left = 62
                Width = 30
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 30
                ExplicitHeight = 22
              end
              inherited lblMST: TVA508StaticText
                Left = 16
                Width = 38
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 16
                ExplicitWidth = 38
                ExplicitHeight = 22
              end
            end
            inherited pnlSWAC: TPanel
              Top = 95
              Width = 315
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 95
              ExplicitWidth = 315
              ExplicitHeight = 22
              inherited lblSWAC2: TVA508StaticText
                Left = 62
                Width = 156
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 156
                ExplicitHeight = 22
              end
              inherited lblSWAC: TVA508StaticText
                Left = 4
                Width = 49
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 4
                ExplicitWidth = 49
                ExplicitHeight = 22
              end
            end
            inherited pnlIR: TPanel
              Top = 73
              Width = 315
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 73
              ExplicitWidth = 315
              ExplicitHeight = 22
              inherited lblIR2: TVA508StaticText
                Left = 62
                Width = 163
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 163
                ExplicitHeight = 22
              end
              inherited lblIR: TVA508StaticText
                Left = 26
                Width = 22
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 26
                ExplicitWidth = 22
                ExplicitHeight = 22
              end
            end
            inherited pnlAO: TPanel
              Top = 51
              Width = 315
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 51
              ExplicitWidth = 315
              ExplicitHeight = 22
              inherited lblAO2: TVA508StaticText
                Left = 62
                Width = 141
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 141
                ExplicitHeight = 22
              end
              inherited lblAO: TVA508StaticText
                Left = 22
                Width = 28
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 22
                ExplicitWidth = 28
                ExplicitHeight = 22
              end
            end
            inherited pnlSC: TPanel
              Top = 0
              Width = 315
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 0
              ExplicitWidth = 315
              ExplicitHeight = 25
              inherited lblSC2: TVA508StaticText
                Left = 62
                Width = 215
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 215
                ExplicitHeight = 22
              end
              inherited lblSC: TVA508StaticText
                Left = 25
                Width = 33
                Height = 23
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 25
                ExplicitWidth = 33
                ExplicitHeight = 23
              end
            end
            inherited pnlCV: TPanel
              Top = 29
              Width = 315
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 29
              ExplicitWidth = 315
              ExplicitHeight = 22
              inherited lblCV2: TVA508StaticText
                Left = 62
                Width = 142
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 142
                ExplicitHeight = 22
              end
              inherited lblCV: TVA508StaticText
                Left = 25
                Width = 33
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 25
                ExplicitWidth = 33
                ExplicitHeight = 22
              end
            end
            inherited pnlSHD: TPanel
              Top = 117
              Width = 315
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 117
              ExplicitWidth = 315
              ExplicitHeight = 22
              inherited lblSHAD: TVA508StaticText
                Left = 16
                Width = 41
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 16
                ExplicitWidth = 41
                ExplicitHeight = 22
              end
              inherited lblSHAD2: TVA508StaticText
                Left = 63
                Width = 195
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 63
                ExplicitWidth = 195
                ExplicitHeight = 22
              end
            end
            inherited pnlCL: TPanel
              Top = 161
              Width = 315
              Height = 18
              ExplicitLeft = 0
              ExplicitTop = 161
              ExplicitWidth = 315
              ExplicitHeight = 18
              inherited lblCL: TVA508StaticText
                Width = 25
                Height = 18
                ExplicitWidth = 25
                ExplicitHeight = 18
              end
              inherited lblCL2: TVA508StaticText
                Width = 89
                Height = 18
                ExplicitWidth = 89
                ExplicitHeight = 18
              end
            end
          end
        end
      end
      inherited pnlSCandRD: TPanel
        Width = 516
        Height = 193
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        ExplicitWidth = 516
        ExplicitHeight = 193
        inherited lblSCDisplay: TLabel
          Left = 221
          Top = -3
          Width = 500
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 221
          ExplicitTop = -3
          ExplicitWidth = 500
          ExplicitHeight = 20
        end
        inherited memSCDisplay: TCaptionMemo
          Left = 226
          Top = 21
          Width = 288
          Height = 172
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 226
          ExplicitTop = 21
          ExplicitWidth = 288
          ExplicitHeight = 172
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = 0
      Width = 213
      Height = 186
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      BevelEdges = []
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        Left = 10
        Top = 4
        Width = 51
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'prov info'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 760
    Top = 88
    Data = (
      (
        'Component = fraCoPay'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlRight'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCaption'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlMain'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblHNC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblMST'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSWAC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblIR'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblAO'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSC'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlCV'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblCV'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSHD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.lblSHAD2'
        'Status = stsDefault')
      (
        'Component = fraCoPay.pnlSCandRD'
        'Status = stsDefault')
      (
        'Component = fraCoPay.memSCDisplay'
        'Status = stsDefault')
      (
        'Component = frmSignOrders'
        'Status = stsDefault')
      (
        'Component = pnlDEAText'
        'Status = stsDefault')
      (
        'Component = lblDEAText'
        'Status = stsDefault')
      (
        'Component = pnlProvInfo'
        'Status = stsDefault')
      (
        'Component = pnlOrderList'
        'Status = stsDefault')
      (
        'Component = lblOrderList'
        'Status = stsDefault')
      (
        'Component = clstOrders'
        'Status = stsDefault')
      (
        'Component = pnlCSOrderList'
        'Status = stsDefault')
      (
        'Component = lblCSOrderList'
        'Status = stsDefault')
      (
        'Component = lblSmartCardNeeded'
        'Status = stsDefault')
      (
        'Component = clstCSOrders'
        'Status = stsDefault')
      (
        'Component = pnlEsig'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = pnlCombined'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault'))
  end
end
