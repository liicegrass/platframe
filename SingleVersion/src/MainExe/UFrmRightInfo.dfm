inherited FrmRightInfo: TFrmRightInfo
  Caption = #21151#33021#33756#21333#32500#25252
  ClientHeight = 535
  ClientWidth = 821
  WindowState = wsMaximized
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 837
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 12
  object tvMenuList: TcxDBTreeList
    Left = 0
    Top = 60
    Width = 821
    Height = 475
    Align = alClient
    Bands = <
      item
      end>
    DataController.DataSource = dsData
    DataController.ParentField = 'parent_id'
    DataController.KeyField = 'id'
    DefaultRowHeight = 12
    LookAndFeel.SkinName = 'UserSkin'
    Navigator.Buttons.CustomButtons = <>
    OptionsView.ColumnAutoWidth = True
    OptionsView.GridLines = tlglBoth
    OptionsView.Indicator = True
    RootValue = -1
    TabOrder = 0
    object ClmnRightName: TcxDBTreeListColumn
      PropertiesClassName = 'TcxTextEditProperties'
      Caption.AlignHorz = taCenter
      Caption.Text = #21151#33021#21517#31216
      DataBinding.FieldName = 'RightName'
      Width = 300
      Position.ColIndex = 0
      Position.LineCount = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ClmnSortNo: TcxDBTreeListColumn
      PropertiesClassName = 'TcxSpinEditProperties'
      Properties.Alignment.Horz = taLeftJustify
      Properties.SpinButtons.Visible = False
      Properties.UseCtrlIncrement = True
      Caption.AlignHorz = taCenter
      Caption.Text = #24207#21495
      DataBinding.FieldName = 'SerialId'
      Width = 100
      Position.ColIndex = 1
      Position.LineCount = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ClmnImageIndex: TcxDBTreeListColumn
      PropertiesClassName = 'TcxImageComboBoxProperties'
      Properties.Alignment.Horz = taCenter
      Properties.Images = DmImage.imgNavBar
      Properties.Items = <
        item
          ImageIndex = 0
          Value = 0
        end
        item
          ImageIndex = 1
          Value = 1
        end
        item
          ImageIndex = 2
          Value = 2
        end
        item
          ImageIndex = 3
          Value = 3
        end
        item
          ImageIndex = 4
          Value = 4
        end
        item
          ImageIndex = 5
          Value = 5
        end
        item
          ImageIndex = 6
          Value = 6
        end
        item
          ImageIndex = 7
          Value = 7
        end
        item
          ImageIndex = 8
          Value = 8
        end
        item
          ImageIndex = 9
          Value = 9
        end
        item
          ImageIndex = 10
          Value = 10
        end
        item
          ImageIndex = 11
          Value = 11
        end
        item
          ImageIndex = 12
          Value = 12
        end
        item
          ImageIndex = 13
          Value = 13
        end
        item
          ImageIndex = 14
          Value = 14
        end
        item
          ImageIndex = 15
          Value = 15
        end
        item
          ImageIndex = 16
          Value = 16
        end
        item
          ImageIndex = 17
          Value = 17
        end
        item
          ImageIndex = 18
          Value = 18
        end
        item
          ImageIndex = 19
          Value = 19
        end
        item
          ImageIndex = 20
          Value = 20
        end
        item
          ImageIndex = 21
          Value = 21
        end
        item
          ImageIndex = 22
          Value = 22
        end
        item
          ImageIndex = 23
          Value = 23
        end
        item
          ImageIndex = 24
          Value = 24
        end
        item
          ImageIndex = 25
          Value = 25
        end
        item
          ImageIndex = 26
          Value = 26
        end
        item
          ImageIndex = 27
          Value = 27
        end
        item
          ImageIndex = 28
          Value = 28
        end
        item
          ImageIndex = 29
          Value = 29
        end
        item
          ImageIndex = 30
          Value = 30
        end
        item
          ImageIndex = 31
          Value = 31
        end
        item
          ImageIndex = 32
          Value = 32
        end
        item
          ImageIndex = 33
          Value = 33
        end
        item
          ImageIndex = 34
          Value = 34
        end
        item
          ImageIndex = 35
          Value = 35
        end
        item
          ImageIndex = 36
          Value = 36
        end
        item
          ImageIndex = 37
          Value = 37
        end
        item
          ImageIndex = 38
          Value = 38
        end
        item
          ImageIndex = 39
          Value = 39
        end
        item
          ImageIndex = 40
          Value = 40
        end
        item
          ImageIndex = 41
          Value = 41
        end
        item
          ImageIndex = 42
          Value = 42
        end
        item
          ImageIndex = 43
          Value = 43
        end
        item
          ImageIndex = 44
          Value = 44
        end
        item
          ImageIndex = 45
          Value = 45
        end
        item
          ImageIndex = 46
          Value = 46
        end
        item
          ImageIndex = 47
          Value = 47
        end
        item
          ImageIndex = 48
          Value = 48
        end
        item
          ImageIndex = 49
          Value = 49
        end
        item
          ImageIndex = 50
          Value = 50
        end
        item
          ImageIndex = 51
          Value = 51
        end
        item
          ImageIndex = 52
          Value = 52
        end
        item
          ImageIndex = 53
          Value = 53
        end
        item
          ImageIndex = 54
          Value = 54
        end
        item
          ImageIndex = 55
          Value = 55
        end
        item
          ImageIndex = 56
          Value = 56
        end
        item
          ImageIndex = 57
          Value = 57
        end
        item
          ImageIndex = 58
          Value = 58
        end
        item
          ImageIndex = 59
          Value = 59
        end
        item
          ImageIndex = 60
          Value = 60
        end
        item
          ImageIndex = 61
          Value = 61
        end
        item
          ImageIndex = 62
          Value = 62
        end
        item
          ImageIndex = 63
          Value = 63
        end
        item
          ImageIndex = 64
          Value = 64
        end
        item
          ImageIndex = 65
          Value = 65
        end
        item
          ImageIndex = 66
          Value = 66
        end
        item
          ImageIndex = 67
          Value = 67
        end
        item
          ImageIndex = 68
          Value = 68
        end>
      Properties.ShowDescriptions = False
      Caption.AlignHorz = taCenter
      Caption.Text = #22270#26631
      DataBinding.FieldName = 'ImageIndex'
      Width = 100
      Position.ColIndex = 2
      Position.LineCount = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ClmnFunName: TcxDBTreeListColumn
      PropertiesClassName = 'TcxTextEditProperties'
      Caption.AlignHorz = taCenter
      Caption.Text = #21151#33021#20989#25968
      DataBinding.FieldName = 'FunName'
      Width = 308
      Position.ColIndex = 3
      Position.LineCount = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ClmnLibName: TcxDBTreeListColumn
      PropertiesClassName = 'TcxTextEditProperties'
      Caption.AlignHorz = taCenter
      Caption.Text = #21253'/'#24211#25991#20214
      DataBinding.FieldName = 'LibName'
      Width = 200
      Position.ColIndex = 4
      Position.LineCount = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ClmnIsHide: TcxDBTreeListColumn
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.NullStyle = nssUnchecked
      Properties.ValueChecked = '1'
      Properties.ValueUnchecked = '0'
      Caption.AlignHorz = taCenter
      Caption.Text = #38544#34255
      DataBinding.FieldName = 'IsHide'
      Width = 100
      Position.ColIndex = 5
      Position.LineCount = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ClmnIsModal: TcxDBTreeListColumn
      PropertiesClassName = 'TcxCheckBoxProperties'
      Properties.NullStyle = nssUnchecked
      Properties.ValueChecked = '1'
      Properties.ValueUnchecked = '0'
      Caption.AlignHorz = taCenter
      Caption.Text = #24377#31383#26174#31034
      DataBinding.FieldName = 'IsModal'
      Width = 100
      Position.ColIndex = 6
      Position.LineCount = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object dsData: TDataSource
    DataSet = cdsData
    Left = 192
    Top = 144
  end
  object cdsData: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 136
    Top = 144
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
    Left = 264
    Top = 136
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      60
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
      FloatLeft = 855
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
          ItemName = 'btnNewSub'
        end
        item
          Visible = True
          ItemName = 'btnDelete'
        end
        item
          Visible = True
          ItemName = 'btnSave'
        end
        item
          Visible = True
          ItemName = 'btnCancel'
        end
        item
          Visible = True
          ItemName = 'btnFullExpand'
        end
        item
          Visible = True
          ItemName = 'btnFullCollapse'
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
    end
    object btnNewSub: TdxBarLargeButton
      Action = actNewSub
      Category = 0
      AutoGrayScale = False
    end
    object btnDelete: TdxBarLargeButton
      Action = actDelete
      Category = 0
      AutoGrayScale = False
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
    object btnFullExpand: TdxBarLargeButton
      Action = actFullExpand
      Category = 0
      AutoGrayScale = False
    end
    object btnFullCollapse: TdxBarLargeButton
      Action = actFullCollapse
      Category = 0
      AutoGrayScale = False
    end
  end
  object actlst1: TActionList
    Images = DmImage.imgLarge
    OnUpdate = actlst1Update
    Left = 352
    Top = 144
    object actNew: TAction
      Caption = #22686#21152#21516#32423
      ImageIndex = 0
      OnExecute = actNewExecute
    end
    object actNewSub: TAction
      Caption = #22686#21152#19979#32423
      ImageIndex = 0
      OnExecute = actNewSubExecute
    end
    object actDelete: TAction
      Caption = #21024#38500
      ImageIndex = 2
      OnExecute = actDeleteExecute
    end
    object actSave: TAction
      Caption = #20445#23384
      ImageIndex = 10
      OnExecute = actSaveExecute
    end
    object actCancel: TAction
      Caption = #21462#28040
      ImageIndex = 11
      OnExecute = actCancelExecute
    end
    object actFullExpand: TAction
      Caption = #20840#37096#23637#24320
      ImageIndex = 3
      OnExecute = actFullExpandExecute
    end
    object actFullCollapse: TAction
      Caption = #20840#37096#25240#21472
      ImageIndex = 4
      OnExecute = actFullCollapseExecute
    end
  end
end
