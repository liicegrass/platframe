inherited FrmCustomDBBandedTable: TFrmCustomDBBandedTable
  Caption = 'FrmCustomDBBandedTable'
  ClientHeight = 448
  ClientWidth = 824
  ExplicitWidth = 840
  ExplicitHeight = 486
  PixelsPerInch = 96
  TextHeight = 12
  object pnlClient: TPanel
    Left = 0
    Top = 69
    Width = 824
    Height = 379
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object grdData: TcxGrid
      Left = 0
      Top = 0
      Width = 824
      Height = 379
      Align = alClient
      TabOrder = 0
      object grdbndtblvwData: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dsData
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnFiltering = False
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnSorting = False
        OptionsCustomize.BandMoving = False
        OptionsData.Deleting = False
        OptionsData.Inserting = False
        OptionsView.DataRowHeight = 24
        OptionsView.GroupByBox = False
        OptionsView.HeaderHeight = 24
        OptionsView.Indicator = True
        OptionsView.BandHeaderHeight = 24
        Bands = <
          item
          end>
      end
      object grdlvlData: TcxGridLevel
        GridView = grdbndtblvwData
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 28
    Width = 824
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.LargeImages = DmImage.imgLarge
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 176
    Top = 128
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      28
      0)
    object BarTool: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = #24037#20855#26639
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 813
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
  end
  object cdsData: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 128
  end
  object dsData: TDataSource
    AutoEdit = False
    DataSet = cdsData
    Left = 360
    Top = 128
  end
end
