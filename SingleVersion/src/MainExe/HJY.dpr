program HJY;

uses
  Forms,
  SysUtils,
  HJYSysInit in 'HJYSysInit.pas',
  UFrmMain in 'UFrmMain.pas' {FrmMain},
  UFrmLogin in 'UFrmLogin.pas' {FrmLogin},
  UFrmAbout in 'UFrmAbout.pas' {FrmAbout},
  UFrmPassEdit in 'UFrmPassEdit.pas' {FrmPassEdit},
  UFrmRightInfo in 'UFrmRightInfo.pas' {FrmRightInfo},
  UDmMain in 'UDmMain.pas' {DmMain: TDataModule},
  UFrmDiaog in 'UFrmDiaog.pas' {FrmDiaog},
  UFrmRoot in '..\Core\UFrmRoot.pas' {FrmRoot},
  UDmImage in '..\Core\UDmImage.pas' {DmImage: TDataModule},
  UFrmBar in '..\Core\UFrmBar.pas' {FrmBar},
  UFrmCustomDBBandedTable in '..\Core\UFrmCustomDBBandedTable.pas' {FrmCustomDBBandedTable},
  UFrmCustomDBTreeList in '..\Core\UFrmCustomDBTreeList.pas' {FrmCustomDBTreeList},
  UFrmGrid in '..\Core\UFrmGrid.pas' {FrmGrid},
  UFrmModal in '..\Core\UFrmModal.pas' {FrmModal},
  CnAES in '..\Core\Common\CnAES.pas',
  CnMD5 in '..\Core\Common\CnMD5.pas',
  HJYClassHelper in '..\Core\Common\HJYClassHelper.pas',
  HJYConsts in '..\Core\Common\HJYConsts.pas',
  HJYCryptors in '..\Core\Common\HJYCryptors.pas',
  HJYDataProviders in '..\Core\Common\HJYDataProviders.pas',
  HJYDataRecords in '..\Core\Common\HJYDataRecords.pas',
  HJYDBAccesses in '..\Core\Common\HJYDBAccesses.pas',
  HJYDBUtils in '..\Core\Common\HJYDBUtils.pas',
  HJYDialogs in '..\Core\Common\HJYDialogs.pas',
  HJYForms in '..\Core\Common\HJYForms.pas',
  HJYStoreProcParams in '..\Core\Common\HJYStoreProcParams.pas',
  HJYThreads in '..\Core\Common\HJYThreads.pas',
  HJYUserInfos in '..\Core\Common\HJYUserInfos.pas',
  HJYUtils in '..\Core\Common\HJYUtils.pas',
  HJYValidationChecks in '..\Core\Common\HJYValidationChecks.pas',
  HJYVersionInfos in '..\Core\Common\HJYVersionInfos.pas',
  sevenzip in '..\Core\Common\sevenzip.pas',
  superobject in '..\Core\Common\superobject.pas',
  UniDBAccessesImpl in '..\Core\Common\UniDBAccessesImpl.pas',
  HJYLoggers in '..\Core\Common\HJYLoggers.pas',
  HJYSyncObjs in '..\Core\Common\HJYSyncObjs.pas';

{$R *.res}
//{$R uac.res}

begin
  Application.Initialize;
  Application.Title := '客户端开发基础框架';
  Application.MainFormOnTaskbar := True;
  if not ShowLogin then Exit;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
