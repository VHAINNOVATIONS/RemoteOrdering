inherited frmReview: TfrmReview
  Left = 141
  Top = 70
  BorderIcons = [biMaximize]
  Caption = 'Review / Sign Changes'
  ClientHeight = 651
  ClientWidth = 846
  Constraints.MinHeight = 554
  Constraints.MinWidth = 855
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHelp = nil
  OnKeyUp = FormKeyUp
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  ExplicitWidth = 862
  ExplicitHeight = 689
  PixelsPerInch = 96
  TextHeight = 16
  object laDiagnosis: TLabel [0]
    Left = 315
    Top = 166
    Width = 61
    Height = 16
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Diagnosis'
    Visible = False
  end
  object pnlCombined: TORAutoPanel [1]
    Left = 0
    Top = 183
    Width = 846
    Height = 309
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object pnlReview: TPanel
      Left = 0
      Top = 0
      Width = 846
      Height = 157
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object lstReview: TCaptionCheckListBox
        Left = 0
        Top = 28
        Width = 846
        Height = 129
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = lstReviewClickCheck
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnDrawItem = lstReviewDrawItem
        OnKeyUp = lstReviewKeyUp
        OnMeasureItem = lstReviewMeasureItem
        OnMouseMove = lstReviewMouseMove
        Caption = 'Signature will be Applied to Checked Items'
      end
      object lblSig: TStaticText
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 838
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'All Orders Except Controlled Substance EPCS Orders'
        TabOrder = 2
        TabStop = True
      end
    end
    object pnlCSReview: TPanel
      Left = 0
      Top = 157
      Width = 846
      Height = 152
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object lblCSReview: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 4
        Width = 838
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alTop
        Caption = 'Controlled Substance EPCS Orders'
        ExplicitWidth = 211
      end
      object lstCSReview: TCaptionCheckListBox
        Left = 0
        Top = 24
        Width = 846
        Height = 128
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        OnClickCheck = lstReviewClickCheck
        DoubleBuffered = True
        ParentDoubleBuffered = False
        ParentShowHint = False
        ShowHint = True
        Style = lbOwnerDrawVariable
        TabOrder = 0
        OnDrawItem = lstReviewDrawItem
        OnKeyUp = lstReviewKeyUp
        OnMeasureItem = lstReviewMeasureItem
        OnMouseMove = lstReviewMouseMove
        Caption = ''
      end
      object lblSmartCardNeeded: TStaticText
        AlignWithMargins = True
        Left = 233
        Top = 4
        Width = 154
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'SMART card required'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        Transparent = False
      end
    end
  end
  object pnlBottom: TPanel [2]
    Left = 0
    Top = 542
    Width = 846
    Height = 109
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      846
      109)
    object pnlSignature: TPanel
      Left = 10
      Top = 50
      Width = 187
      Height = 53
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object lblESCode: TLabel
        Left = 0
        Top = 0
        Width = 155
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'Electronic Signature Code'
      end
      object txtESCode: TCaptionEdit
        Left = 0
        Top = 17
        Width = 169
        Height = 24
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        PasswordChar = '*'
        TabOrder = 0
        OnChange = txtESCodeChange
        Caption = 'Electronic Signature Code'
      end
    end
    object pnlOrderAction: TPanel
      Left = 186
      Top = 26
      Width = 459
      Height = 80
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akBottom]
      BevelOuter = bvNone
      TabOrder = 1
      Visible = False
      object Label1: TStaticText
        Left = 0
        Top = 0
        Width = 140
        Height = 20
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'For orders, select from:'
        TabOrder = 4
      end
      object radSignChart: TRadioButton
        Left = 0
        Top = 20
        Width = 124
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Signed on Chart'
        TabOrder = 0
        OnClick = radReleaseClick
      end
      object radHoldSign: TRadioButton
        Left = 0
        Top = 44
        Width = 124
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Hold until Signed'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnClick = radReleaseClick
      end
      object grpRelease: TGroupBox
        Left = 148
        Top = 20
        Width = 296
        Height = 51
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        TabOrder = 3
        Visible = False
        object radVerbal: TRadioButton
          Left = 10
          Top = 23
          Width = 65
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Verbal'
          Enabled = False
          TabOrder = 0
        end
        object radPhone: TRadioButton
          Left = 98
          Top = 23
          Width = 95
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Telephone'
          Enabled = False
          TabOrder = 1
        end
        object radPolicy: TRadioButton
          Left = 207
          Top = 23
          Width = 60
          Height = 21
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = '&Policy'
          Enabled = False
          TabOrder = 2
        end
      end
      object radRelease: TRadioButton
        Left = 158
        Top = 20
        Width = 139
        Height = 21
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = '&Release to Service'
        TabOrder = 2
        Visible = False
        OnClick = radReleaseClick
      end
    end
    object cmdOK: TButton
      Left = 647
      Top = 68
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 2
      OnClick = cmdOKClick
    end
    object cmdCancel: TButton
      Left = 743
      Top = 68
      Width = 89
      Height = 26
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = cmdCancelClick
    end
    object lblHoldSign: TStaticText
      Left = 220
      Top = 2
      Width = 366
      Height = 20
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      Caption = 'These orders can only be signed by the prescribing provider.'
      TabOrder = 4
      Visible = False
    end
  end
  object pnlDEAText: TPanel [3]
    Left = 0
    Top = 492
    Width = 846
    Height = 50
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object lblDEAText: TStaticText
      Left = 0
      Top = 0
      Width = 846
      Height = 50
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Align = alClient
      Anchors = [akLeft, akTop, akRight]
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
  object pnlTop: TPanel [4]
    Left = 0
    Top = 0
    Width = 846
    Height = 183
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      846
      183)
    inline fraCoPay: TfraCoPayDesc
      Left = 201
      Top = -1
      Width = 645
      Height = 187
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Visible = False
      ExplicitLeft = 201
      ExplicitTop = -1
      ExplicitWidth = 645
      ExplicitHeight = 187
      inherited pnlRight: TPanel
        Left = 318
        Width = 327
        Height = 187
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        AutoSize = True
        ExplicitLeft = 318
        ExplicitWidth = 327
        ExplicitHeight = 187
        inherited Spacer2: TLabel
          Top = 20
          Width = 327
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          ExplicitTop = 20
          ExplicitWidth = 327
        end
        inherited lblCaption: TStaticText
          Width = 327
          Height = 20
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Caption = 'Patient Orders Related To:'
          ExplicitWidth = 327
          ExplicitHeight = 20
        end
        inherited ScrollBox1: TScrollBox
          Top = 23
          Width = 327
          Height = 164
          VertScrollBar.Position = 9
          ExplicitTop = 23
          ExplicitWidth = 327
          ExplicitHeight = 164
          inherited pnlMain: TPanel
            Top = -9
            Width = 306
            Height = 201
            Margins.Left = 4
            Margins.Top = 4
            Margins.Right = 4
            Margins.Bottom = 4
            ExplicitTop = -9
            ExplicitWidth = 306
            ExplicitHeight = 201
            inherited spacer1: TLabel
              Top = 25
              Width = 306
              Height = 4
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 25
              ExplicitWidth = 282
              ExplicitHeight = 4
            end
            inherited pnlHNC: TPanel
              Top = 179
              Width = 306
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 179
              ExplicitWidth = 306
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
              Width = 306
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 139
              ExplicitWidth = 306
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
              Width = 306
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 95
              ExplicitWidth = 306
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
              Width = 306
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 73
              ExplicitWidth = 306
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
                Width = 23
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 26
                ExplicitWidth = 23
                ExplicitHeight = 22
              end
            end
            inherited pnlAO: TPanel
              Top = 51
              Width = 306
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 51
              ExplicitWidth = 306
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
              Width = 306
              Height = 25
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 0
              ExplicitWidth = 306
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
              Width = 306
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitLeft = 0
              ExplicitTop = 29
              ExplicitWidth = 306
              ExplicitHeight = 22
              inherited lblCV2: TVA508StaticText
                Left = 62
                Width = 174
                Height = 22
                Margins.Left = 4
                Margins.Top = 4
                Margins.Right = 4
                Margins.Bottom = 4
                ExplicitLeft = 62
                ExplicitWidth = 174
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
              Width = 306
              Height = 22
              Margins.Left = 4
              Margins.Top = 4
              Margins.Right = 4
              Margins.Bottom = 4
              ExplicitTop = 117
              ExplicitWidth = 306
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
              Width = 306
              Height = 18
              ExplicitLeft = 0
              ExplicitTop = 161
              ExplicitWidth = 306
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
        Left = -1
        Width = 347
        Height = 187
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Align = alNone
        Anchors = [akLeft, akTop, akRight]
        ExplicitLeft = -1
        ExplicitWidth = 347
        ExplicitHeight = 187
        inherited lblSCDisplay: TLabel
          Left = 59
          Top = -2
          Width = 295
          Height = 19
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 59
          ExplicitTop = -2
          ExplicitWidth = 295
          ExplicitHeight = 19
        end
        inherited memSCDisplay: TCaptionMemo
          Left = 59
          Top = 14
          Width = 288
          Height = 161
          Margins.Left = 4
          Margins.Top = 4
          Margins.Right = 4
          Margins.Bottom = 4
          Align = alNone
          Anchors = [akTop, akRight]
          ExplicitLeft = 59
          ExplicitTop = 14
          ExplicitWidth = 288
          ExplicitHeight = 161
        end
      end
    end
    object pnlProvInfo: TPanel
      Left = 0
      Top = -1
      Width = 252
      Height = 187
      Margins.Left = 4
      Margins.Top = 4
      Margins.Right = 4
      Margins.Bottom = 4
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      TabOrder = 1
      object lblProvInfo: TLabel
        Left = 10
        Top = 4
        Width = 63
        Height = 16
        Margins.Left = 4
        Margins.Top = 4
        Margins.Right = 4
        Margins.Bottom = 4
        Caption = 'lblProvInfo'
      end
    end
  end
  inherited amgrMain: TVA508AccessibilityManager
    Left = 648
    Top = 80
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
        'Component = frmReview'
        'Status = stsDefault')
      (
        'Component = pnlProvInfo'
        'Status = stsDefault')
      (
        'Component = pnlDEAText'
        'Status = stsDefault')
      (
        'Component = lblDEAText'
        'Status = stsDefault')
      (
        'Component = pnlBottom'
        'Status = stsDefault')
      (
        'Component = pnlSignature'
        'Status = stsDefault')
      (
        'Component = txtESCode'
        'Status = stsDefault')
      (
        'Component = pnlOrderAction'
        'Status = stsDefault')
      (
        'Component = Label1'
        'Status = stsDefault')
      (
        'Component = radSignChart'
        'Status = stsDefault')
      (
        'Component = radHoldSign'
        'Status = stsDefault')
      (
        'Component = grpRelease'
        'Status = stsDefault')
      (
        'Component = radVerbal'
        'Status = stsDefault')
      (
        'Component = radPhone'
        'Status = stsDefault')
      (
        'Component = radPolicy'
        'Status = stsDefault')
      (
        'Component = radRelease'
        'Status = stsDefault')
      (
        'Component = cmdOK'
        'Status = stsDefault')
      (
        'Component = cmdCancel'
        'Status = stsDefault')
      (
        'Component = lblHoldSign'
        'Status = stsDefault')
      (
        'Component = pnlCombined'
        'Status = stsDefault')
      (
        'Component = pnlReview'
        'Status = stsDefault')
      (
        'Component = lstReview'
        'Status = stsDefault')
      (
        'Component = lblSig'
        'Status = stsDefault')
      (
        'Component = pnlCSReview'
        'Status = stsDefault')
      (
        'Component = lstCSReview'
        'Status = stsDefault')
      (
        'Component = lblSmartCardNeeded'
        'Status = stsDefault')
      (
        'Component = pnlTop'
        'Status = stsDefault'))
  end
end
