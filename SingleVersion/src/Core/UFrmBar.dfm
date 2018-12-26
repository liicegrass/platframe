inherited FrmBar: TFrmBar
  Caption = #24037#20855#26639#22522#31867
  ClientHeight = 497
  ClientWidth = 755
  ExplicitWidth = 771
  ExplicitHeight = 535
  PixelsPerInch = 96
  TextHeight = 12
  object dxbrmngr1: TdxBarManager
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
    Left = 184
    Top = 88
    DockControlHeights = (
      0
      0
      60
      0)
    object dxbrmngr1Bar1: TdxBar
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
      FloatLeft = 789
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'btnNew'
        end
        item
          Visible = True
          ItemName = 'btnEdit'
        end
        item
          Visible = True
          ItemName = 'btnDelete'
        end
        item
          Visible = True
          ItemName = 'btnDesign'
        end
        item
          Visible = True
          ItemName = 'btnPrint'
        end
        item
          Visible = True
          ItemName = 'btnExport'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object btnNew: TdxBarLargeButton
      Action = actNew
      Category = 0
      AutoGrayScale = False
      Width = 50
    end
    object btnEdit: TdxBarLargeButton
      Action = actEdit
      Category = 0
      AutoGrayScale = False
      Width = 50
    end
    object btnDelete: TdxBarLargeButton
      Action = actDelete
      Category = 0
      AutoGrayScale = False
      Width = 50
    end
    object btnQuery: TdxBarLargeButton
      Action = actQuery
      Category = 0
      AutoGrayScale = False
      Width = 50
    end
    object btnDesign: TdxBarLargeButton
      Action = actDesign
      Category = 0
      Visible = ivNever
      AutoGrayScale = False
      Width = 50
    end
    object btnPrint: TdxBarLargeButton
      Action = actPrint
      Category = 0
      Visible = ivNever
      AutoGrayScale = False
      Width = 50
    end
    object btnExport: TdxBarLargeButton
      Action = actExport
      Category = 0
      Visible = ivNever
      AutoGrayScale = False
      Width = 50
    end
    object btnSave: TdxBarLargeButton
      Action = actSave
      Category = 0
      AutoGrayScale = False
    end
    object btnCancel: TdxBarLargeButton
      Action = actCancel
      Category = 0
      AutoGrayScale = False
    end
  end
  object actlst1: TActionList
    Images = DmImage.imgLarge
    Left = 256
    Top = 88
    object actNew: TAction
      Caption = #22686#21152
      ImageIndex = 0
    end
    object actEdit: TAction
      Caption = #20462#25913
      ImageIndex = 1
    end
    object actDelete: TAction
      Caption = #21024#38500
      ImageIndex = 2
    end
    object actQuery: TAction
      Caption = #26597#35810
      ImageIndex = 5
    end
    object actDesign: TAction
      Caption = #35774#35745
      ImageIndex = 8
    end
    object actPrint: TAction
      Caption = #25171#21360
      ImageIndex = 6
    end
    object actExport: TAction
      Caption = #23548#20986
      ImageIndex = 4
    end
    object actImport: TAction
      Caption = #23548#20837
      ImageIndex = 3
    end
    object actExit: TAction
      Caption = #36864#20986
      ImageIndex = 9
    end
    object actSave: TAction
      Caption = #20445#23384
      ImageIndex = 10
    end
    object actCancel: TAction
      Caption = #21462#28040
      ImageIndex = 11
    end
  end
end
