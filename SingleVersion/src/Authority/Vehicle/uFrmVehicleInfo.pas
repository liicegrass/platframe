unit uFrmVehicleInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmGrid, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB,
  cxDBData, dxSkinsdxBarPainter, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, ActnList, dxBar, DBClient, cxClasses, cxGridLevel,
  cxGridCustomView, cxGrid, ExtCtrls, cxTextEdit, cxImageComboBox, cxNavigator,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TFrmVehicleInfo = class(TFrmGrid)
    ClmnDriverName: TcxGridDBColumn;
    ClmnCarNo: TcxGridDBColumn;
    ClmnPhone: TcxGridDBColumn;
    ClmnCarKind: TcxGridDBColumn;
    ClmnIsStop: TcxGridDBColumn;
    ClmnRemark: TcxGridDBColumn;
    procedure grdbtblvwDataDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure grdbtblvwDataKeyPress(Sender: TObject; var Key: Char);
  private
    procedure ShowCarInfoCard(AAction: string);
    procedure QueryCarInfo(ALocate: Boolean = False; AValue: string = '');
  public

  end;

var
  FrmVehicleInfo: TFrmVehicleInfo;

implementation

uses HJYForms, uSysObj, UMsgBox, uFrmVehicle;

{$R *.dfm}

procedure TFrmVehicleInfo.QueryCarInfo(ALocate: Boolean; AValue: string);
var
  lStrSql: string;
begin
  lStrSql := 'select * from CarInfo';
  if not DBAccess.ReadDataSet(lStrSql, cdsData) then
  begin
    ShowMsg('获取司机及车辆信息失败！');
    Exit;
  end;
  if ALocate and (AValue <> '') then
    if cdsData.Active and not cdsData.IsEmpty then
      cdsData.Locate('Guid', AValue, [loCaseInsensitive]);
end;

procedure TFrmVehicleInfo.actEditExecute(Sender: TObject);
begin
  inherited;
  if not cdsData.Active or cdsData.IsEmpty then
    Exit;
  ShowCarInfoCard('Edit');
end;

procedure TFrmVehicleInfo.actNewExecute(Sender: TObject);
begin
  inherited;
  if not cdsData.Active then
    Exit;
  ShowCarInfoCard('Append');
end;

procedure TFrmVehicleInfo.actRefreshExecute(Sender: TObject);
begin
  inherited;
  QueryCarInfo;
end;

procedure TFrmVehicleInfo.FormShow(Sender: TObject);
begin
  inherited;
  QueryCarInfo;
end;

procedure TFrmVehicleInfo.grdbtblvwDataDblClick(Sender: TObject);
begin
  inherited;
  actEditExecute(nil);
end;

procedure TFrmVehicleInfo.grdbtblvwDataKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    actEditExecute(nil);
end;

procedure TFrmVehicleInfo.ShowCarInfoCard(AAction: string);
begin
  FrmVehicle := TFrmVehicle.Create(nil);
  try
    FrmVehicle.OperAction := AAction;
    if AAction = 'Append' then
    begin
      FrmVehicle.cbbIsStop.ItemIndex := 0;
      FrmVehicle.OnRefreshAfterPost := Self.QueryCarInfo;
    end
    else
    begin
      with FrmVehicle, cdsData do
      begin
        Guid := FindField('Guid').AsString;
        edtDriverName.Text := FindField('DriverName').AsString;
        edtCarNo.Text := FindField('CarNo').AsString;
        edtPhone.Text := FindField('Phone').AsString;
        edtCarKind.Text := FindField('CarKind').AsString;
        cbbIsStop.ItemIndex := FindField('IsStop').AsInteger;
        edtRemark.Text := FindField('Remark').AsString;
      end;
    end;
    if FrmVehicle.ShowModal = mrOk then
      QueryCarInfo(True, FrmVehicle.Guid);
  finally
    FreeAndNil(FrmVehicle);
  end;
end;

initialization
  HJYFormManager.RegisterForm(TFrmVehicleInfo);

end.
