unit UFrmRightInfo;

interface

uses
  Windows, SysUtils, Controls, UFrmRoot, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxControls, cxCustomData, cxStyles, cxTL,
  cxTextEdit, cxSpinEdit, cxCheckBox, cxTLdxBarBuiltInMenu, dxSkinsCore,
  dxSkinsDefaultPainters, cxInplaceContainer, cxDBTL, cxTLData, StdCtrls,
  cxButtons, Classes, ExtCtrls, cxImageComboBox, DBClient, DB, dxBar, cxClasses,
  UDmImage, ActnList, cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TFrmRightInfo = class(TFrmRoot)
    tvMenuList: TcxDBTreeList;
    dsData: TDataSource;
    ClmnSortNo: TcxDBTreeListColumn;
    ClmnRightName: TcxDBTreeListColumn;
    ClmnFunName: TcxDBTreeListColumn;
    ClmnLibName: TcxDBTreeListColumn;
    ClmnIsHide: TcxDBTreeListColumn;
    ClmnIsModal: TcxDBTreeListColumn;
    ClmnImageIndex: TcxDBTreeListColumn;
    cdsData: TClientDataSet;
    BarManager: TdxBarManager;
    BarTool: TdxBar;
    btnNew: TdxBarLargeButton;
    btnNewSub: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    btnSave: TdxBarLargeButton;
    btnCancel: TdxBarLargeButton;
    btnFullExpand: TdxBarLargeButton;
    btnFullCollapse: TdxBarLargeButton;
    actlst1: TActionList;
    actNew: TAction;
    actNewSub: TAction;
    actDelete: TAction;
    actSave: TAction;
    actCancel: TAction;
    actFullExpand: TAction;
    actFullCollapse: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actNewSubExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actFullExpandExecute(Sender: TObject);
    procedure actFullCollapseExecute(Sender: TObject);
    procedure actlst1Update(Action: TBasicAction; var Handled: Boolean);
  private

  public

  end;

var
  FrmRightInfo: TFrmRightInfo;

implementation

{$R *.dfm}

uses HJYUtils, HJYForms, HJYDataProviders, HJYDialogs;

const
  CGetRightInfoSQL = 'select * from RightInfo order by ParentGuid, SerialId';

procedure TFrmRightInfo.actFullExpandExecute(Sender: TObject);
begin
  inherited;
  tvMenuList.FullExpand;
end;

procedure TFrmRightInfo.actlst1Update(Action: TBasicAction;
  var Handled: Boolean);
begin
  inherited;
  actNew.Enabled := cdsData.Active;
  actNewSub.Enabled := not DataSetIsEmpty(cdsData);
  actDelete.Enabled := actNewSub.Enabled;
  actSave.Enabled := DataSetEditing(cdsData) or ClientDataSetEdited(cdsData);
  actCancel.Enabled := actSave.Enabled;
  actFullExpand.Enabled := not DataSetEditing(cdsData);
  actFullCollapse.Enabled := actFullExpand.Enabled;
end;

procedure TFrmRightInfo.actFullCollapseExecute(Sender: TObject);
begin
  inherited;
  tvMenuList.FullCollapse;
end;

procedure TFrmRightInfo.actCancelExecute(Sender: TObject);
begin
  inherited;
  if cdsData.State in [dsInsert, dsEdit] then
    cdsData.Cancel;
  tvMenuList.CancelEdit;
  cdsData.CancelUpdates;
end;

procedure TFrmRightInfo.actDeleteExecute(Sender: TObject);
begin
  inherited;
  if ShowConfirm('确定要删除当前选择行吗？') then
    cdsData.Delete;
end;

procedure TFrmRightInfo.actNewExecute(Sender: TObject);
var
  lParentId: string;
  lParentNode: TcxTreeListNode;
begin
  tvMenuList.SetFocus;
  lParentNode := tvMenuList.FocusedNode.Parent;
  with cdsData do
  begin
    CheckBrowseMode;
    lParentId := FindField('ParentGuid').AsString;
    Append;
    FindField('Guid').AsString := CreateGuidStr;
    FindField('ParentGuid').AsString := lParentId;
    if Assigned(lParentNode) then
    begin
      FindField('SerialId').AsInteger := lParentNode.Count;
      tvMenuList.FocusedNode.MoveTo(lParentNode, tlamAddChild);
    end;
  end;
end;

procedure TFrmRightInfo.actNewSubExecute(Sender: TObject);
var
  lParentId: string;
  lParentNode: TcxTreeListNode;
begin
  lParentNode := tvMenuList.FocusedNode;
  if not Assigned(lParentNode) then
    Exit;
  tvMenuList.SetFocus;
  with cdsData do
  begin
    CheckBrowseMode;
    lParentId := FindField('Guid').AsString;
    Append;
    FindField('Guid').AsString := CreateGuidStr;
    FindField('ParentGuid').AsString := lParentId;
    FindField('SerialId').AsInteger := lParentNode.Count;
  end;
  tvMenuList.FocusedNode.MoveTo(lParentNode, tlamAddChild);
  lParentNode.Expand(False);
end;

procedure TFrmRightInfo.actSaveExecute(Sender: TObject);
begin
  inherited;
  cdsData.CheckBrowseMode;
  with DataProvider do
  begin
    if DBAccess.ApplyUpdates(cdsData, 'RightInfo', 'Guid') then
      ShowMsg('保存成功！')
    else
      ShowWarning('保存失败！' + DBAccess.RetMsg);
  end;
end;

procedure TFrmRightInfo.FormDestroy(Sender: TObject);
begin
  if cdsData.Active then
    cdsData.Close;
end;

procedure TFrmRightInfo.FormShow(Sender: TObject);
begin
  DataProvider.DBAccess.Query(cdsData, CGetRightInfoSQL);
  tvMenuList.SetFocus;
  if not DataSetIsEmpty(cdsData) then
  begin
    tvMenuList.FullCollapse;
    tvMenuList.TopNode.Focused := True;
    tvMenuList.FocusedNode.Expand(False);
  end;
end;

initialization
  HJYFormMgr.RegisterFormClass(TFrmRightInfo);

end.
