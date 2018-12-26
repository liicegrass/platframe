unit uFrmWorkerClass;

interface

uses
  Windows, uFrmGrid, Controls, Classes, dxSkinsCore, SysUtils,
  uFrmBar, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsDefaultPainters, cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxSkinsdxBarPainter, cxTextEdit,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, ActnList, dxBar,
  DBClient, cxClasses, ExtCtrls, cxGridLevel, cxGridCustomView, cxGrid, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TFrmWorkerClass = class(TFrmGrid)
    ClmnClassID: TcxGridDBColumn;
    ClmnClassName: TcxGridDBColumn;
    ClmnRemark: TcxGridDBColumn;
    procedure FormShow(Sender: TObject);
    procedure GrdbtblvwDataKeyPress(Sender: TObject; var Key: Char);
    procedure actNewExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure grdbtblvwDataDblClick(Sender: TObject);
  private
    procedure QueryWorkerClass(ALocate: Boolean = False; AValue: string = '');
    function IsAdmin: Boolean;
    procedure DoShowWorkerClassEdit(AAction: string);
  public

  end;

var
  FrmWorkerClass: TFrmWorkerClass;

implementation

uses HJYForms, uFrmWorkerClassEdit, UMsgBox, uSysObj;

{$R *.dfm}

function TFrmWorkerClass.IsAdmin: Boolean;
var
  lClassID: string;
begin
  lClassID := CdsData.FindField('ClassID').AsString;
  Result := SameText(lClassID, 'admin');
end;

procedure TFrmWorkerClass.QueryWorkerClass(ALocate: Boolean; AValue: string);
var
  lStrSql: string;
begin
  lStrSql := 'select * from WorkerClass where (IsDelete=0 or IsDelete is null) order by ClassID';
  if not DBAccess.ReadDataSet(lStrSql, CdsData) then
  begin
    ShowMsg('获取角色信息失败！');
    Exit;
  end;
  if ALocate and (AValue <> '') then
    if cdsData.Active and not cdsData.IsEmpty then
       cdsData.Locate('ClassID', AValue, [loCaseInsensitive]);
end;

procedure TFrmWorkerClass.actDeleteExecute(Sender: TObject);
const
  DelWorkerClassSQL = 'update WorkerClass set IsDelete=1, DeleteMan=''%s'', '+
    ' DeleteTime=%s, EditTime=%s where Guid=''%s''';
var
  lClassGuid, lStrSql: string;
begin
  if CdsData.Active and not CdsData.IsEmpty then
  begin
    if IsAdmin then
    begin
      ShowMsg('“系统管理员”不允许删除！');
      Exit;
    end;
    if not ShowConfirm('您确定要删除当前选择的角色信息吗？') then Exit;
    lClassGuid := cdsData.FindField('Guid').AsString;
    lStrSql := Format(DelWorkerClassSQL, [Sys.WorkerInfo.WorkerID,
      Sys.DateStr, Sys.DateStr, lClassGuid]);
    if not DBAccess.ExecuteSQL(lStrSql) then
    begin
      ShowMsg('角色信息删除失败，请重新操作！');
      Exit;
    end;
    QueryWorkerClass;
  end;
end;

procedure TFrmWorkerClass.actEditExecute(Sender: TObject);
begin
  inherited;
  if CdsData.Active and not CdsData.IsEmpty then
  begin
    if IsAdmin then
    begin
      ShowMsg('“系统管理员”不允许修改！');
      Exit;
    end;
    DoShowWorkerClassEdit('Edit');
  end;
end;

procedure TFrmWorkerClass.actNewExecute(Sender: TObject);
begin
  inherited;
  if cdsData.Active then
    DoShowWorkerClassEdit('Append');
end;

procedure TFrmWorkerClass.actRefreshExecute(Sender: TObject);
begin
  QueryWorkerClass;
end;

procedure TFrmWorkerClass.DoShowWorkerClassEdit(AAction: string);
begin
  FrmWorkerClassEdit := TFrmWorkerClassEdit.Create(nil);
  try
    FrmWorkerClassEdit.OperAction := AAction;
    if AAction = 'Append' then
      FrmWorkerClassEdit.OnRefreshAfterPost := Self.QueryWorkerClass
    else begin
      with FrmWorkerClassEdit, cdsData do
      begin
        edtClassGuid.Text := FindField('Guid').AsString;
        edtClassID.Text := FindField('ClassID').AsString;
        edtClassName.Text := FindField('ClassName').AsString;
        edtRemark.Text := FindField('Remark').AsString;
      end;
    end;
    if FrmWorkerClassEdit.ShowModal = mrOk then
      QueryWorkerClass(True, Trim(FrmWorkerClassEdit.edtClassID.Text));
  finally
    FreeAndNil(FrmWorkerClassEdit);
  end;
end;

procedure TFrmWorkerClass.FormShow(Sender: TObject);
begin
  inherited;
  QueryWorkerClass;
end;

procedure TFrmWorkerClass.grdbtblvwDataDblClick(Sender: TObject);
begin
  actEditExecute(nil);
end;

procedure TFrmWorkerClass.GrdbtblvwDataKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    actEditExecute(nil);
end;

initialization
  HJYFormManager.RegisterForm(TFrmWorkerClass);

end.
