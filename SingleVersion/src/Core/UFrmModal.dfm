inherited FrmModal: TFrmModal
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #24377#31383#22522#31867#31383#20307
  ClientHeight = 378
  ClientWidth = 511
  Position = poScreenCenter
  ExplicitWidth = 517
  ExplicitHeight = 406
  PixelsPerInch = 96
  TextHeight = 12
  object bvl1: TBevel
    Left = 0
    Top = 331
    Width = 511
    Height = 2
    Align = alBottom
    Shape = bsTopLine
    ExplicitTop = 332
  end
  object pnlClient: TPanel
    Left = 0
    Top = 0
    Width = 511
    Height = 331
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 333
    Width = 511
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      511
      45)
    object btnOk: TcxButton
      Left = 345
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #30830#23450
      TabOrder = 0
    end
    object btnCancel: TcxButton
      Left = 427
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 1
    end
  end
  object actlst1: TActionList
    Left = 176
    Top = 112
    object actExit: TAction
      Caption = 'actExit'
      ShortCut = 27
      OnExecute = actExitExecute
    end
  end
end
