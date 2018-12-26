unit UFrmWorkerRight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uFrmBar, dxSkinsCore, dxSkinsdxBarPainter, dxSkinsDefaultPainters,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, ComCtrls, DB,
  DBClient, dxBar, cxListView, cxContainer, cxTreeView, cxClasses, cxEdit,
  cxCustomData, cxStyles,
  cxTL, cxMaskEdit, cxTLdxBarBuiltInMenu,
  cxDataControllerConditionalFormattingRulesManagerDialog,
  cxSplitter, cxInplaceContainer, cxDBTL, cxTLData, ImgList;

type
  TFrmWorkerRight = class(TFrmBar)
    lvWorkerClass: TcxListView;
    cdsTemp: TClientDataSet;
    cdsWorkerRight: TClientDataSet;
    btnSave: TdxBarButton;
    btnFullCollapse: TdxBarButton;
    btnFullExpand: TdxBarButton;
    tvWorkerRight: TcxDBTreeList;
    ClmnRightName: TcxDBTreeListColumn;
    ClmnGuid: TcxDBTreeListColumn;
    cxspltr1: TcxSplitter;
    dsWorkerRight: TDataSource;
    ilImgRole: TImageList;
    procedure FormShow(Sender: TObject);
    procedure lvWorkerClassInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: string);
    procedure lvWorkerClassDeletion(Sender: TObject; Item: TListItem);
    procedure lvWorkerClassSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnSaveClick(Sender: TObject);
    procedure btnFullCollapseClick(Sender: TObject);
    procedure btnFullExpandClick(Sender: TObject);
    procedure tvWorkerRightNodeCheckChanged(Sender: TcxCustomTreeList;
      ANode: TcxTreeListNode; AState: TcxCheckBoxState);
  private
    FModified: Boolean; // 记录权限树是否修改
    FCurClassGuid: string; // 当前选中的角色Guid
    FCurClassID: string; // 当前选中的角色ID

    function QueryWorkerClassInfo: Boolean;
    procedure LoadAuthority(const AClassGuid: string);
    function CheckToSave: Boolean;
    function SaveWorkerRight: Boolean;
    function LoadWorkerRightInfo: Boolean;
    procedure InitRightInfoCheckGroup;
    procedure SetRoleRightCheckedState(AValue: TcxCheckBoxState);
    procedure InitRoleRightCheckedState;
  public

  end;

var
  FrmWorkerRight: TFrmWorkerRight;

implementation

uses HJYForms, uSysObj, UHJYDataRecord, UMsgBox, UPubFunLib;
{$R *.dfm}

const
  cGetRightInfoSQL =
    'select * from RightInfo where (IsHide=0 or IsHide is null) order by ParentGuid, Serialid';
  cGetWorkerClassSQL =
    'select * from WorkerClass where (IsDelete=0 or IsDelete is null) order by ClassID';

function TFrmWorkerRight.QueryWorkerClassInfo: Boolean;
var
  lItem: TListItem;
  lRec: TDataRecord;
begin
  Result := False;
  if not DBAccess.ReadDataSet(cGetWorkerClassSQL, cdsTemp) then
  begin
    ShowMsg('角色信息获取失败！');
    Exit;
  end;
  lvWorkerClass.Items.BeginUpdate;
  try
    lvWorkerClass.Clear;
    cdsTemp.First;
    while not cdsTemp.Eof do
    begin
      lItem := lvWorkerClass.Items.Add;
      lItem.Caption := cdsTemp.Fieldbyname('ClassName').AsString;
      lItem.ImageIndex := 0;

      lRec := TDataRecord.Create;
      lRec.LoadFromDataSet(cdsTemp);
      lItem.Data := Pointer(lRec);

      cdsTemp.Next;
    end;
    cdsTemp.Close;
    Result := True;
  finally
    lvWorkerClass.Items.EndUpdate;
  end;
end;

procedure TFrmWorkerRight.InitRightInfoCheckGroup;
var
  I: Integer;
begin
  tvWorkerRight.BeginUpdate;
  try
    // 显示根复选框
    if Assigned(tvWorkerRight.Root) then
      tvWorkerRight.Root.CheckGroupType := ncgCheckGroup;
    // 显示子复选框
    tvWorkerRight.OptionsView.CheckGroups := True;
    for I := 0 to tvWorkerRight.AbsoluteCount - 1 do
      tvWorkerRight.AbsoluteItems[I].CheckGroupType :=
        ncgCheckGroup finally tvWorkerRight.EndUpdate;
  end;
end;

function TFrmWorkerRight.LoadWorkerRightInfo: Boolean;
begin
  Result := False;
  if not DBAccess.ReadDataSet(cGetRightInfoSQL, cdsWorkerRight) then
  begin
    ShowMsg('权限列表获取失败！');
    Exit;
  end;
  InitRightInfoCheckGroup;
  tvWorkerRight.FullExpand;
  Result := True;
end;

procedure TFrmWorkerRight.FormShow(Sender: TObject);
begin
  inherited;
  if not QueryWorkerClassInfo then
    Exit;
  if not LoadWorkerRightInfo then
    Exit;
  lvWorkerClass.Enabled := True;
  if lvWorkerClass.Items.Count > 0 then
    lvWorkerClass.Items[0].Selected := True;
end;

procedure TFrmWorkerRight.lvWorkerClassDeletion(Sender: TObject;
  Item: TListItem);
begin
  if Assigned(Item.Data) then
  begin
    TDataRecord(Item.Data).Free;
    Item.Data := nil;
  end;
end;

procedure TFrmWorkerRight.lvWorkerClassInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: string);
begin
  if Assigned(Item.Data) then
    InfoTip := TDataRecord(Item.Data).FieldValueAsString('Remark');
end;

procedure TFrmWorkerRight.lvWorkerClassSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  lDataRecord: TDataRecord;
begin
  tvWorkerRight.Enabled := False;
  if Selected and Assigned(Item.Data) then
  begin
    if not CheckToSave then
      Exit;
    FModified := False;
    lDataRecord := TDataRecord(Item.Data);
    FCurClassGuid := lDataRecord.FieldValueAsString('Guid');
    FCurClassID := lDataRecord.FieldValueAsString('ClassID');
    LoadAuthority(FCurClassGuid);
    if FCurClassID <> 'admin' then
      tvWorkerRight.Enabled := True;
  end;
end;

procedure TFrmWorkerRight.tvWorkerRightNodeCheckChanged
  (Sender: TcxCustomTreeList; ANode: TcxTreeListNode;
  AState: TcxCheckBoxState);
begin
  inherited;
  FModified := True;
end;

function TFrmWorkerRight.SaveWorkerRight: Boolean;
const
  cGetWorkerRightSQL = 'select * from WorkerRight where ClassGuid=''%s''';
var
  I: Integer;
  lStrSql: string;
  tmpCds: TClientDataSet;
  lClassGuidField, lRightGuidField, lEditTimeField, lSyncStateField: TField;
  lRightGuid: string;
begin
  if not FModified then
  begin
    Result := True;
    Exit;
  end;
  Result := False;
  tmpCds := TClientDataSet.Create(nil);
  try
    lStrSql := Format(cGetWorkerRightSQL, [FCurClassGuid]);
    if not DBAccess.ReadDataSet(lStrSql, tmpCds) then
    begin
      ShowMsg('角色权限保存失败！');
      Exit;
    end;
    lClassGuidField := tmpCds.Fieldbyname('ClassGuid');
    lRightGuidField := tmpCds.Fieldbyname('RightGuid');
    lEditTimeField := tmpCds.Fieldbyname('EditTime');
    lSyncStateField := tmpCds.Fieldbyname('SyncState');
    for I := 0 to tvWorkerRight.AbsoluteCount - 1 do
    begin
      lRightGuid := tvWorkerRight.AbsoluteItems[I].Texts[1];
      if tvWorkerRight.AbsoluteItems[I].CheckState = cbsUnchecked then
      begin
        if tmpCds.Locate('RightGuid', lRightGuid, []) then
          tmpCds.Delete;
      end
      else
      begin
        if tmpCds.Locate('RightGuid', lRightGuid, []) then
          tmpCds.Edit
        else
        begin
          tmpCds.Append;
          tmpCds.Fieldbyname('Guid').AsString := CreateGuidStr;
        end;
        lClassGuidField.AsString := Self.FCurClassGuid;
        lRightGuidField.AsString := lRightGuid;
        lEditTimeField.AsString := FormatDateTime('yyyy-mm-dd hh:mm:ss', Now);
        lSyncStateField.AsInteger := 0;
        tmpCds.Post;
      end;
    end;
    if not DBAccess.ApplyUpdates('WorkerRight', tmpCds) then
    begin
      ShowMsg('角色权限保存失败！');
      Exit;
    end;
    FModified := False;
    Result := True;
  finally
    tmpCds.Free;
  end;
end;

procedure TFrmWorkerRight.btnFullCollapseClick(Sender: TObject);
begin
  inherited;
  tvWorkerRight.FullCollapse;
end;

procedure TFrmWorkerRight.btnFullExpandClick(Sender: TObject);
begin
  inherited;
  tvWorkerRight.FullExpand;
end;

procedure TFrmWorkerRight.btnSaveClick(Sender: TObject);
begin
  inherited;
  if lvWorkerClass.Selected = nil then
  begin
    ShowMsg('请先选择需要保存权限的角色！');
    Exit;
  end;

  if FCurClassID = 'admin' then
  begin
    ShowMsg('“系统管理员”的权限不能修改！');
    Exit;
  end;
  if SaveWorkerRight then
    ShowSuccess('角色权限保存成功！');
end;

function TFrmWorkerRight.CheckToSave: Boolean;
begin
  Result := True;
  if not FModified then
    Exit;
  if not ShowYesOrNo('权限已经改变，是否保存？') then
    Exit;
  Result := SaveWorkerRight;
end;

procedure TFrmWorkerRight.SetRoleRightCheckedState(AValue: TcxCheckBoxState);
var
  I: Integer;
begin
  for I := 0 to tvWorkerRight.AbsoluteCount - 1 do
    tvWorkerRight.AbsoluteItems[I].CheckState := AValue;
end;

procedure TFrmWorkerRight.LoadAuthority(const AClassGuid: string);
const
  cGetWorkerRightListSQL =
    'select RightGuid from WorkerRight where ClassGuid=''%s''';
var
  lStrSql: string;
begin
  tvWorkerRight.OnNodeCheckChanged := nil;
  try
    if FCurClassID = 'admin' then
      SetRoleRightCheckedState(cbsChecked)
    else
    begin
      SetRoleRightCheckedState(cbsUnchecked);
      lStrSql := Format(cGetWorkerRightListSQL, [AClassGuid]);
      if not DBAccess.ReadDataSet(lStrSql, cdsTemp) then
      begin
        ShowMsg('角色权限获取失败！');
        Exit;
      end;
      InitRoleRightCheckedState;
    end;
  finally
    tvWorkerRight.OnNodeCheckChanged := tvWorkerRightNodeCheckChanged;
  end;
end;

procedure TFrmWorkerRight.InitRoleRightCheckedState;
var
  I: Integer;
  lRightId: string;
  lRightList: TStrings;
begin
  if DataSetIsEmpty(cdsTemp) then
    Exit;
  lRightList := TStringList.Create;
  try
    DataSetToList(cdsTemp, lRightList);
    for I := 0 to tvWorkerRight.AbsoluteCount - 1 do
    begin
      if not tvWorkerRight.AbsoluteItems[I].HasChildren then
      begin
        lRightId := tvWorkerRight.AbsoluteItems[I].Texts[1];
        if lRightList.IndexOf(lRightId) <> -1 then
          tvWorkerRight.AbsoluteItems[I].CheckState := cbsChecked;
      end;
    end;
  finally
    lRightList.Free;
  end;
end;

initialization
  HJYFormManager.RegisterForm(TFrmWorkerRight);

end.
