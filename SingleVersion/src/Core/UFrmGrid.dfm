inherited FrmGrid: TFrmGrid
  Caption = 'FrmGrid'
  ClientHeight = 482
  ClientWidth = 695
  ExplicitWidth = 711
  ExplicitHeight = 520
  PixelsPerInch = 96
  TextHeight = 12
  object pnlClient: TPanel [0]
    Left = 0
    Top = 60
    Width = 695
    Height = 422
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 695
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
    end
    object grdData: TcxGrid
      Left = 0
      Top = 24
      Width = 695
      Height = 398
      Align = alClient
      TabOrder = 1
      LookAndFeel.SkinName = 'UserSkin'
      object grdbtblvwData: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsData
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnFiltering = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.DataRowHeight = 24
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 24
        OptionsView.Indicator = True
      end
      object grdlvlData: TcxGridLevel
        GridView = grdbtblvwData
      end
    end
  end
  inherited dxbrmngr1: TdxBarManager
    Left = 120
    Top = 176
    PixelsPerInch = 96
  end
  inherited actlst1: TActionList
    Left = 192
    Top = 176
    inherited actExport: TAction
      OnExecute = actExportExecute
    end
  end
  object dsData: TDataSource
    AutoEdit = False
    DataSet = cdsData
    Left = 344
    Top = 192
  end
  object cdsData: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 288
    Top = 192
  end
end
