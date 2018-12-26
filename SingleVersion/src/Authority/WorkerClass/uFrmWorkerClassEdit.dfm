inherited FrmWorkerClassEdit: TFrmWorkerClassEdit
  Caption = #35282#33394#20449#24687#32534#36753
  ClientHeight = 245
  ClientWidth = 446
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 452
  ExplicitHeight = 273
  PixelsPerInch = 96
  TextHeight = 13
  inherited bvl1: TBevel
    Top = 194
    Width = 446
    ExplicitTop = 194
    ExplicitWidth = 446
  end
  inherited pnlClient: TPanel
    Width = 446
    Height = 194
    ExplicitWidth = 446
    ExplicitHeight = 194
    object lbl1: TLabel
      Left = 69
      Top = 43
      Width = 60
      Height = 13
      Caption = #35282#33394#32534#30721#65306
    end
    object lbl2: TLabel
      Left = 69
      Top = 81
      Width = 60
      Height = 13
      Caption = #35282#33394#21517#31216#65306
    end
    object lbl3: TLabel
      Left = 69
      Top = 118
      Width = 48
      Height = 13
      Caption = #22791'    '#27880#65306
    end
    object edtClassID: TcxTextEdit
      Left = 139
      Top = 37
      AutoSize = False
      Properties.Alignment.Vert = taVCenter
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 0
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 216
    end
    object edtClassName: TcxTextEdit
      Left = 139
      Top = 75
      AutoSize = False
      Properties.Alignment.Vert = taVCenter
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 1
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 216
    end
    object edtRemark: TcxTextEdit
      Left = 139
      Top = 112
      AutoSize = False
      Properties.Alignment.Vert = taVCenter
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 2
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 216
    end
    object edtClassGuid: TcxTextEdit
      Left = 156
      Top = 4
      AutoSize = False
      Properties.Alignment.Vert = taVCenter
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 3
      Visible = False
      Height = 26
      Width = 217
    end
  end
  inherited pnlBottom: TPanel
    Top = 196
    Width = 446
    ExplicitTop = 196
    ExplicitWidth = 446
    inherited btnOk: TcxButton
      Left = 267
      OnClick = btnOkClick
      ExplicitLeft = 267
    end
    inherited btnCancel: TcxButton
      Left = 355
      ExplicitLeft = 355
    end
    object chkAlwaysNew: TcxCheckBox
      Left = 36
      Top = 12
      AutoSize = False
      Caption = #36830#32493#22686#21152
      Properties.NullStyle = nssUnchecked
      State = cbsChecked
      StyleFocused.Color = clInfoBk
      TabOrder = 2
      Transparent = True
      Visible = False
      OnClick = chkAlwaysNewClick
      Height = 26
      Width = 79
    end
  end
end
