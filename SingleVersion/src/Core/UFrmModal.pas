unit uFrmModal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFrmRoot, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus,
  ActnList, StdCtrls, cxButtons, ExtCtrls, HJYConsts, superobject, cxControls,
  DB;

type
  // 用来处理保存完数据后的刷新操作，
  // 如：管理窗体调用明细编辑窗体时，明细窗体保存后触发的操作，有管理窗体传入
  TAfterSave = procedure(ALocate: Boolean = False; AValue: string = '') of object;

  TFrmModal = class(TFrmRoot)
    pnlClient: TPanel;
    pnlBottom: TPanel;
    btnOk: TcxButton;
    btnCancel: TcxButton;
    bvl1: TBevel;
    actlst1: TActionList;
    actExit: TAction;
    procedure actExitExecute(Sender: TObject);
  private
    FDataSet: TDataSet;
    FOperKind: TOperKind;
    FOnAfterSave: TAfterSave;
  protected
    FKeyId: string;
    procedure SetOperKind(const AOperKind: TOperKind); virtual;
    procedure SetDataSet(const ADataSet: TDataSet); virtual;
    function IsEditMode: Boolean; virtual;
  public
    property OperKind: TOperKind read FOperKind write SetOperKind;
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property OnAfterSave: TAfterSave read FOnAfterSave write FOnAfterSave;
  public
    class function Execute(AOperKind: TOperKind; ADataSet: TDataSet = nil;
      AfterSave: TAfterSave = nil): Boolean;
  end;

var
  FrmModal: TFrmModal;

implementation

{$R *.dfm}

uses HJYDataProviders;

procedure TFrmModal.actExitExecute(Sender: TObject);
begin
  Close;
end;

class function TFrmModal.Execute(AOperKind: TOperKind; ADataSet: TDataSet;
  AfterSave: TAfterSave): Boolean;
begin
  with Self.Create(nil) do
  try
    OperKind := AOperKind;
    DataSet := ADataSet;
    OnAfterSave := AfterSave;
    Result := ShowModal = mrOk;
  finally
    Free;
  end;
end;

function TFrmModal.IsEditMode: Boolean;
begin
  Result := FOperKind = okUpdate;
end;

procedure TFrmModal.SetDataSet(const ADataSet: TDataSet);
begin
  FDataSet := ADataSet;
end;

procedure TFrmModal.SetOperKind(const AOperKind: TOperKind);
begin
  FOperKind := AOperKind;
end;

end.
