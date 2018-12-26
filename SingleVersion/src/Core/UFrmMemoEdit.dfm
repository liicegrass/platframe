inherited FrmMemoEdit: TFrmMemoEdit
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = #22791#27880#32534#36753#31383#20307
  ClientHeight = 414
  ClientWidth = 564
  ExplicitWidth = 580
  ExplicitHeight = 452
  PixelsPerInch = 96
  TextHeight = 12
  inherited bvl1: TBevel
    Top = 367
    Width = 564
  end
  inherited pnlClient: TPanel
    Width = 564
    Height = 367
    object cxmMemo: TcxMemo
      Left = 0
      Top = 0
      Align = alClient
      Properties.ScrollBars = ssVertical
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 494
      ExplicitHeight = 305
      Height = 367
      Width = 564
    end
  end
  inherited pnlBottom: TPanel
    Top = 369
    Width = 564
    inherited btnOk: TcxButton
      Left = 398
      OnClick = btnOkClick
    end
    inherited btnCancel: TcxButton
      Left = 480
    end
  end
end
