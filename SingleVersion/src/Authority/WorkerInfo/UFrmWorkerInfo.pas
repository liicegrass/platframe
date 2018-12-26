unit UFrmWorkerInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uFrmGrid, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsDefaultPainters, cxStyles, dxSkinscxPCPainter,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  dxSkinsdxBarPainter, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, ActnList, dxBar, DBClient, cxClasses, ExtCtrls,
  cxGridLevel, cxGridCustomView, cxGrid, cxImageComboBox, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TFrmWorkerInfo = class(TFrmGrid)
    ClmnWorkerID: TcxGridDBColumn;
    ClmnWorkerName: TcxGridDBColumn;
    ClmnWorkerClass: TcxGridDBColumn;
    ClmnBeginTime: TcxGridDBColumn;
    ClmnEndTime: TcxGridDBColumn;
    cxgrdbclmnIsStop: TcxGridDBColumn;
    actInitPass: TAction;
    btnInitPass: TdxBarButton;
    procedure FormShow(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure grdbtblvwDataDblClick(Sender: TObject);
    procedure grdbtblvwDataKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actInitPassExecute(Sender: TObject);
    procedure actlst1Update(Action: TBasicAction; var Handled: Boolean);
  private
    FClassList: TStrings;

    function IsAdmin: Boolean;
    procedure QueryWorkerInfo(ALocate: Boolean = False; AValue: string = '');
    function GetWorkerClass(AList: TStrings): Boolean;
    procedure DoShowWorkerInfoEdit(AAction: string);
  public

  end;

var
  FrmWorkerInfo: TFrmWorkerInfo;

implementation

uses UMsgBox, HJYForms, UFrmWorkerInfoEdit, uSysObj, UHJYDataRecord,
  uPubFunLib, uConst, HJYCryptors;

{$R *.dfm}

function TFrmWorkerInfo.IsAdmin: Boolean;
var
  lClassID: string;
begin
  lClassID := CdsData.FindField('WorkerID').AsString;
  Result := SameText(lClassID, 'admin');
end;

procedure TFrmWorkerInfo.QueryWorkerInfo(ALocate: Boolean; AValue: string);
var
  lStrSql: string;
begin
  lStrSql := 'select a.*, b.ClassName from WorkerInfo a ' +
    ' inner join WorkerClass b on b.Guid=a.ClassGuid ' +
    ' where (a.IsDelete=0 or a.IsDelete is null) order by a.WorkerID';
  if not DBAccess.ReadDataSet(lStrSql, CdsData) then
  begin
    ShowMsg('获取用户信息失败！');
    Exit;
  end;
  if ALocate and (AValue <> '') then
    if cdsData.Active and not cdsData.IsEmpty then
       cdsData.Locate('WorkerID', AValue, [loCaseInsensitive]);
end;

function TFrmWorkerInfo.GetWorkerClass(AList: TStrings): Boolean;
var
  lStrSql: string;
  tmpCds: TClientDataSet;
begin
  tmpCds := TClientDataSet.Create(nil);
  try
    lStrSql := 'select Guid, ClassName from WorkerClass ' +
      ' where (IsDelete=0 or IsDelete is null) order by ClassID';
    Result := DBAccess.ReadDataSet(lStrSql, tmpCds);
    if not Result then Exit;
    AList.Clear;
    UHJYDataRecord.FillList(tmpCds, 'ClassName', AList);
    tmpCds.Close;
  finally
    FreeAndNil(tmpCds);
  end;
end;

procedure TFrmWorkerInfo.actDeleteExecute(Sender: TObject);
const
  DelWorkerClassSQL = 'update WorkerInfo set IsDelete=1, DeleteMan=''%s'', ' +
    ' DeleteTime=%s, EditTime=%s where Guid=''%s''';
var
  lWorkerGuid, lStrSql: string;
begin
  if CdsData.Active and not CdsData.IsEmpty then
  begin
    if IsAdmin then
    begin
      ShowMsg('“系统管理员”不允许删除！');
      Exit;
    end;
    if not ShowConfirm('您确定要删除当前选择的角色信息吗？') then
      Exit;
    lWorkerGuid := CdsData.FindField('Guid').AsString;
    lStrSql := Format(DelWorkerClassSQL, [Sys.WorkerInfo.WorkerID,
      Sys.DateStr, Sys.DateStr, lWorkerGuid]);
    if not DBAccess.ExecuteSQL(lStrSql) then
    begin
      ShowMsg('用户信息删除失败，请重新操作！');
      Exit;
    end;
    QueryWorkerInfo;
  end;
end;

procedure TFrmWorkerInfo.actEditExecute(Sender: TObject);
begin
  if CdsData.Active and not CdsData.IsEmpty then
  begin
    if IsAdmin then
    begin
      ShowMsg('“系统管理员”不允许修改！');
      Exit;
    end;
    DoShowWorkerInfoEdit('Edit');
  end;
end;

procedure TFrmWorkerInfo.actInitPassExecute(Sender: TObject);
const
  cInitPassSQL = 'update WorkerInfo set WorkerPass=''%s'', '+
    ' EditTime=%s, SyncState=0 where Guid=''%s''';
var
  lStrSql: string;
  lWorkerGuid: string;
begin
  inherited;
  if DataSetIsEmpty(cdsData) then
    Exit;
  if not ShowConfirm('您确定要初始化当前选择用户密码吗？') then
    Exit;
  lWorkerGuid := cdsData.FindField('Guid').AsString;
  lStrSql := Format(cInitPassSQL, [MD5(cDefWorkerPass), Sys.DateStr, lWorkerGuid]);
  if not DBAccess.ExecuteSQL(lStrSql) then
  begin
    ShowMsg('初始化密码失败！');
    Exit;
  end;
  ShowMsg('初始化密码成功！' + #10#13 + '初始化后密码为“' + cDefWorkerPass + '”！');
end;

procedure TFrmWorkerInfo.actlst1Update(Action: TBasicAction; var Handled: Boolean);
begin
  inherited;
  actInitPass.Enabled := not DataSetIsEmpty(cdsData);
end;

procedure TFrmWorkerInfo.actNewExecute(Sender: TObject);
begin
  if not CdsData.Active then
    Exit;
  DoShowWorkerInfoEdit('Append');
end;

procedure TFrmWorkerInfo.actRefreshExecute(Sender: TObject);
begin
  QueryWorkerInfo;
end;

procedure TFrmWorkerInfo.DoShowWorkerInfoEdit(AAction: string);
begin
  if not Assigned(FClassList) then
  begin
    FClassList := TStringList.Create;
    if not GetWorkerClass(FClassList) then
    begin
      ShowMsg('获取角色信息失败！');
      Exit;
    end;
  end;

  FrmWorkerInfoEdit := TFrmWorkerInfoEdit.Create(nil);
  try
    FrmWorkerInfoEdit.OperAction := AAction;
    FrmWorkerInfoEdit.cbbWorkerClass.Properties.Items.AddStrings(FClassList);
    if AAction = 'Append' then
    begin
      FrmWorkerInfoEdit.cbbIsStop.ItemIndex := 0;
      FrmWorkerInfoEdit.OnRefreshAfterPost := Self.QueryWorkerInfo;
    end
    else
    begin
      with FrmWorkerInfoEdit, CdsData do
      begin
        edtWorkerGuid.Text := FindField('Guid').AsString;
        edtWorkerID.Text := FindField('WorkerID').AsString;
        edtWorkerName.Text := FindField('WorkerName').AsString;
        cbbWorkerClass.ItemIndex := GetDataRecordIndex(FClassList, 'Guid',
          FindField('ClassGuid').AsString);
        edtBeginTime.Date := FindField('BeginTime').AsDateTime;
        edtEndTime.Date := FindField('EndTime').AsDateTime;
        cbbIsStop.ItemIndex := FindField('IsStop').AsInteger;
      end;
    end;
    if FrmWorkerInfoEdit.ShowModal = mrOk then
      QueryWorkerInfo(True, Trim(FrmWorkerInfoEdit.edtWorkerID.Text));
  finally
    FreeAndNil(FrmWorkerInfoEdit);
  end;
end;

procedure TFrmWorkerInfo.FormDestroy(Sender: TObject);
begin
  if Assigned(FClassList) then
  begin
    ClearList(FClassList);
    FreeAndNil(FClassList);
  end;
  inherited;
end;

procedure TFrmWorkerInfo.FormShow(Sender: TObject);
begin
  inherited;
  QueryWorkerInfo;
end;

procedure TFrmWorkerInfo.grdbtblvwDataDblClick(Sender: TObject);
begin
  inherited;
  actEditExecute(nil);
end;

procedure TFrmWorkerInfo.grdbtblvwDataKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    actEditExecute(nil);
end;

initialization
  HJYFormManager.RegisterForm(TFrmWorkerInfo);

end.
