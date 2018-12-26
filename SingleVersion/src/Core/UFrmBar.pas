unit UFrmBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrmRoot, dxSkinsCore, dxSkinsdxBarPainter, dxSkinsDefaultPainters,
  dxBar, cxClasses, ActnList;

type
  TFrmBar = class(TFrmRoot)
    dxbrmngr1: TdxBarManager;
    dxbrmngr1Bar1: TdxBar;
    btnNew: TdxBarLargeButton;
    btnEdit: TdxBarLargeButton;
    btnDelete: TdxBarLargeButton;
    btnQuery: TdxBarLargeButton;
    btnDesign: TdxBarLargeButton;
    btnPrint: TdxBarLargeButton;
    btnExport: TdxBarLargeButton;
    actlst1: TActionList;
    actNew: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actQuery: TAction;
    actPrint: TAction;
    actExit: TAction;
    actExport: TAction;
    actImport: TAction;
    actDesign: TAction;
    actSave: TAction;
    actCancel: TAction;
    btnSave: TdxBarLargeButton;
    btnCancel: TdxBarLargeButton;
  private

  public

  end;

var
  FrmBar: TFrmBar;

implementation

uses UDmImage;

{$R *.dfm}

end.
