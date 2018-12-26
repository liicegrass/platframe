unit UFrmCustomDBTreeList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrmRoot, cxClasses, dxBar, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxCustomData, cxStyles, cxTL, cxTLdxBarBuiltInMenu,
  cxInplaceContainer, cxTLData, cxDBTL, DB, DBClient, UDmImage, ExtCtrls,
  cxDataControllerConditionalFormattingRulesManagerDialog;

type
  TFrmCustomDBTreeList = class(TFrmRoot)
    BarManager: TdxBarManager;
    BarTool: TdxBar;
    cdsData: TClientDataSet;
    dsData: TDataSource;
    pnlClient: TPanel;
    tvData: TcxDBTreeList;
  private

  public

  end;

var
  FrmCustomDBTreeList: TFrmCustomDBTreeList;

implementation

{$R *.dfm}

end.
