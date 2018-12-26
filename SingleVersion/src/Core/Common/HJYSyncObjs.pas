unit HJYSyncObjs;

interface

uses SysUtils, Windows;

type
  THJYCriticalSection = class(TObject)
  private
    FHandle: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Enter;
    procedure Leave;
  end;

implementation

{ THJYCriticalSection }

constructor THJYCriticalSection.Create;
begin
  InitializeCriticalSection(FHandle);
end;

destructor THJYCriticalSection.Destroy;
begin
  DeleteCriticalSection(FHandle);
  inherited;
end;

procedure THJYCriticalSection.Enter;
begin
  EnterCriticalSection(FHandle);
end;

procedure THJYCriticalSection.Leave;
begin
  LeaveCriticalSection(FHandle);
end;

end.
