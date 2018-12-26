unit uFrmWorkerClassEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  uFrmModal, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  cxControls, cxContainer, cxEdit, dxSkinsCore, dxSkinsDefaultPainters,
  cxCheckBox, cxTextEdit, StdCtrls, ActnList, cxButtons, ExtCtrls;

type
  TFrmWorkerClassEdit = class(TFrmModal)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    edtClassID: TcxTextEdit;
    edtClassName: TcxTextEdit;
    edtRemark: TcxTextEdit;
    edtClassGuid: TcxTextEdit;
    chkAlwaysNew: TcxCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkAlwaysNewClick(Sender: TObject);
  private
    FOperAction: string;
    FOnRefreshAfterPost: TRefreshAfterSave;

    procedure ClearControls;
    function BeforeExecute: Boolean;
    function DoExecute: Boolean;
  public
    property OnRefreshAfterPost: TRefreshAfterSave read FOnRefreshAfterPost write FOnRefreshAfterPost;
    property OperAction: string read FOperAction write FOperAction;
  end;

var
  FrmWorkerClassEdit: TFrmWorkerClassEdit;

implementation

uses UMsgBox, UPubFunLib, uSysObj;

{$R *.dfm}

{ TFrmRoleEdit }

function TFrmWorkerClassEdit.BeforeExecute: Boolean;
const
  cCheckIDExistsSQL = 'select * from WorkerClass where ClassID=''%s''';
var
  lStrSql: string;
  iResult: Integer;
begin
  Result := False;

  if Trim(edtClassID.Text) = '' then
  begin
    edtClassID.SetFocus;
    ShowMsg('角色编码不能为空！');
    Exit;
  end;

  if Trim(edtClassName.Text) = '' then
  begin
    edtClassName.SetFocus;
    ShowMsg('角色名称不能为空！');
    Exit;
  end;

  if FOperAction = 'Append' then
    lStrSql := Format(cCheckIDExistsSQL, [Trim(edtClassID.Text)])
  else
    lStrSql := Format(cCheckIDExistsSQL + ' and Guid <> ''%s''',
      [Trim(edtClassID.Text), Trim(edtClassGuid.Text)]);
  iResult := DBAccess.DataSetIsEmpty(lStrSql);
  if iResult = -1 then
  begin
    ShowMsg('获取角色编码是否重复失败！');
    Exit;
  end;
  if iResult = 0 then
  begin
    ShowMsg('当前角色编码已经存在，请重新输入！');
    Exit;
  end;

  Result := True;
end;

procedure TFrmWorkerClassEdit.btnOkClick(Sender: TObject);
begin
  if not BeforeExecute then Exit;
  if not DoExecute then Exit;
  if (FOperAction = 'Append') and chkAlwaysNew.Checked then
  begin
    if Assigned(FOnRefreshAfterPost) then
      FOnRefreshAfterPost(True, Trim(edtClassID.Text));
    ClearControls;
    edtClassID.SetFocus;
  end
  else
    ModalResult := mrOk;
end;

procedure TFrmWorkerClassEdit.chkAlwaysNewClick(Sender: TObject);
begin
  Sys.SetAlwaysNew(Self.ClassName, chkAlwaysNew.Checked);
end;

procedure TFrmWorkerClassEdit.ClearControls;
begin
  edtClassGuid.Text := '';
  edtClassID.Text := '';
  edtClassName.Text := '';
  edtRemark.Text := '';
end;

function TFrmWorkerClassEdit.DoExecute: Boolean;
const
  InsertWorkerClassSQL = 'insert into WorkerClass(Guid, ClassID, ClassName, '+
    ' CreateMan, CreateTime, IsDelete, Remark, EditTime, SyncState) '+
    ' values(''%s'', ''%s'', ''%s'', ''%s'', %s, 0, ''%s'', %s, 0)';

  UpdateWorkerClassSQL = 'update WorkerClass set ClassID=''%s'', '+
    ' ClassName=''%s'', Remark=''%s'', EditTime=%s, SyncState=0 where Guid=''%s''';
var
  lStrSql: string;
  lClassGuid, lClassID, lClassName, lRemark: string;
begin
  lClassID := Trim(edtClassID.Text);
  lClassName := Trim(edtClassName.Text);
  lRemark := Trim(edtRemark.Text);
  if FOperAction = 'Append' then
  begin
    lClassGuid := CreateGuidStr;
    lStrSql := Format(InsertWorkerClassSQL, [lClassGuid, lClassID, lClassName,
      Sys.WorkerInfo.WorkerID, Sys.DateStr, lRemark, Sys.DateStr]);
  end else begin
    lClassGuid := Trim(edtClassGuid.Text);
    lStrSql := Format(UpdateWorkerClassSQL, [lClassID, lClassName, lRemark,
      Sys.DateStr, lClassGuid]);
  end;
  Result := DBAccess.ExecuteSQL(lStrSql);
  if not Result then
  begin
    ShowMsg('角色信息保存失败！');
    Exit;
  end;
end;

procedure TFrmWorkerClassEdit.FormCreate(Sender: TObject);
begin
  inherited;
  ClearControls;
end;

procedure TFrmWorkerClassEdit.FormShow(Sender: TObject);
begin
  inherited;
  if FOperAction = 'Append' then
  begin
    chkAlwaysNew.Visible := True;
    chkAlwaysNew.Checked := Sys.GetAlwaysNew(Self.ClassName);
  end;
end;

end.
