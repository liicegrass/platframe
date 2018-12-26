inherited FrmCustomDBTreeList: TFrmCustomDBTreeList
  Caption = 'FrmCustomDBTreeList'
  ClientHeight = 507
  ClientWidth = 756
  ExplicitWidth = 772
  ExplicitHeight = 545
  PixelsPerInch = 96
  TextHeight = 12
  object pnlClient: TPanel
    Left = 0
    Top = 28
    Width = 756
    Height = 479
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitLeft = 96
    ExplicitTop = 104
    ExplicitWidth = 185
    ExplicitHeight = 41
    object tvData: TcxDBTreeList
      Left = 0
      Top = 0
      Width = 756
      Height = 479
      Align = alClient
      Bands = <>
      DataController.DataSource = dsData
      DefaultRowHeight = 24
      Navigator.Buttons.CustomButtons = <>
      RootValue = -1
      TabOrder = 0
      ExplicitTop = 28
    end
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      #24037#20855#26639)
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.LargeImages = DmImage.imgLarge
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 312
    Top = 72
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
      FloatLeft = 790
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
    Left = 288
    Top = 152
  end
  object dsData: TDataSource
    DataSet = cdsData
    Left = 368
    Top = 152
  end
end
