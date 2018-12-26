inherited FrmVehicle: TFrmVehicle
  Caption = #21496#26426#21450#36710#36742#20449#24687
  ClientHeight = 307
  ClientWidth = 376
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 382
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited bvl1: TBevel
    Top = 256
    Width = 376
    ExplicitTop = 256
    ExplicitWidth = 376
  end
  inherited pnlClient: TPanel
    Width = 376
    Height = 256
    ExplicitWidth = 376
    ExplicitHeight = 256
    object Label1: TLabel
      Left = 41
      Top = 137
      Width = 60
      Height = 13
      Caption = #36710#36742#31867#22411#65306
    end
    object Label2: TLabel
      Left = 41
      Top = 27
      Width = 60
      Height = 13
      Caption = #21496#26426#22995#21517#65306
    end
    object Label3: TLabel
      Left = 41
      Top = 64
      Width = 54
      Height = 13
      Caption = #36710' '#29260' '#21495#65306
    end
    object Label4: TLabel
      Left = 41
      Top = 100
      Width = 60
      Height = 13
      Caption = #32852#31995#25163#26426#65306
    end
    object Label5: TLabel
      Left = 41
      Top = 172
      Width = 60
      Height = 13
      Caption = #20351#29992#29366#24577#65306
    end
    object Label6: TLabel
      Left = 41
      Top = 209
      Width = 60
      Height = 13
      Caption = #22791#27880#20449#24687#65306
    end
    object edtDriverName: TcxTextEdit
      Left = 116
      Top = 21
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
    object edtCarNo: TcxTextEdit
      Left = 116
      Top = 57
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
    object edtPhone: TcxTextEdit
      Left = 116
      Top = 93
      AutoSize = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 2
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object cbbIsStop: TcxComboBox
      Left = 116
      Top = 166
      AutoSize = False
      Properties.DropDownListStyle = lsFixedList
      Properties.ItemHeight = 20
      Properties.Items.Strings = (
        #27491#24120
        #20572#29992)
      StyleFocused.Color = clInfoBk
      TabOrder = 4
      Text = #27491#24120
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object edtRemark: TcxTextEdit
      Left = 116
      Top = 203
      AutoSize = False
      Style.LookAndFeel.SkinName = 'UserSkin'
      StyleDisabled.LookAndFeel.SkinName = 'UserSkin'
      StyleFocused.Color = clInfoBk
      StyleFocused.LookAndFeel.SkinName = 'UserSkin'
      StyleHot.LookAndFeel.SkinName = 'UserSkin'
      TabOrder = 5
      OnKeyPress = DoKeyPress
      Height = 26
      Width = 217
    end
    object edtCarKind: TcxTextEdit
      Left = 116
      Top = 130
      AutoSize = False
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
  end
  inherited pnlBottom: TPanel
    Top = 258
    Width = 376
    ExplicitTop = 258
    ExplicitWidth = 376
    inherited btnOk: TcxButton
      Left = 196
      OnClick = btnOkClick
      ExplicitLeft = 196
    end
    inherited btnCancel: TcxButton
      Left = 285
      ExplicitLeft = 285
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
    Left = 168
    Top = 48
  end
end
