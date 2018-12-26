inherited FrmWorkerInfo: TFrmWorkerInfo
  Caption = #29992#25143#31649#29702
  OnDestroy = FormDestroy
  OnShow = FormShow
  ExplicitWidth = 727
  ExplicitHeight = 407
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlClient: TPanel
    inherited grdData: TcxGrid
      inherited grdbtblvwData: TcxGridDBTableView
        OnDblClick = grdbtblvwDataDblClick
        OnKeyPress = grdbtblvwDataKeyPress
        object ClmnWorkerID: TcxGridDBColumn
          Caption = #29992#25143#32534#30721
          DataBinding.FieldName = 'WorkerID'
          HeaderAlignmentHorz = taCenter
          SortIndex = 0
          SortOrder = soAscending
          Width = 120
        end
        object ClmnWorkerName: TcxGridDBColumn
          Caption = #29992#25143#21517#31216
          DataBinding.FieldName = 'WorkerName'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnWorkerClass: TcxGridDBColumn
          Caption = #25152#23646#35282#33394
          DataBinding.FieldName = 'ClassName'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnBeginTime: TcxGridDBColumn
          Caption = #36215#22987#26102#38388
          DataBinding.FieldName = 'BeginTime'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnEndTime: TcxGridDBColumn
          Caption = #32467#26463#26102#38388
          DataBinding.FieldName = 'EndTime'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object cxgrdbclmnIsStop: TcxGridDBColumn
          Caption = #29992#25143#29366#24577
          DataBinding.FieldName = 'IsStop'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Alignment.Horz = taCenter
          Properties.Items = <
            item
              Description = #27491#24120
              ImageIndex = 0
              Value = 0
            end
            item
              Description = #20572#29992
              Value = 1
            end
            item
              Description = #27491#24120
            end>
          HeaderAlignmentHorz = taCenter
        end
      end
    end
  end
  inherited dxbrmngr1: TdxBarManager
    PixelsPerInch = 96
    inherited dxbrMenu: TdxBar
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
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'btnInitPass'
        end
        item
          Visible = True
          ItemName = 'BtnRefresh'
        end
        item
          Visible = True
          ItemName = 'btnPrint'
        end
        item
          Visible = True
          ItemName = 'btnDesign'
        end>
    end
    inherited btnPrint: TdxBarButton
      Enabled = False
      Visible = ivNever
    end
    inherited btnDesign: TdxBarButton
      Enabled = False
      Visible = ivNever
    end
    object btnInitPass: TdxBarButton [9]
      Action = actInitPass
      Category = 0
    end
  end
  inherited dxbrpmn1: TdxBarPopupMenu
    PixelsPerInch = 96
  end
  inherited actlst1: TActionList
    inherited actNew: TAction
      OnExecute = actNewExecute
    end
    inherited actEdit: TAction
      OnExecute = actEditExecute
    end
    inherited actDelete: TAction
      OnExecute = actDeleteExecute
    end
    inherited actRefresh: TAction
      OnExecute = actRefreshExecute
    end
    object actInitPass: TAction
      Caption = #23494#30721#21021#22987#21270
      ImageIndex = 0
      OnExecute = actInitPassExecute
    end
  end
end
