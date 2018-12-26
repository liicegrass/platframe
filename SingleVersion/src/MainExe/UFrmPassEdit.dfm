inherited FrmPassEdit: TFrmPassEdit
  Caption = #20462#25913#23494#30721
  ClientHeight = 201
  ClientWidth = 343
  ExplicitWidth = 349
  ExplicitHeight = 229
  PixelsPerInch = 96
  TextHeight = 12
  inherited bvl1: TBevel
    Top = 154
    Width = 343
    ExplicitTop = 154
    ExplicitWidth = 343
  end
  inherited pnlClient: TPanel
    Width = 343
    Height = 154
    ExplicitWidth = 343
    ExplicitHeight = 154
    object lbl1: TLabel
      Left = 55
      Top = 39
      Width = 48
      Height = 12
      Caption = #21407#23494#30721#65306
    end
    object lbl2: TLabel
      Left = 55
      Top = 71
      Width = 48
      Height = 12
      Caption = #26032#23494#30721#65306
    end
    object lbl3: TLabel
      Left = 31
      Top = 103
      Width = 72
      Height = 12
      Caption = #30830#35748#26032#23494#30721#65306
    end
    object edtPass: TcxTextEdit
      Left = 106
      Top = 33
      AutoSize = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      StyleFocused.Color = clInfoBk
      TabOrder = 0
      OnKeyPress = DoKeyPress
      Height = 24
      Width = 200
    end
    object edtNewPass: TcxTextEdit
      Left = 106
      Top = 65
      AutoSize = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      StyleFocused.Color = clInfoBk
      TabOrder = 1
      OnKeyPress = DoKeyPress
      Height = 24
      Width = 200
    end
    object edtNewPass2: TcxTextEdit
      Left = 106
      Top = 97
      AutoSize = False
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      StyleFocused.Color = clInfoBk
      TabOrder = 2
      OnKeyPress = DoKeyPress
      Height = 24
      Width = 200
    end
  end
  inherited pnlBottom: TPanel
    Top = 156
    Width = 343
    ExplicitTop = 156
    ExplicitWidth = 343
    inherited btnOk: TcxButton
      Left = 177
      OnClick = btnOkClick
      ExplicitLeft = 177
    end
    inherited btnCancel: TcxButton
      Left = 259
      ExplicitLeft = 259
    end
  end
  inherited actlst1: TActionList
    Left = 80
    Top = 152
  end
end
