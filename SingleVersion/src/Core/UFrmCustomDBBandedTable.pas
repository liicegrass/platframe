unit UFrmCustomDBBandedTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrmRoot, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, DB, cxDBData, DBClient, dxBar, cxClasses,
  cxGridLevel, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridBandedTableView, cxGridDBBandedTableView, cxGrid, ExtCtrls, UDmImage,
  cxCurrencyEdit, cxGridDBTableView, cxSpinEdit,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TFrmCustomDBBandedTable = class(TFrmRoot)
    pnlClient: TPanel;
    grdData: TcxGrid;
    grdbndtblvwData: TcxGridDBBandedTableView;
    grdlvlData: TcxGridLevel;
    pnlTop: TPanel;
    BarManager: TdxBarManager;
    BarTool: TdxBar;
    cdsData: TClientDataSet;
    dsData: TDataSource;
  private
    procedure ColumnGetDisplayText(Sender: TcxCustomGridTableItem;
      ARecord: TcxCustomGridRecord; var AText: string);

  protected
    procedure CreateCurrencyFootrtSummary;
    procedure GridHideZero(AGrid: TcxGridTableView);
  public

  end;

var
  FrmCustomDBBandedTable: TFrmCustomDBBandedTable;

implementation

{$R *.dfm}

procedure TFrmCustomDBBandedTable.CreateCurrencyFootrtSummary;
var
  I: Integer;
  lColumn: TcxGridDBBandedColumn;
  lSummaryItem: TcxGridDBTableSummaryItem;
begin
  with grdbndtblvwData do
  begin
    DataController.Summary.FooterSummaryItems.BeginUpdate;
    try
      for I := 0 to ColumnCount - 1 do
      begin
        lColumn := Columns[I];
        if lColumn.PropertiesClass = TcxCurrencyEditProperties then
        begin
          lSummaryItem := TcxGridDBTableSummaryItem(DataController.Summary.FooterSummaryItems.Add);
          lSummaryItem.Kind := skSum;
          lSummaryItem.Format := ',#.##;-,#.##';
          lSummaryItem.Column := lColumn;
        end;
      end;
    finally
      DataController.Summary.FooterSummaryItems.EndUpdate;
    end;
  end;
end;

procedure TFrmCustomDBBandedTable.ColumnGetDisplayText(
  Sender: TcxCustomGridTableItem; ARecord: TcxCustomGridRecord; var AText: string);
var
  lValue: Variant;
begin
  lValue := Sender.EditValue;
  if VarIsNull(lValue) or VarIsEmpty(lValue) or not VarIsFloat(lValue) then
    AText := ''
  else if lValue = 0 then
    AText := '';
end;

procedure TFrmCustomDBBandedTable.GridHideZero(AGrid: TcxGridTableView);
var
  I: Integer;
  lColumn: TcxGridColumn;
begin
  for I := 0 to AGrid.ColumnCount - 1 do
  begin
    lColumn := AGrid.Columns[I];
    if (lColumn.PropertiesClass = TcxCurrencyEditProperties)
      or (lColumn.PropertiesClass = TcxSpinEditProperties) then
      lColumn.OnGetDisplayText := ColumnGetDisplayText;
  end;
end;

end.
