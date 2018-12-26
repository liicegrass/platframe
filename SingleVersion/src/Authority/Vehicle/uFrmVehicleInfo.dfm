inherited FrmVehicleInfo: TFrmVehicleInfo
  Caption = #21496#26426#21450#36710#36742#31649#29702
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
        object ClmnDriverName: TcxGridDBColumn
          Caption = #21496#26426#22995#21517
          DataBinding.FieldName = 'DriverName'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnCarNo: TcxGridDBColumn
          Caption = #36710#29260#21495
          DataBinding.FieldName = 'CarNo'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnPhone: TcxGridDBColumn
          Caption = #25163#26426#21495#30721
          DataBinding.FieldName = 'Phone'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnCarKind: TcxGridDBColumn
          Caption = #36710#36742#31867#22411
          DataBinding.FieldName = 'CarKind'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnIsStop: TcxGridDBColumn
          Caption = #20351#29992#29366#24577
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
            end>
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnRemark: TcxGridDBColumn
          Caption = #22791#27880
          DataBinding.FieldName = 'Remark'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          Width = 200
        end
      end
    end
  end
  inherited dxbrmngr1: TdxBarManager
    PixelsPerInch = 96
    inherited btnPrint: TdxBarButton
      Enabled = False
      Visible = ivNever
    end
    inherited btnDesign: TdxBarButton
      Enabled = False
      Visible = ivNever
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
    inherited actRefresh: TAction
      OnExecute = actRefreshExecute
    end
  end
end
