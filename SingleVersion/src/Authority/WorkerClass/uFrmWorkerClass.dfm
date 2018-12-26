inherited FrmWorkerClass: TFrmWorkerClass
  Caption = #35282#33394#31649#29702
  ClientHeight = 397
  ClientWidth = 692
  OnShow = FormShow
  ExplicitWidth = 708
  ExplicitHeight = 435
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlClient: TPanel
    Width = 692
    Height = 397
    ExplicitWidth = 692
    ExplicitHeight = 397
    inherited pnlTop: TPanel
      Width = 692
      ExplicitWidth = 692
    end
    inherited grdData: TcxGrid
      Width = 692
      Height = 343
      ExplicitWidth = 692
      ExplicitHeight = 346
      inherited grdbtblvwData: TcxGridDBTableView
        OnDblClick = grdbtblvwDataDblClick
        OnKeyPress = grdbtblvwDataKeyPress
        object ClmnClassID: TcxGridDBColumn
          Caption = #35282#33394#32534#30721
          DataBinding.FieldName = 'ClassID'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          SortIndex = 0
          SortOrder = soAscending
          Width = 100
        end
        object ClmnClassName: TcxGridDBColumn
          Caption = #35282#33394#21517#31216
          DataBinding.FieldName = 'ClassName'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
        object ClmnRemark: TcxGridDBColumn
          Caption = #22791#27880
          DataBinding.FieldName = 'Remark'
          PropertiesClassName = 'TcxTextEditProperties'
          HeaderAlignmentHorz = taCenter
          Width = 120
        end
      end
    end
    inherited dxbrdckcntrl1: TdxBarDockControl
      Width = 692
      ExplicitWidth = 692
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
    inherited BtnExport: TdxBarButton
      ImageIndex = 25
    end
  end
  inherited dsData: TDataSource
    Left = 304
    Top = 176
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
  end
end
