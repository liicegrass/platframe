inherited FrmWorkerInfoEdit: TFrmWorkerInfoEdit
  Caption = #29992#25143#20449#24687#32534#36753
  ClientHeight = 330
  ClientWidth = 437
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 443
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited bvl1: TBevel
    Top = 279
    Width = 437
    ExplicitTop = 316
    ExplicitWidth = 437
  end
  inherited pnlClient: TPanel
    Width = 437
    Height = 279
    ExplicitWidth = 437
    ExplicitHeight = 316
    object lbl1: TLabel
      Left = 60
      Top = 34
      Width = 60
      Height = 13
      Caption = #29992#25143#32534#30721#65306
    end
    object lbl2: TLabel
      Left = 60
      Top = 73
      Width = 60
      Height = 13
      Caption = #29992#25143#21517#31216#65306
    end
    object lbl4: TLabel
      Left = 60
      Top = 112
      Width = 60
      Height = 13
      Caption = #25152#23646#35282#33394#65306
    end
    object lbl6: TLabel
      Left = 60
      Top = 151
      Width = 60
      Height = 13
      Caption = #36215#22987#26102#38388#65306
    end
    object lbl7: TLabel
      Left = 60
      Top = 190
      Width = 60
      Height = 13
      Caption = #32467#26463#26102#38388#65306
    end
    object Label1: TLabel
      Left = 60
      Top = 229
      Width = 60
      Height = 13
      Caption = #29992#25143#29366#24577#65306
    end
    object edtWorkerID: TcxTextEdit
      Left = 134
      Top = 27
      AutoSize = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 0
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object edtWorkerName: TcxTextEdit
      Left = 134
      Top = 66
      AutoSize = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 1
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object edtBeginTime: TcxDateEdit
      Left = 134
      Top = 144
      AutoSize = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 3
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object edtEndTime: TcxDateEdit
      Left = 134
      Top = 183
      AutoSize = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 4
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object edtWorkerGuid: TcxTextEdit
      Left = 210
      Top = 2
      AutoSize = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 5
      Visible = False
      Height = 26
      Width = 217
    end
    object cbbWorkerClass: TcxComboBox
      Left = 134
      Top = 105
      AutoSize = False
      Properties.DropDownListStyle = lsFixedList
      Properties.ItemHeight = 20
      StyleFocused.Color = clInfoBk
      TabOrder = 2
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object cbbIsStop: TcxComboBox
      Left = 134
      Top = 222
      AutoSize = False
      Properties.DropDownListStyle = lsFixedList
      Properties.ItemHeight = 20
      Properties.Items.Strings = (
        #27491#24120
        #20572#29992)
      StyleFocused.Color = clInfoBk
      TabOrder = 6
      Text = #27491#24120
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
  end
  inherited pnlBottom: TPanel
    Top = 281
    Width = 437
    ExplicitTop = 318
    ExplicitWidth = 437
    inherited btnOk: TcxButton
      Left = 257
      OnClick = btnOkClick
      ExplicitLeft = 257
    end
    inherited btnCancel: TcxButton
      Left = 346
      ExplicitLeft = 346
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
  inherited actlst1: TActionList
    Left = 192
    Top = 136
  end
end
