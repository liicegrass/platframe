unit uFrmGrid;

interface

uses
  Windows, UFrmBar, dxSkinsCore, dxSkinsdxBarPainter, dxSkinsDefaultPainters,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, DB,
  cxDBData, DBClient, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, Controls,
  ExtCtrls, Classes, ActnList, dxBar, cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TFrmGrid = class(TFrmBar)
    grdbtblvwData: TcxGridDBTableView;
    grdlvlData: TcxGridLevel;
    grdData: TcxGrid;
    pnlTop: TPanel;
    dsData: TDataSource;
    pnlClient: TPanel;
    cdsData: TClientDataSet;
    procedure actExportExecute(Sender: TObject);
  private

  public

  end;

var
  FrmGrid: TFrmGrid;

implementation

uses UDmImage, HJYUtils;

{$R *.dfm}

procedure TFrmGrid.actExportExecute(Sender: TObject);
begin
  inherited;
  if not cdsData.Active or cdsData.IsEmpty then
    Exit;
  ExportToExcel(Self.Caption + '.xls', grdData);
end;

end.
